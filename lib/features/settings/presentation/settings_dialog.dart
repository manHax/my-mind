import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../sync/infrastructure/github_note_repository.dart';
import '../../sync/infrastructure/github_auth_service.dart';
import '../../workspace/infrastructure/workspace_repository.dart';
import '../../sync/application/sync_service.dart';

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspacePath = ref.watch(workspaceRepoProvider);
    final authState = ref.watch(githubAuthNotifierProvider);
    
    return AlertDialog(
      title: const Text('Settings'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cloud Storage Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      workspacePath ?? 'No workspace selected',
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('GitHub Integration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: authState.accessToken != null 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    authState.accessToken != null ? Icons.check_circle : Icons.error,
                    color: authState.accessToken != null ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    authState.accessToken != null ? 'Connected securely via PAT' : 'Not Connected',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: authState.accessToken != null ? Colors.green[800] : Colors.red[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Editor Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Consumer(
              builder: (context, ref, child) {
                final isAutoSave = ref.watch(autoSaveProvider);
                return SwitchListTile(
                  title: const Text('Auto-save Notes'),
                  subtitle: const Text('Automatically sync changes to GitHub as you type.'),
                  value: isAutoSave,
                  onChanged: (val) => ref.read(autoSaveProvider.notifier).toggle(),
                  contentPadding: EdgeInsets.zero,
                );
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Disconnect Workspace', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  ref.read(sharedPreferencesProvider).remove('github_token');
                  ref.read(sharedPreferencesProvider).remove('github_repo');
                  ref.read(githubAuthNotifierProvider.notifier).setToken('');
                  ref.read(workspaceRepoProvider.notifier).set(null);
                  context.go('/');
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text('Close'),
        ),
      ],
    );
  }
}
