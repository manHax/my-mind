import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sync/infrastructure/github_note_repository.dart';
import '../../sync/infrastructure/github_auth_service.dart';

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
