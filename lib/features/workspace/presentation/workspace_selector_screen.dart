import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../sync/infrastructure/github_auth_service.dart';
import '../../sync/infrastructure/github_note_repository.dart';

class WorkspaceSelectorScreen extends ConsumerStatefulWidget {
  const WorkspaceSelectorScreen({super.key});

  @override
  ConsumerState<WorkspaceSelectorScreen> createState() =>
      _WorkspaceSelectorScreenState();
}

class _WorkspaceSelectorScreenState
    extends ConsumerState<WorkspaceSelectorScreen> {
  final TextEditingController _repoController = TextEditingController(
    text: 'manHax/my-blog',
  );
  final TextEditingController _tokenController = TextEditingController();

  @override
  void dispose() {
    _repoController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.cloud_done,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'My Mind (Cloud Native)',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Text(
                'Enter your GitHub Personal Access Token (PAT) and target repository to sync your notes.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _tokenController,
                obscureText: true, // Hides the token as dots
                decoration: const InputDecoration(
                  labelText: 'Personal Access Token (ghp_...)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.key),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _repoController,
                decoration: const InputDecoration(
                  labelText: 'Target Repository (owner/repo)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.folder_shared),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  final token = _tokenController.text.trim();
                  final repo = _repoController.text.trim();

                  if (token.isEmpty || repo.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill out both fields.'),
                      ),
                    );
                    return;
                  }

                  ref.read(githubAuthNotifierProvider.notifier).setToken(token);
                  ref.read(workspaceRepoProvider.notifier).set(repo);
                  context.go('/workspace');
                },
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Mount Cloud Workspace'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
