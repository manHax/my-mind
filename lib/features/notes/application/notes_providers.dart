import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sync/infrastructure/github_note_repository.dart';

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

// Provider to hold the text content of the currently active file
class ActiveNoteContentNotifier extends Notifier<String> {
  @override
  String build() => '';

  Future<void> loadContent(String path) async {
    final repo = ref.read(githubNoteRepositoryProvider);
    if (repo == null) return;
    
    // Reset while loading
    state = 'Loading...';
    
    try {
      final content = await repo.fetchNoteContent(path);
      state = content;
    } catch (e) {
      state = 'Error loading content: $e';
    }
  }

  void updateContent(String newContent) {
    state = newContent;
  }
}

final activeNoteContentProvider = NotifierProvider<ActiveNoteContentNotifier, String>(ActiveNoteContentNotifier.new);
