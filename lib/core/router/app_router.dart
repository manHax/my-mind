import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/workspace/presentation/workspace_selector_screen.dart';
import '../../features/notes/presentation/workspace_screen.dart';
import '../../features/notes/presentation/shared_note_screen.dart';
import '../../features/sync/infrastructure/github_note_repository.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          // If a GitHub repo is mounted, go to the workspace.
          final repo = ref.watch(workspaceRepoProvider);
          if (repo != null) {
            return const WorkspaceScreen();
          }
          return const WorkspaceSelectorScreen();
        },
      ),
      GoRoute(
        path: '/workspace',
        builder: (context, state) => const WorkspaceScreen(),
      ),
      GoRoute(
        path: '/share/:gistId',
        builder: (context, state) {
          final gistId = state.pathParameters['gistId']!;
          return SharedNoteScreen(gistId: gistId);
        },
      ),
    ],
  );
});
