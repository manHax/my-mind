import 'package:flutter/foundation.dart';

@immutable
class Workspace {
  final String id;
  final String name;
  final String path; // Absolute path on the local file system
  final DateTime lastOpened;

  const Workspace({
    required this.id,
    required this.name,
    required this.path,
    required this.lastOpened,
  });

  Workspace copyWith({
    String? id,
    String? name,
    String? path,
    DateTime? lastOpened,
  }) {
    return Workspace(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      lastOpened: lastOpened ?? this.lastOpened,
    );
  }

  factory Workspace.fromMap(Map<String, dynamic> map) {
    return Workspace(
      id: map['id'] as String,
      name: map['name'] as String,
      path: map['path'] as String,
      lastOpened: DateTime.parse(map['lastOpened'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'lastOpened': lastOpened.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Workspace &&
        other.id == id &&
        other.name == name &&
        other.path == path &&
        other.lastOpened == lastOpened;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ path.hashCode ^ lastOpened.hashCode;
  }
}
