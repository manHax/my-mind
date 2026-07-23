import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../notes/infrastructure/local_note_repository.dart';

final gitServiceProvider = Provider<GitService?>((ref) {
  final path = ref.watch(workspacePathProvider);
  if (path == null) return null;
  return GitService(workspacePath: path);
});

class GitService {
  final String workspacePath;

  GitService({required this.workspacePath});

  Future<ProcessResult?> _run(List<String> args) async {
    if (kIsWeb) {
      print('Web Mode: Mocking Git Command -> git ${args.join(' ')}');
      return null;
    }
    final result = await Process.run('git', args, workingDirectory: workspacePath);
    return result;
  }

  Future<void> init() async {
    await _run(['init']);
  }

  Future<void> connectToRemote(String remoteUrl) async {
    await _run(['init']);
    await _run(['remote', 'add', 'origin', remoteUrl]);
    await _run(['fetch', 'origin']);
    await _run(['branch', '-M', 'main']);
  }

  Future<bool> hasChanges() async {
    if (kIsWeb) return true;
    final result = await _run(['status', '--porcelain']);
    return result?.stdout.toString().trim().isNotEmpty ?? false;
  }

  Future<void> commit(String message) async {
    await _run(['add', '.']);
    final result = await _run(['commit', '-m', message]);
    if (result != null && result.exitCode != 0 && !result.stdout.toString().contains('nothing to commit')) {
      throw Exception('Git commit failed: ${result.stderr}');
    }
  }

  Future<void> push() async {
    final result = await _run(['push', '-u', 'origin', 'main']);
    if (result != null && result.exitCode != 0) {
      throw Exception('Git push failed: ${result.stderr}');
    }
  }

  Future<void> fetch() async {
    await _run(['fetch', 'origin']);
  }

  Future<bool> hasConflicts() async {
    if (kIsWeb) return false;
    final result = await _run(['ls-files', '-u']);
    return result?.stdout.toString().trim().isNotEmpty ?? false;
  }

  Future<void> pull() async {
    final result = await _run(['pull', 'origin', 'main', '--no-edit']);
    if (result != null && result.exitCode != 0) {
      if (await hasConflicts()) {
        throw GitConflictException('Merge conflicts detected during pull. Manual resolution required.');
      }
      throw Exception('Git pull failed: ${result.stderr}');
    }
  }
}

class GitConflictException implements Exception {
  final String message;
  GitConflictException(this.message);
  
  @override
  String toString() => message;
}
