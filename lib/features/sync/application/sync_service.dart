import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../notes/domain/note.dart';
import '../../notes/domain/note_metadata.dart';
import '../../notes/infrastructure/markdown_parser.dart';
import '../infrastructure/github_note_repository.dart';

enum SyncState { idle, syncing, success, error }

class SyncStateNotifier extends Notifier<SyncState> {
  @override
  SyncState build() => SyncState.idle;
  void set(SyncState s) => state = s;
}
final syncStateProvider = NotifierProvider<SyncStateNotifier, SyncState>(SyncStateNotifier.new);

class SyncMessageNotifier extends Notifier<String> {
  @override
  String build() => 'All notes saved';
  void set(String m) => state = m;
}
final syncMessageProvider = NotifierProvider<SyncMessageNotifier, String>(SyncMessageNotifier.new);

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(ref);
});

class SyncService {
  final Ref _ref;
  Timer? _debounceTimer;
  bool _isSyncing = false;

  SyncService(this._ref);

  Future<void> onStartup() async {
    print('SyncService: Cloud Mode Started. Ready to push to GitHub API.');
  }

  void triggerAutoSync(String content, String notePath) {
    // Show typing status (optional, but good UX)
    _ref.read(syncStateProvider.notifier).set(SyncState.idle);
    _ref.read(syncMessageProvider.notifier).set('Waiting to save...');
    
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 5), () {
      _executeAutoSync(content, notePath);
    });
  }

  Future<void> _executeAutoSync(String content, String notePath) async {
    if (_isSyncing) return;
    _isSyncing = true;
    
    _ref.read(syncStateProvider.notifier).set(SyncState.syncing);
    _ref.read(syncMessageProvider.notifier).set('Saving to Cloud...');

    try {
      final repo = _ref.read(githubNoteRepositoryProvider);
      if (repo == null) {
        throw Exception('Not connected to GitHub.');
      }
      
      // Get the cached metadata (so we don't lose created timestamp, tags, etc.)
      final currentMetadata = _ref.read(activeNoteMetadataProvider);
      
      // Parse the raw content from TextField in case user typed their own frontmatter manually
      Note parsedNote = MarkdownParser.parse(content, notePath);
      
      // If the user didn't type new frontmatter, use the cached one, otherwise use what they typed
      NoteMetadata metaToUse = currentMetadata ?? parsedNote.metadata;
      
      // Auto-extract title from the current text editor content (the H1 or filename)
      final extractedTitle = MarkdownParser.extractTitle(parsedNote.content.isEmpty && content.isNotEmpty ? content : parsedNote.content, notePath);
      
      // Update the 'updated' timestamp and the extracted title
      metaToUse = metaToUse.copyWith(
        title: extractedTitle,
        updated: DateTime.now(),
      );
      
      // Re-construct the Note
      final noteToSave = Note(
        path: notePath,
        metadata: metaToUse,
        content: parsedNote.content.isEmpty && content.isNotEmpty ? content : parsedNote.content,
      );

      await repo.saveNote(noteToSave);
      
      _ref.read(syncStateProvider.notifier).set(SyncState.success);
      _ref.read(syncMessageProvider.notifier).set('Saved to Cloud');
    } catch (e) {
      _ref.read(syncStateProvider.notifier).set(SyncState.error);
      _ref.read(syncMessageProvider.notifier).set('Sync Failed');
      print('SyncService: Auto-sync flow failed: $e');
    } finally {
      _isSyncing = false;
    }
  }
}
