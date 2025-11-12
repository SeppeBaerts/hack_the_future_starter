class QueryHistoryEntry {
  const QueryHistoryEntry({
    required this.query,
    required this.timestamp,
  });

  final String query;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'query': query,
        'timestamp': timestamp.toIso8601String(),
      };

  factory QueryHistoryEntry.fromJson(Map<String, dynamic> json) {
    return QueryHistoryEntry(
      query: json['query'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class QueryHistoryService {
  static const int _maxHistorySize = 5;
  
  final List<QueryHistoryEntry> _history = [];

  List<QueryHistoryEntry> get history => List.unmodifiable(_history);

  void addQuery(String query) {
    if (query.trim().isEmpty) return;
    
    // Remove duplicates of the same query
    _history.removeWhere((entry) => entry.query == query);
    
    // Add new query at the beginning
    _history.insert(0, QueryHistoryEntry(
      query: query,
      timestamp: DateTime.now(),
    ));
    
    // Keep only the last N queries
    if (_history.length > _maxHistorySize) {
      _history.removeRange(_maxHistorySize, _history.length);
    }
  }

  void clear() {
    _history.clear();
  }

  void removeQuery(int index) {
    if (index >= 0 && index < _history.length) {
      _history.removeAt(index);
    }
  }
}
