import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sync/infrastructure/github_note_repository.dart';
import '../infrastructure/markdown_parser.dart';
import '../domain/note_metadata.dart';

// Provider to hold the list of file paths
final notesListProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(githubNoteRepositoryProvider);
  if (repo == null) return [];
  return await repo.fetchAllMarkdownFiles();
});

class CurrentNotePathNotifier extends Notifier<String> {
  @override
  String build() => 'Welcome.md';
  void set(String path) => state = path;
}
final currentNotePathProvider = NotifierProvider<CurrentNotePathNotifier, String>(CurrentNotePathNotifier.new);

// Provider to hold the metadata of the currently active file (hidden from UI)
class ActiveNoteMetadataNotifier extends Notifier<NoteMetadata?> {
  @override
  NoteMetadata? build() => null;
  void set(NoteMetadata? meta) => state = meta;
}
final activeNoteMetadataProvider = NotifierProvider<ActiveNoteMetadataNotifier, NoteMetadata?>(ActiveNoteMetadataNotifier.new);

// Provider to hold the text content of the currently active file (body only)
class ActiveNoteContentNotifier extends Notifier<String> {
  @override
  String build() => '';

  Future<void> loadContent(String path) async {
    final repo = ref.read(githubNoteRepositoryProvider);
    if (repo == null) return;
    
    // Reset while loading
    state = 'Loading...';
    
    try {
      final rawContent = await repo.fetchNoteContent(path);
      
      // Parse to separate metadata from body
      final parsedNote = MarkdownParser.parse(rawContent, path);
      
      // Store metadata separately so it doesn't show in TextField
      ref.read(activeNoteMetadataProvider.notifier).set(parsedNote.metadata);
      
      // Display only the body content
      state = parsedNote.content;
    } catch (e) {
      state = 'Error loading content: $e';
    }
  }

  void updateContent(String newContent) {
    state = newContent;
  }
}

final activeNoteContentProvider = NotifierProvider<ActiveNoteContentNotifier, String>(ActiveNoteContentNotifier.new);
