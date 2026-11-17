import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import '../domain/note_metadata.dart';
import '../domain/share_theme.dart';
import '../infrastructure/markdown_parser.dart';

class SharedNoteScreen extends StatefulWidget {
  final String gistId;
  final String? initialThemeId;

  const SharedNoteScreen({
    super.key,
    required this.gistId,
    this.initialThemeId,
  });

  @override
  State<SharedNoteScreen> createState() => _SharedNoteScreenState();
}

class _SharedNoteScreenState extends State<SharedNoteScreen> {
  bool _isLoading = true;
  String _content = '';
  String _filename = '';
  String _error = '';
  NoteMetadata? _metadata;
  ShareTheme? _selectedTheme;

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
          final filename = (firstFile['filename'] as String?) ?? 'Note.md';
          final rawContent = (firstFile['content'] as String?) ?? '';
          final parsed = MarkdownParser.parse(rawContent, filename);

          setState(() {
            _filename = filename;
            _metadata = parsed.metadata;
            _content = parsed.content;
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

  ShareTheme _resolveTheme(BuildContext context) {
    if (_selectedTheme != null) return _selectedTheme!;
    final fromUrl = ShareTheme.fromId(widget.initialThemeId);
    if (fromUrl != null) return fromUrl;
    final fromFrontmatter = ShareTheme.fromId(_metadata?.shareTheme);
    if (fromFrontmatter != null) return fromFrontmatter;

    final systemBrightness = MediaQuery.platformBrightnessOf(context);
    return systemBrightness == Brightness.dark ? ShareTheme.dark : ShareTheme.light;
  }

  String _estimateReadingTime(String text) {
    final words = text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final minutes = (words / 200).ceil().clamp(1, 999);
    return '$minutes min read';
  }

  @override
  Widget build(BuildContext context) {
    final activeShareTheme = _resolveTheme(context);
    final themeData = activeShareTheme.toThemeData();
    final colorScheme = themeData.colorScheme;
    final textTheme = themeData.textTheme;

    return Theme(
      data: themeData,
      child: Scaffold(
        backgroundColor: themeData.scaffoldBackgroundColor,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 640;
            final horizontalOuter = isCompact ? 12.0 : 24.0;
            final cardPadding = isCompact ? 20.0 : 40.0;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(horizontalOuter, 20, horizontalOuter, 48),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Bar: Brand + Theme Switcher
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.auto_stories_outlined, size: 18, color: colorScheme.primary),
                                const SizedBox(width: 8),
                                Text(
                                  'My Mind',
                                  style: textTheme.titleSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ],
                            ),
                            PopupMenuButton<ShareTheme>(
                              tooltip: 'Change Reading Theme',
                              onSelected: (theme) => setState(() => _selectedTheme = theme),
                              itemBuilder: (context) => ShareTheme.values.map((theme) {
                                final isCurrent = theme == activeShareTheme;
                                return PopupMenuItem<ShareTheme>(
                                  value: theme,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: theme.background,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: theme.primary, width: 2),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(theme.label)),
                                      if (isCurrent) Icon(Icons.check, size: 16, color: theme.primary),
                                    ],
                                  ),
                                );
                              }).toList(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: colorScheme.outline),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(activeShareTheme.icon, size: 15, color: colorScheme.primary),
                                    const SizedBox(width: 6),
                                    Text(
                                      activeShareTheme.label,
                                      style: textTheme.labelMedium?.copyWith(
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Icon(Icons.arrow_drop_down, size: 16, color: colorScheme.onSurfaceVariant),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Main Article Card
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colorScheme.outline),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                activeShareTheme.brightness == Brightness.dark ? 0.25 : 0.04,
                              ),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(cardPadding),
                        child: _isLoading
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 80),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : _error.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 48),
                                    child: Column(
                                      children: [
                                        Icon(Icons.error_outline, size: 40, color: colorScheme.error),
                                        const SizedBox(height: 12),
                                        Text(
                                          _error,
                                          style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      _buildArticleHeader(context, colorScheme, textTheme, isCompact),
                                      const SizedBox(height: 24),
                                      Divider(color: colorScheme.outline, height: 1),
                                      const SizedBox(height: 28),
                                      MarkdownBody(
                                        data: _content,
                                        selectable: true,
                                        styleSheet: _buildMarkdownStyle(colorScheme, textTheme),
                                      ),
                                      const SizedBox(height: 40),
                                      Divider(color: colorScheme.outline, height: 1),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.auto_stories_outlined, size: 14, color: colorScheme.onSurfaceVariant),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Published with My Mind',
                                            style: textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildArticleHeader(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isCompact,
  ) {
    final title = _metadata?.title.isNotEmpty == true && _metadata?.title != 'Untitled'
        ? _metadata!.title
        : MarkdownParser.extractTitle(_content, _filename);
    final dateStr = _metadata?.date?.isNotEmpty == true ? _metadata!.date! : null;
    final tags = _metadata?.tags ?? const [];
    final readingTime = _estimateReadingTime(_content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: (isCompact ? textTheme.headlineMedium : textTheme.displaySmall)?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (dateStr != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    dateStr,
                    style: textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.schedule_outlined, size: 14, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  readingTime,
                  style: textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '#$tag',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  MarkdownStyleSheet _buildMarkdownStyle(ColorScheme colorScheme, TextTheme textTheme) {
    return MarkdownStyleSheet(
      h1: textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
        height: 1.4,
      ),
      h1Padding: const EdgeInsets.only(top: 24, bottom: 8),
      h2: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
        height: 1.4,
      ),
      h2Padding: const EdgeInsets.only(top: 20, bottom: 6),
      h3: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
        height: 1.4,
      ),
      h3Padding: const EdgeInsets.only(top: 16, bottom: 4),
      p: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
        height: 1.75,
      ),
      pPadding: const EdgeInsets.only(bottom: 12),
      a: TextStyle(
        color: colorScheme.primary,
        decoration: TextDecoration.underline,
        decorationColor: colorScheme.primary.withOpacity(0.5),
      ),
      listBullet: textTheme.bodyLarge?.copyWith(color: colorScheme.primary),
      blockquote: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontStyle: FontStyle.italic,
        height: 1.65,
      ),
      blockquotePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      blockquoteDecoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: Border(
          left: BorderSide(color: colorScheme.primary, width: 4),
        ),
      ),
      code: TextStyle(
        backgroundColor: colorScheme.surfaceContainerHighest,
        fontFamily: 'monospace',
        fontSize: 14,
        color: colorScheme.primary,
      ),
      codeblockPadding: const EdgeInsets.all(16),
      codeblockDecoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outline),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outline, width: 1),
        ),
      ),
      tableHead: textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      tableBody: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      tableBorder: TableBorder.all(color: colorScheme.outline, width: 1),
      tableCellsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
