import 'package:flutter/foundation.dart';

@immutable
class NoteMetadata {
  final String title;
  final List<String> tags;
  final DateTime created;
  final DateTime updated;
  final bool favorite;
  final bool published;
  final String? date;

  const NoteMetadata({
    required this.title,
    this.tags = const [],
    required this.created,
    required this.updated,
    this.favorite = false,
    this.published = false,
    this.date,
  });

  NoteMetadata copyWith({
    String? title,
    List<String>? tags,
    DateTime? created,
    DateTime? updated,
    bool? favorite,
    bool? published,
    String? date,
  }) {
    return NoteMetadata(
      title: title ?? this.title,
      tags: tags ?? this.tags,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      favorite: favorite ?? this.favorite,
      published: published ?? this.published,
      date: date ?? this.date,
    );
  }

  factory NoteMetadata.fromMap(Map<String, dynamic> map) {
    DateTime parseDateSafe(dynamic val) {
      if (val == null) return DateTime.now();
      String dateStr = val.toString();
      try {
        dateStr = dateStr.replaceAllMapped(RegExp(r'\s([+-]\d{4})$'), (m) => m.group(1)!);
        return DateTime.parse(dateStr);
      } catch (_) {
        return DateTime.now();
      }
    }

    return NoteMetadata(
      title: map['title'] as String? ?? 'Untitled',
      tags: map['tags'] != null 
          ? (map['tags'] is List 
              ? (map['tags'] as List).map((e) => e.toString()).toList()
              : map['tags'].toString().split(',').map((e) => e.trim()).toList())
          : [],
      created: parseDateSafe(map['created']),
      updated: parseDateSafe(map['updated']),
      favorite: map['favorite']?.toString().toLowerCase() == 'true',
      published: map['published']?.toString().toLowerCase() == 'true',
      date: map['date']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    String formatDate(DateTime dt) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String y = dt.year.toString();
      String m = twoDigits(dt.month);
      String d = twoDigits(dt.day);
      String h = twoDigits(dt.hour);
      String min = twoDigits(dt.minute);
      String sec = twoDigits(dt.second);
      
      String offset = '';
      if (dt.isUtc) {
        offset = '+0000';
      } else {
        Duration tz = dt.timeZoneOffset;
        String sign = tz.isNegative ? '-' : '+';
        int hours = tz.inHours.abs();
        int mins = tz.inMinutes.abs() % 60;
        offset = '$sign${twoDigits(hours)}${twoDigits(mins)}';
      }
      return '$y-$m-$d $h:$min:$sec $offset';
    }

    final res = <String, dynamic>{
      'title': title,
      'tags': tags.join(','),
      'created': formatDate(created),
      'updated': formatDate(updated),
      'favorite': favorite.toString(),
      'published': published.toString(),
    };
    if (date != null && date!.isNotEmpty) {
      res['date'] = date;
    }
    return res;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NoteMetadata &&
        other.title == title &&
        listEquals(other.tags, tags) &&
        other.created == created &&
        other.updated == updated &&
        other.favorite == favorite &&
        other.published == published &&
        other.date == date;
  }

  @override
  int get hashCode {
    return title.hashCode ^ tags.hashCode ^ created.hashCode ^ updated.hashCode ^ favorite.hashCode ^ published.hashCode ^ date.hashCode;
  }
}
