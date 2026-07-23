import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/workspace.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main.dart');
});

final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  return WorkspaceRepository(ref.watch(sharedPreferencesProvider));
});

class WorkspaceRepository {
  final SharedPreferences _prefs;
  static const _recentWorkspacesKey = 'recent_workspaces';
  static const _lastOpenedKey = 'last_opened_workspace_id';

  WorkspaceRepository(this._prefs);

  Future<void> saveWorkspace(Workspace workspace) async {
    final map = _getWorkspacesMap();
    map[workspace.id] = workspace.toMap();
    await _prefs.setString(_recentWorkspacesKey, jsonEncode(map));
  }

  List<Workspace> getRecentWorkspaces() {
    final map = _getWorkspacesMap();
    final list = map.values
        .map((e) => Workspace.fromMap(Map<String, dynamic>.from(e)))
        .toList();
    list.sort((a, b) => b.lastOpened.compareTo(a.lastOpened));
    return list;
  }

  Future<void> setLastOpenedWorkspaceId(String id) async {
    await _prefs.setString(_lastOpenedKey, id);
  }

  String? getLastOpenedWorkspaceId() {
    return _prefs.getString(_lastOpenedKey);
  }

  Map<String, dynamic> _getWorkspacesMap() {
    final str = _prefs.getString(_recentWorkspacesKey);
    if (str == null) return {};
    try {
      return Map<String, dynamic>.from(jsonDecode(str));
    } catch (e) {
      return {};
    }
  }
}
