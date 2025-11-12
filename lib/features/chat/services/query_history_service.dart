import 'package:flutter/foundation.dart';
import '../models/query_history.dart';

class QueryHistoryService extends ChangeNotifier {
  final List<QueryHistoryItem> _history = [];
  static const int maxHistorySize = 5;

  List<QueryHistoryItem> get history => List.unmodifiable(_history);

  void addQuery(String query) {
    if (query.trim().isEmpty) return;

    // Remove duplicate if exists
    _history.removeWhere((item) => item.query == query);

    // Add to the beginning
    _history.insert(
      0,
      QueryHistoryItem(
        query: query,
        timestamp: DateTime.now(),
      ),
    );

    // Keep only the last 5 queries
    if (_history.length > maxHistorySize) {
      _history.removeRange(maxHistorySize, _history.length);
    }

    notifyListeners();
  }

  void clear() {
    _history.clear();
    notifyListeners();
  }

  void removeQuery(String query) {
    _history.removeWhere((item) => item.query == query);
    notifyListeners();
  }
}
