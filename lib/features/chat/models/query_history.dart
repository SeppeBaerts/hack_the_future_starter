class QueryHistoryItem {
  const QueryHistoryItem({
    required this.query,
    required this.timestamp,
  });

  final String query;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'query': query,
        'timestamp': timestamp.toIso8601String(),
      };

  factory QueryHistoryItem.fromJson(Map<String, dynamic> json) {
    return QueryHistoryItem(
      query: json['query'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
