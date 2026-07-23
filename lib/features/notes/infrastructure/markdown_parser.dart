import 'package:yaml/yaml.dart';
import '../domain/note_metadata.dart';
import '../domain/note.dart';

class MarkdownParser {
  static const _separator = '---';

  static Note parse(String content, String path) {
    if (content.startsWith(_separator)) {
      final endOfFrontMatter = content.indexOf('\n$_separator', _separator.length);
      if (endOfFrontMatter != -1) {
        final yamlString = content.substring(_separator.length, endOfFrontMatter).trim();
        final body = content.substring(endOfFrontMatter + _separator.length + 1).trimLeft();
        
        try {
          final yamlMap = loadYaml(yamlString);
          if (yamlMap is YamlMap) {
            // Convert YamlMap to a standard Map<String, dynamic> deeply if needed
            // For simple structure, a shallow conversion often suffices or mapping items
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
        title: path.split(RegExp(r'[\\/]')).last.replaceAll('.md', ''),
        created: DateTime.now(),
        updated: DateTime.now(),
      ),
      content: content,
    );
  }

  static String stringify(Note note) {
    final metadataMap = note.metadata.toMap();
    final buffer = StringBuffer();
    buffer.writeln(_separator);
    
    metadataMap.forEach((key, value) {
      if (value is List) {
        if (value.isEmpty) {
          buffer.writeln('$key: []');
        } else {
          buffer.writeln('$key:');
          for (var item in value) {
            buffer.writeln('  - $item');
          }
        }
      } else {
        buffer.writeln('$key: $value');
      }
    });
    
    buffer.writeln(_separator);
    buffer.write(note.content);
    return buffer.toString();
  }
}
