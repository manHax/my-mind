import 'package:flutter/foundation.dart';
import 'note_metadata.dart';

@immutable
class Note {
  /// The relative path of the note within the workspace (e.g., 'Daily/2026-07-23.md').
  /// This serves as the unique identifier for the note in the local-first system.
  final String path;
  final NoteMetadata metadata;
  final String content;

  const Note({
    required this.path,
    required this.metadata,
    required this.content,
  });

  Note copyWith({
    String? path,
    NoteMetadata? metadata,
    String? content,
  }) {
    return Note(
      path: path ?? this.path,
      metadata: metadata ?? this.metadata,
      content: content ?? this.content,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Note &&
        other.path == path &&
        other.metadata == metadata &&
        other.content == content;
  }

  @override
  int get hashCode => path.hashCode ^ metadata.hashCode ^ content.hashCode;
}
