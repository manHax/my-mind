import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../notes/domain/note.dart';
import '../../notes/domain/note_metadata.dart';
import '../../notes/infrastructure/markdown_parser.dart';
import 'github_auth_service.dart';
import '../../workspace/infrastructure/workspace_repository.dart';

// The workspace is now represented by a GitHub Repository Name (e.g. "Manhakkim/my-mind-notes")
class WorkspaceRepoNotifier extends Notifier<String?> {
  @override
  String? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString('github_repo');
  }

  void set(String? repo) {
    if (repo != null) {
      ref.read(sharedPreferencesProvider).setString('github_repo', repo);
    }
    state = repo;
  }
}
final workspaceRepoProvider = NotifierProvider<WorkspaceRepoNotifier, String?>(WorkspaceRepoNotifier.new);

final githubNoteRepositoryProvider = Provider<GithubNoteRepository?>((ref) {
  final token = ref.watch(githubAuthNotifierProvider).accessToken;
  final repo = ref.watch(workspaceRepoProvider);
  if (token == null || repo == null) return null;
  return GithubNoteRepository(token: token, repoFullName: repo);
});

class GithubNoteRepository {
  final String token;
  final String repoFullName; 

  GithubNoteRepository({required this.token, required this.repoFullName});

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/vnd.github+json',
    'X-GitHub-Api-Version': '2022-11-28',
  };

  /// Directly saves/pushes the markdown note to the GitHub repository via API
  Future<void> saveNote(Note note) async {
    final contentUrl = Uri.parse('https://api.github.com/repos/$repoFullName/contents/${note.path}');
    
    // 1. We must get the current file SHA to update it (GitHub API requirement)
    final getRes = await http.get(contentUrl, headers: _headers);
    String? sha;
    if (getRes.statusCode == 200) {
      sha = jsonDecode(getRes.body)['sha'];
    }

    // 2. Encode to Base64 and push
    final contentStr = MarkdownParser.stringify(note);
    final body = {
      'message': 'MyMind Auto-Save: Update ${note.path}',
      'content': base64Encode(utf8.encode(contentStr)),
    };
    if (sha != null) body['sha'] = sha;

    final putRes = await http.put(
      contentUrl,
      headers: _headers,
      body: jsonEncode(body),
    );
    
    if (putRes.statusCode >= 400) {
      throw Exception('Failed to push to GitHub: ${putRes.body}');
    }
  }

  /// Fetches all .md files in the repository using the Git Trees API
  Future<List<String>> fetchAllMarkdownFiles() async {
    // Try main branch first
    Uri url = Uri.parse('https://api.github.com/repos/$repoFullName/git/trees/main?recursive=1');
    var res = await http.get(url, headers: _headers);
    
    // Fallback to master if main doesn't exist
    if (res.statusCode == 404) {
      url = Uri.parse('https://api.github.com/repos/$repoFullName/git/trees/master?recursive=1');
      res = await http.get(url, headers: _headers);
    }
    
    if (res.statusCode != 200) return []; // Empty or error

    final json = jsonDecode(res.body);
    final tree = json['tree'] as List<dynamic>? ?? [];
    
    return tree
        .where((item) => item['type'] == 'blob' && item['path'].toString().endsWith('.md'))
        .map((item) => item['path'] as String)
        .toList();
  }

  /// Fetches the string content of a specific note
  Future<String> fetchNoteContent(String path) async {
    final url = Uri.parse('https://api.github.com/repos/$repoFullName/contents/$path');
    final res = await http.get(url, headers: _headers);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final contentBase64 = json['content'].toString().replaceAll('\n', '');
      return utf8.decode(base64Decode(contentBase64));
    }
    return '';
  }

  /// GitHub API does not have a "Rename" endpoint. 
  /// We must CREATE the new file and DELETE the old file.
  Future<void> renameNote(String oldPath, String newPath, String content) async {
    // 1. Create new file with current content
    await saveNote(Note(
      path: newPath,
      metadata: NoteMetadata(title: newPath, created: DateTime.now(), updated: DateTime.now()),
      content: content,
    ));

    // 2. Delete old file (requires SHA)
    final oldUrl = Uri.parse('https://api.github.com/repos/$repoFullName/contents/$oldPath');
    final oldRes = await http.get(oldUrl, headers: _headers);
    if (oldRes.statusCode == 200) {
      final sha = jsonDecode(oldRes.body)['sha'];
      await http.delete(
        oldUrl,
        headers: _headers,
        body: jsonEncode({
          'message': 'MyMind Auto-Sync: Rename $oldPath to $newPath',
          'sha': sha,
        }),
      );
    }
  }

  /// Creates a public GitHub Gist to share a specific note
  Future<String> createPublicGist(String filename, String content) async {
    final gistContent = content.trim().isEmpty ? "(Catatan kosong)" : content;
    final url = Uri.parse('https://api.github.com/gists');
    final res = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        'description': 'Shared via My Mind (Cloud Native PKM)',
        'public': false,
        'files': {
          filename.split('/').last: {
            'content': gistContent
          }
        }
      }),
    );

    if (res.statusCode == 201) {
      final json = jsonDecode(res.body);
      return json['id']; // We now return ID so we can embed it in our own web URL
    } else {
      throw Exception('Failed to create Gist: ${res.body}');
    }
  }
}

