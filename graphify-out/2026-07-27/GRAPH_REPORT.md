# Graph Report - .  (2026-07-27)

## Corpus Check
- Corpus is ~20,148 words - fits in a single context window. You may not need a graph.

## Summary
- 449 nodes · 571 edges · 62 communities (19 shown, 43 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 20 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

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

## God Nodes (most connected - your core abstractions)
1. `Win32Window` - 22 edges
2. `MessageHandler` - 12 edges
3. `_WorkspaceScreenState` - 10 edges
4. `FlutterWindow` - 10 edges
5. `Create` - 10 edges
6. `WndProc` - 10 edges
7. `MessageHandler` - 9 edges
8. `sharedPreferencesProvider` - 8 edges
9. `currentNotePathProvider` - 7 edges
10. `activeNoteContentProvider` - 7 edges

## Surprising Connections (you probably didn't know these)
- `Deploy Flutter Web to GitHub Pages` --conceptually_related_to--> `Web Base Href`  [INFERRED]
  .github/workflows/deploy-web.yml → web/index.html
- `my_mind Package` --conceptually_related_to--> `Flutter Lints`  [INFERRED]
  pubspec.yaml → analysis_options.yaml
- `OnCreate` --calls--> `RegisterPlugins()`  [INFERRED]
  windows/runner/flutter_window.h → windows/flutter/generated_plugin_registrant.cc
- `wWinMain()` --calls--> `CreateAndAttachConsole()`  [INFERRED]
  windows/runner/main.cpp → windows/runner/utils.cpp
- `Win32Window::Win32Window()` --calls--> `Destroy`  [INFERRED]
  windows/runner/win32_window.cpp → windows/runner/win32_window.h

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Application Build Configurations** — linux_cmakelists_my_mind, windows_cmakelists_my_mind, _github_workflows_deploy_web_build_and_deploy [INFERRED 0.85]

## Communities (62 total, 43 thin omitted)

### Community 0 - "Windows Runner Win32"
Cohesion: 0.07
Nodes (51): Point, RECT, Size, unique_ptr, DartProject, HWND, LPARAM, LRESULT (+43 more)

### Community 1 - "Sync & GitHub Auth"
Cohesion: 0.05
Nodes (43): dart:async, github_auth_service.dart, ../infrastructure/github_note_repository.dart, CurrentNotePathNotifier, WorkspacePathNotifier, build, _debounceTimer, _executeAutoSync (+35 more)

### Community 2 - "iOS & macOS Runner"
Cohesion: 0.06
Nodes (29): Any, Cocoa, file_picker, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterMacOS (+21 more)

### Community 3 - "Notes Providers & Screen"
Cohesion: 0.09
Nodes (38): ../application/notes_providers.dart, ConsumerState, ../domain/note.dart, ../domain/note_metadata.dart, ActiveNoteContentNotifier, activeNoteContentProvider, activeNoteMetadataProvider, build (+30 more)

### Community 4 - "Note & Workspace Models"
Cohesion: 0.06
Nodes (33): @immutable, DateTime, int get, ActiveNoteMetadataNotifier, content, copyWith, metadata, hashCode (+25 more)

### Community 5 - "App Router Navigation"
Cohesion: 0.08
Nodes (30): class, ConsumerStatefulWidget, ../../features/notes/presentation/shared_note_screen.dart, ../../features/notes/presentation/workspace_screen.dart, ../../features/sync/infrastructure/github_note_repository.dart, ../../features/workspace/presentation/workspace_selector_screen.dart, GoRouter, WorkspaceScreen (+22 more)

### Community 6 - "Local Note Repo & Git"
Cohesion: 0.06
Nodes (30): dart:io, Exception, build, deleteNote, getAllNotes, LocalNoteRepository, localNoteRepositoryProvider, path (+22 more)

### Community 7 - "Linux Runner Application"
Cohesion: 0.09
Nodes (22): FlPluginRegistry, FlView, GApplication, gboolean, gchar, GObject, GtkApplication, fl_register_plugins() (+14 more)

### Community 8 - "Workspace Repo & Main"
Cohesion: 0.08
Nodes (23): ConsumerWidget, core/router/app_router.dart, dart:convert, ../domain/workspace.dart, features/workspace/infrastructure/workspace_repository.dart, routerProvider, getLastOpenedWorkspaceId, getRecentWorkspaces (+15 more)

### Community 9 - "Shared Note Screen"
Cohesion: 0.12
Nodes (16): ../infrastructure/markdown_parser.dart, build, _content, createState, _error, _fetchGist, _filename, gistId (+8 more)

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

## Knowledge Gaps
- **177 isolated node(s):** `repo`, `fetchAllMarkdownFiles`, `build`, `updateContent`, `path` (+172 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **43 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `FlutterWindow` connect `Windows Runner Win32` to `iOS & macOS Runner`?**
  _High betweenness centrality (0.036) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `MessageHandler` (e.g. with `Destroy` and `GetClientArea`) actually correct?**
  _`MessageHandler` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `repo`, `fetchAllMarkdownFiles`, `build` to the rest of the system?**
  _177 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Windows Runner Win32` be split into smaller, more focused modules?**
  _Cohesion score 0.06594071385359952 - nodes in this community are weakly interconnected._
- **Should `Sync & GitHub Auth` be split into smaller, more focused modules?**
  _Cohesion score 0.05410628019323672 - nodes in this community are weakly interconnected._
- **Should `iOS & macOS Runner` be split into smaller, more focused modules?**
  _Cohesion score 0.05647840531561462 - nodes in this community are weakly interconnected._
- **Should `Notes Providers & Screen` be split into smaller, more focused modules?**
  _Cohesion score 0.08902439024390243 - nodes in this community are weakly interconnected._