import 'package:genui/genui.dart';

/// Represents a favorited query or result
class FavoriteItem {
  FavoriteItem({
    required this.id,
    required this.query,
    this.surfaceId,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final String id;
  final String query;
  final String? surfaceId;
  final DateTime timestamp;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'surfaceId': surfaceId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] as String,
      query: json['query'] as String,
      surfaceId: json['surfaceId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
