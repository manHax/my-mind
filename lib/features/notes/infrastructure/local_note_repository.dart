import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import '../domain/note.dart';
import 'markdown_parser.dart';

class WorkspacePathNotifier extends Notifier<String?> {
  @override
  String? build() => null;
}
final workspacePathProvider = NotifierProvider<WorkspacePathNotifier, String?>(WorkspacePathNotifier.new);

final localNoteRepositoryProvider = Provider<LocalNoteRepository?>((ref) {
  final path = ref.watch(workspacePathProvider);
  if (path == null) return null;
  return LocalNoteRepository(workspacePath: path);
});

class LocalNoteRepository {
  final String workspacePath;

  LocalNoteRepository({required this.workspacePath});

  Future<List<Note>> getAllNotes() async {
    final notes = <Note>[];
    if (kIsWeb) return notes; // Browser cannot read local folders

    final dir = Directory(workspacePath);
    if (!await dir.exists()) return notes;

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.md')) {
        final content = await entity.readAsString();
        // Convert to a normalized relative path (using forward slashes standard for the app identity)
        final relativePath = p.relative(entity.path, from: workspacePath).replaceAll(r'\', '/');
        notes.add(MarkdownParser.parse(content, relativePath));
      }
    }
    return notes;
  }

  Future<void> saveNote(Note note) async {
    if (kIsWeb) {
      print('Web Mode: Note saved in-memory (File IO is disabled).');
      return;
    }
    
    final file = File(p.join(workspacePath, note.path));
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    final content = MarkdownParser.stringify(note);
    await file.writeAsString(content);
  }

  Future<void> deleteNote(Note note) async {
    if (kIsWeb) return;
    
    final file = File(p.join(workspacePath, note.path));
    if (await file.exists()) {
      await file.delete();
    }
  }
}
