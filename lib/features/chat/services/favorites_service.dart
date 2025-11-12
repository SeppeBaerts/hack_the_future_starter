import 'package:flutter/foundation.dart';

class FavoriteQuery {
  const FavoriteQuery({
    required this.query,
    required this.timestamp,
    this.note,
  });

  final String query;
  final DateTime timestamp;
  final String? note;

  Map<String, dynamic> toJson() => {
        'query': query,
        'timestamp': timestamp.toIso8601String(),
        if (note != null) 'note': note,
      };

  factory FavoriteQuery.fromJson(Map<String, dynamic> json) {
    return FavoriteQuery(
      query: json['query'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      note: json['note'] as String?,
    );
  }
}

class FavoritesService extends ChangeNotifier {
  final List<FavoriteQuery> _favorites = [];

  List<FavoriteQuery> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String query) {
    return _favorites.any((fav) => fav.query == query);
  }

  void toggleFavorite(String query, {String? note}) {
    final index = _favorites.indexWhere((fav) => fav.query == query);
    
    if (index >= 0) {
      // Remove from favorites
      _favorites.removeAt(index);
    } else {
      // Add to favorites
      _favorites.insert(
        0,
        FavoriteQuery(
          query: query,
          timestamp: DateTime.now(),
          note: note,
        ),
      );
    }
    
    notifyListeners();
  }

  void removeFavorite(String query) {
    _favorites.removeWhere((fav) => fav.query == query);
    notifyListeners();
  }

  void clear() {
    _favorites.clear();
    notifyListeners();
  }
}
