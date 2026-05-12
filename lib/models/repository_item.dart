import 'dart:convert';

import 'package:flutter/material.dart';

class RepositoryItem {
  const RepositoryItem({
    this.id,
    required this.title,
    required this.url,
    required this.type,
    required this.tags,
    this.createdAt,
  });

  final int? id;
  final String title;
  final String url;
  final String type;
  final List<String> tags;
  final DateTime? createdAt;

  IconData get icon {
    return type == 'Google Drive'
        ? Icons.folder_open_rounded
        : Icons.storage_rounded;
  }

  Color get iconColor {
    return type == 'Google Drive' ? Colors.greenAccent : Colors.grey;
  }

  RepositoryItem copyWith({
    int? id,
    String? title,
    String? url,
    String? type,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return RepositoryItem(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'type': type,
      'tags': jsonEncode(tags),
      'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
    };
  }

  factory RepositoryItem.fromMap(Map<String, Object?> map) {
    final rawTags = map['tags'] as String? ?? '[]';

    return RepositoryItem(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      url: map['url'] as String? ?? '',
      type: map['type'] as String? ?? 'Google Drive',
      tags: List<String>.from(jsonDecode(rawTags) as List),
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? ''),
    );
  }
}
