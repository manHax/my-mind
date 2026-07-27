# Graph Report - my-mind  (2026-07-27)

## Corpus Check
- 53 files · ~20,848 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 460 nodes · 603 edges · 63 communities (20 shown, 43 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 20 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `fe685a8c`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Windows Runner Win32
- Sync & GitHub Auth
- iOS & macOS Runner
- Notes Providers & Screen
- Note & Workspace Models
- App Router Navigation
- Local Note Repo & Git
- Linux Runner Application
- Workspace Repo & Main
- Shared Note Screen
- Windows Main Utils
- Web Manifest
- Windows Plugin Registrant
- Pubspec Config
- Windows CMakeLists
- Android Main Activity
- Linux CMakeLists
- Web Github Deploy
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- Icon/Config Artifacts
- README.md

## God Nodes (most connected - your core abstractions)
1. `Win32Window` - 22 edges
2. `_WorkspaceScreenState` - 13 edges
3. `MessageHandler` - 12 edges
4. `sharedPreferencesProvider` - 11 edges
5. `FlutterWindow` - 10 edges
6. `Create` - 10 edges
7. `WndProc` - 10 edges
8. `build` - 9 edges
9. `MessageHandler` - 9 edges
10. `currentNotePathProvider` - 8 edges

## Surprising Connections (you probably didn't know these)
- `Deploy Flutter Web to GitHub Pages` --conceptually_related_to--> `Web Base Href`  [INFERRED]
  .github/workflows/deploy-web.yml → web/index.html
- `my_mind Package` --conceptually_related_to--> `Flutter Lints`  [INFERRED]
  pubspec.yaml → analysis_options.yaml
- `build` --references--> `sharedPreferencesProvider`  [EXTRACTED]
  lib/features/sync/infrastructure/github_auth_service.dart → lib/features/workspace/infrastructure/workspace_repository.dart
- `OnCreate` --calls--> `RegisterPlugins()`  [INFERRED]
  windows/runner/flutter_window.h → windows/flutter/generated_plugin_registrant.cc
- `wWinMain()` --calls--> `CreateAndAttachConsole()`  [INFERRED]
  windows/runner/main.cpp → windows/runner/utils.cpp

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Application Build Configurations** — linux_cmakelists_my_mind, windows_cmakelists_my_mind, _github_workflows_deploy_web_build_and_deploy [INFERRED 0.85]

## Communities (63 total, 43 thin omitted)

### Community 0 - "Windows Runner Win32"
Cohesion: 0.07
Nodes (51): Point, RECT, Size, unique_ptr, DartProject, HWND, LPARAM, LRESULT (+43 more)

### Community 1 - "Sync & GitHub Auth"
Cohesion: 0.06
Nodes (41): dart:async, github_auth_service.dart, ../infrastructure/github_note_repository.dart, CurrentNotePathNotifier, WorkspacePathNotifier, AutoSaveNotifier, build, _debounceTimer (+33 more)

### Community 2 - "iOS & macOS Runner"
Cohesion: 0.06
Nodes (29): Any, Cocoa, file_picker, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterMacOS (+21 more)

### Community 3 - "Notes Providers & Screen"
Cohesion: 0.11
Nodes (36): ../application/notes_providers.dart, ConsumerStatefulWidget, ../infrastructure/markdown_parser.dart, ActiveNoteContentNotifier, activeNoteContentProvider, activeNoteMetadataProvider, build, currentNotePathProvider (+28 more)

### Community 4 - "Note & Workspace Models"
Cohesion: 0.06
Nodes (35): @immutable, DateTime, int get, ActiveNoteMetadataNotifier, content, copyWith, metadata, hashCode (+27 more)

### Community 5 - "App Router Navigation"
Cohesion: 0.07
Nodes (35): class, ConsumerState, ConsumerWidget, ../../features/notes/presentation/shared_note_screen.dart, ../../features/notes/presentation/workspace_screen.dart, ../../features/sync/infrastructure/github_note_repository.dart, ../../features/workspace/presentation/workspace_selector_screen.dart, GoRouter (+27 more)

### Community 6 - "Local Note Repo & Git"
Cohesion: 0.11
Nodes (18): Exception, commit, connectToRemote, fetch, GitConflictException, GitService, gitServiceProvider, hasChanges (+10 more)

### Community 7 - "Linux Runner Application"
Cohesion: 0.09
Nodes (22): FlPluginRegistry, FlView, GApplication, gboolean, gchar, GObject, GtkApplication, fl_register_plugins() (+14 more)

### Community 8 - "Workspace Repo & Main"
Cohesion: 0.09
Nodes (22): core/router/app_router.dart, dart:convert, ../domain/workspace.dart, features/workspace/infrastructure/workspace_repository.dart, routerProvider, getLastOpenedWorkspaceId, getRecentWorkspaces, _getWorkspacesMap (+14 more)

### Community 9 - "Shared Note Screen"
Cohesion: 0.13
Nodes (15): build, _content, createState, _error, _fetchGist, _filename, gistId, initState (+7 more)

### Community 10 - "Windows Main Utils"
Cohesion: 0.24
Nodes (9): _In_, _In_opt_, vector, wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments() (+1 more)

### Community 11 - "Web Manifest"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 13 - "Pubspec Config"
Cohesion: 0.50
Nodes (4): Riverpod State Management, Auto-Sync, Markdown Native, My Mind

### Community 14 - "Windows CMakeLists"
Cohesion: 0.67
Nodes (4): Windows my_mind Binary, Windows flutter_assemble, Windows flutter_wrapper_app, Windows runner

### Community 16 - "Linux CMakeLists"
Cohesion: 0.67
Nodes (3): Linux my_mind Binary, Linux flutter_assemble, Linux runner

### Community 47 - "Icon/Config Artifacts"
Cohesion: 0.09
Nodes (21): dart:io, ../domain/note.dart, ../domain/note_metadata.dart, build, deleteNote, getAllNotes, LocalNoteRepository, localNoteRepositoryProvider (+13 more)

## Knowledge Gaps
- **179 isolated node(s):** `repo`, `fetchAllMarkdownFiles`, `build`, `updateContent`, `path` (+174 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **43 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `FlutterWindow` connect `Windows Runner Win32` to `iOS & macOS Runner`?**
  _High betweenness centrality (0.035) - this node is a cross-community bridge._
- **Why does `NoteMetadata` connect `Note & Workspace Models` to `Notes Providers & Screen`?**
  _High betweenness centrality (0.032) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `MessageHandler` (e.g. with `Destroy` and `GetClientArea`) actually correct?**
  _`MessageHandler` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `repo`, `fetchAllMarkdownFiles`, `build` to the rest of the system?**
  _179 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Windows Runner Win32` be split into smaller, more focused modules?**
  _Cohesion score 0.06594071385359952 - nodes in this community are weakly interconnected._
- **Should `Sync & GitHub Auth` be split into smaller, more focused modules?**
  _Cohesion score 0.05758582502768549 - nodes in this community are weakly interconnected._
- **Should `iOS & macOS Runner` be split into smaller, more focused modules?**
  _Cohesion score 0.05647840531561462 - nodes in this community are weakly interconnected._