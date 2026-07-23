import 'package:flutter/foundation.dart';

@immutable
class NoteMetadata {
  final String title;
  final List<String> tags;
  final DateTime created;
  final DateTime updated;
  final bool favorite;

  const NoteMetadata({
    required this.title,
    this.tags = const [],
    required this.created,
    required this.updated,
    this.favorite = false,
  });

  NoteMetadata copyWith({
    String? title,
    List<String>? tags,
    DateTime? created,
    DateTime? updated,
    bool? favorite,
  }) {
    return NoteMetadata(
      title: title ?? this.title,
      tags: tags ?? this.tags,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      favorite: favorite ?? this.favorite,
    );
  }

  factory NoteMetadata.fromMap(Map<String, dynamic> map) {
    return NoteMetadata(
      title: map['title'] as String? ?? 'Untitled',
      tags: (map['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      created: map['created'] != null ? DateTime.parse(map['created'].toString()) : DateTime.now(),
      updated: map['updated'] != null ? DateTime.parse(map['updated'].toString()) : DateTime.now(),
      favorite: map['favorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'tags': tags,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
      'favorite': favorite,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NoteMetadata &&
        other.title == title &&
        listEquals(other.tags, tags) &&
        other.created == created &&
        other.updated == updated &&
        other.favorite == favorite;
  }

  @override
  int get hashCode {
    return title.hashCode ^ tags.hashCode ^ created.hashCode ^ updated.hashCode ^ favorite.hashCode;
  }
}
