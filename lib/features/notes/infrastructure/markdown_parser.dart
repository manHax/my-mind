import 'package:yaml/yaml.dart';
import '../domain/note_metadata.dart';
import '../domain/note.dart';

class MarkdownParser {
  static const _separator = '---';

  static String extractTitle(String body, String path) {
    final lines = body.split('\n');
    for (final line in lines) {
      if (line.trim().startsWith('# ')) {
        return line.trim().substring(2).trim();
      }
    }
    return path.split(RegExp(r'[\\/]')).last.replaceAll('.md', '');
  }

  static Note parse(String content, String path) {
    if (content.startsWith(_separator)) {
      final endOfFrontMatter = content.indexOf('\n$_separator', _separator.length);
      if (endOfFrontMatter != -1) {
        final yamlString = content.substring(_separator.length, endOfFrontMatter).trim();
        final body = content.substring(endOfFrontMatter + _separator.length + 1).trimLeft();
        
        try {
          final yamlMap = loadYaml(yamlString);
          if (yamlMap is YamlMap) {
            final map = <String, dynamic>{};
            for (final key in yamlMap.keys) {
              map[key.toString()] = yamlMap[key];
            }
            final metadata = NoteMetadata.fromMap(map);
            return Note(path: path, metadata: metadata, content: body);
          }
        } catch (e) {
          // Fallback if YAML parsing fails
        }
      }
    }
    
    // Fallback if no front matter or parsing fails
    return Note(
      path: path,
      metadata: NoteMetadata(
        title: extractTitle(content, path),
        created: DateTime.now(),
        updated: DateTime.now(),
      ),
      content: content,
    );
  }

  static String stringify(Note note) {
    final m = note.metadata;
    final buffer = StringBuffer();
    buffer.writeln(_separator);
    
    // Format exactly as requested
    // title: "..."
    // tags: ["...", "..."]
    // created: 2026-07-24T08:59:19.478
    // updated: 2026-07-24T09:00:53.102
    // favorite: false
    // published: true
    // date: "..."
    
    buffer.writeln('title: "${m.title.replaceAll('"', r'\"')}"');
    
    final tagsStr = m.tags.map((t) => '"${t.trim()}"').join(', ');
    buffer.writeln('tags: [$tagsStr]');
    
    String formatDateTime(DateTime dt) {
      return dt.toIso8601String().replaceAll(RegExp(r'Z$'), '');
    }
    
    buffer.writeln('created: ${formatDateTime(m.created)}');
    buffer.writeln('updated: ${formatDateTime(m.updated)}');
    buffer.writeln('favorite: ${m.favorite}');
    buffer.writeln('published: ${m.published}');
    
    if (m.date != null && m.date!.isNotEmpty) {
      buffer.writeln('date: "${m.date}"');
    }
    
    buffer.writeln(_separator);
    buffer.write(note.content);
    return buffer.toString();
  }
}
