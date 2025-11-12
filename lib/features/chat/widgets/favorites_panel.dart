import 'package:flutter/material.dart';
import '../services/favorites_service.dart';

class FavoritesPanel extends StatelessWidget {
  const FavoritesPanel({
    required this.favoritesService,
    required this.onQuerySelected,
    super.key,
  });

  final FavoritesService favoritesService;
  final Function(String) onQuerySelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: favoritesService,
      builder: (context, _) {
        final favorites = favoritesService.favorites;

        if (favorites.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No favorite queries yet.\nTap the star icon to save queries.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final favorite = favorites[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: Text(favorite.query),
                subtitle: favorite.note != null
                    ? Text(
                        favorite.note!,
                        style: const TextStyle(fontSize: 12),
                      )
                    : null,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () {
                    favoritesService.removeFavorite(favorite.query);
                  },
                ),
                onTap: () => onQuerySelected(favorite.query),
              ),
            );
          },
        );
      },
    );
  }
}
