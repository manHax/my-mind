import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../domain/note.dart';
import '../domain/note_metadata.dart';
import '../../sync/application/sync_service.dart';
import '../../sync/infrastructure/github_note_repository.dart';
import '../../settings/presentation/settings_dialog.dart';
import '../application/notes_providers.dart';

class WorkspaceScreen extends ConsumerStatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  ConsumerState<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends ConsumerState<WorkspaceScreen> {
  late TextEditingController _controller;

  Future<void> _createNewNote(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Note'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'File Path (e.g. ideas/app.md)',
            hintText: 'NewNote.md',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Create')),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      String newPath = result.endsWith('.md') ? result : '$result.md';
      ref.read(syncStateProvider.notifier).set(SyncState.syncing);
      ref.read(syncMessageProvider.notifier).set('Creating $newPath...');
      try {
        final repo = ref.read(githubNoteRepositoryProvider);
        await repo?.saveNote(Note(
          path: newPath,
          metadata: NoteMetadata(title: newPath, created: DateTime.now(), updated: DateTime.now()),
          content: '# ${newPath.split('/').last.replaceAll('.md', '')}\n\nStart typing here...',
        ));
        ref.invalidate(notesListProvider);
        ref.read(currentNotePathProvider.notifier).set(newPath);
        ref.read(activeNoteContentProvider.notifier).loadContent(newPath);
        ref.read(syncStateProvider.notifier).set(SyncState.success);
        ref.read(syncMessageProvider.notifier).set('File created');
      } catch (e) {
        ref.read(syncStateProvider.notifier).set(SyncState.error);
        ref.read(syncMessageProvider.notifier).set('Failed to create');
      }
    }
  }

  Future<void> _renameCurrentNote(BuildContext context, WidgetRef ref) async {
    final currentPath = ref.read(currentNotePathProvider);
    final controller = TextEditingController(text: currentPath);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename or Move Note'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'New File Path',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Rename')),
        ],
      ),
    );

    if (result != null && result != currentPath && result.isNotEmpty) {
      String newPath = result.endsWith('.md') ? result : '$result.md';
      ref.read(syncStateProvider.notifier).set(SyncState.syncing);
      ref.read(syncMessageProvider.notifier).set('Renaming...');
      try {
        final repo = ref.read(githubNoteRepositoryProvider);
        final content = ref.read(activeNoteContentProvider);
        await repo?.renameNote(currentPath, newPath, content);
        
        ref.invalidate(notesListProvider);
        ref.read(currentNotePathProvider.notifier).set(newPath);
        ref.read(syncStateProvider.notifier).set(SyncState.success);
        ref.read(syncMessageProvider.notifier).set('Renamed to $newPath');
      } catch (e) {
        ref.read(syncStateProvider.notifier).set(SyncState.error);
        ref.read(syncMessageProvider.notifier).set('Failed to rename');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(activeNoteContentProvider));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncServiceProvider).onStartup();
      // Load the default file content if any files exist
      final repo = ref.read(notesListProvider.future).then((notes) {
        if (notes.isNotEmpty) {
          final first = notes.first;
          ref.read(currentNotePathProvider.notifier).set(first);
          ref.read(activeNoteContentProvider.notifier).loadContent(first);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeNoteContent = ref.watch(activeNoteContentProvider);
    final currentPath = ref.watch(currentNotePathProvider);

    // Sync TextEditingController with outside changes (like when clicking a different file)
    if (_controller.text != activeNoteContent && 
        activeNoteContent != 'Loading...' && 
        !activeNoteContent.startsWith('Error loading')) {
      _controller.value = TextEditingValue(
        text: activeNoteContent,
        selection: TextSelection.collapsed(offset: activeNoteContent.length),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('My Mind', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            const SizedBox(width: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit_document, size: 14, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(currentPath, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary, fontFamily: 'monospace')),
                ],
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            tooltip: 'Rename / Move Note',
            icon: const Icon(Icons.drive_file_rename_outline),
            onPressed: () => _renameCurrentNote(context, ref),
          ),
          const SizedBox(width: 16),
          const SyncStatusIndicator(),
          const SizedBox(width: 24),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              border: Border(
                right: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'EXPLORER',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add_box_outlined, size: 16),
                              tooltip: 'New Note',
                              onPressed: () => _createNewNote(context, ref),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh, size: 16),
                              tooltip: 'Refresh Cloud',
                              onPressed: () => ref.refresh(notesListProvider),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final notesAsync = ref.watch(notesListProvider);
                        return notesAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(fontSize: 12))),
                          data: (notes) {
                            if (notes.isEmpty) return const Center(child: Text('No .md files found.'));
                            
                            return ListView.builder(
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                final path = notes[index];
                                final isSelected = path == currentPath;
                                
                                return ListTile(
                                  leading: Icon(Icons.description_outlined, 
                                    size: 18, 
                                    color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant
                                  ),
                                  title: Text(path.split('/').last, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
                                  subtitle: path.contains('/') ? Text(path, style: const TextStyle(fontSize: 10)) : null,
                                  selected: isSelected,
                                  selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  onTap: () {
                                    ref.read(currentNotePathProvider.notifier).set(path);
                                    ref.read(activeNoteContentProvider.notifier).loadContent(path);
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.settings, size: 20),
                    title: const Text('Settings', style: TextStyle(fontSize: 14)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => const SettingsDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Editor
          Expanded(
            child: activeNoteContent == 'Loading...' 
                ? const Center(child: CircularProgressIndicator()) 
                : Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Start writing...',
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontFamily: 'monospace',
                      ),
                      onChanged: (val) {
                        ref.read(activeNoteContentProvider.notifier).updateContent(val);
                        ref.read(syncServiceProvider).triggerAutoSync(val, currentPath);
                      },
                    ),
                  ),
          ),
          
          // Divider
          Container(
            width: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
          
          // Live Preview
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              child: Markdown(
                data: activeNoteContent,
                padding: const EdgeInsets.all(40),
                styleSheet: MarkdownStyleSheet(
                  h1: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  h2: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  p: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SyncStatusIndicator extends ConsumerWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(syncStateProvider);
    final message = ref.watch(syncMessageProvider);
    
    IconData icon;
    Color color;
    
    switch (state) {
      case SyncState.syncing:
        icon = Icons.sync;
        color = Theme.of(context).colorScheme.primary;
        break;
      case SyncState.success:
        icon = Icons.cloud_done;
        color = Colors.green;
        break;
      case SyncState.error:
        icon = Icons.cloud_off;
        color = Colors.red;
        break;
      case SyncState.idle:
      default:
        icon = Icons.cloud_queue;
        color = Theme.of(context).colorScheme.onSurfaceVariant;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state == SyncState.syncing) 
            SizedBox(
              width: 14, 
              height: 14, 
              child: CircularProgressIndicator(strokeWidth: 2, color: color)
            )
          else 
            Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(message, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
