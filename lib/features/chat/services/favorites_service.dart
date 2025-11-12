import 'package:flutter/foundation.dart';
import '../models/favorite_item.dart';

/// Service to manage favorite queries and results
class FavoritesService extends ChangeNotifier {
  final List<FavoriteItem> _favorites = [];

  List<FavoriteItem> get favorites => List.unmodifiable(_favorites);

  /// Add a query/result to favorites
  void addFavorite(String query, {String? surfaceId}) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final favorite = FavoriteItem(
      id: id,
      query: query,
      surfaceId: surfaceId,
    );
    
    _favorites.insert(0, favorite); // Add to beginning
    notifyListeners();
  }

  /// Remove a favorite by ID
  void removeFavorite(String id) {
    _favorites.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  /// Check if a query is favorited
  bool isFavorited(String query) {
    return _favorites.any((f) => f.query == query);
  }

  /// Clear all favorites
  void clear() {
    _favorites.clear();
    notifyListeners();
  }

  /// Get a favorite by query
  FavoriteItem? getFavoriteByQuery(String query) {
    try {
      return _favorites.firstWhere((f) => f.query == query);
    } catch (e) {
      return null;
    }
  }
}
