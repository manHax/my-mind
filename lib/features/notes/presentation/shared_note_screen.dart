import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

class SharedNoteScreen extends StatefulWidget {
  final String gistId;

  const SharedNoteScreen({super.key, required this.gistId});

  @override
  State<SharedNoteScreen> createState() => _SharedNoteScreenState();
}

class _SharedNoteScreenState extends State<SharedNoteScreen> {
  bool _isLoading = true;
  String _content = '';
  String _filename = '';
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchGist();
  }

  Future<void> _fetchGist() async {
    try {
      // Fetch anonymously directly from GitHub API
      final url = Uri.parse('https://api.github.com/gists/${widget.gistId}');
      final res = await http.get(url);
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final files = data['files'] as Map<String, dynamic>;
        if (files.isNotEmpty) {
          final firstFile = files.values.first;
          setState(() {
            _filename = firstFile['filename'];
            _content = firstFile['content'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = 'Gist is empty.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Failed to load shared note. It might have been deleted or never existed. (Code: ${res.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Minimalist Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text(
                        _filename.replaceAll('.md', ''),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'My Mind',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.outline.withOpacity(0.2), height: 1),
              
              // Content Area
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error.isNotEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(_error, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                            ),
                          )
                        : Markdown(
                            data: _content,
                            selectable: true,
                            padding: const EdgeInsets.all(32),
                            styleSheet: MarkdownStyleSheet(
                              h1: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, height: 1.4),
                              h2: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.4),
                              p: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.7),
                              code: TextStyle(
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                                fontFamily: 'monospace',
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              codeblockDecoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Theme.of(context).colorScheme.outline),
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
