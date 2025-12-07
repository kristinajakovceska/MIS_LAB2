import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/favorites_provider.dart';
import '../widgets/meal_card.dart';
import '../models/meal_summary.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoritesProvider>().items;

    int cols(double w) {
      if (w >= 1400) return 5;
      if (w >= 1200) return 4;
      if (w >= 900) return 3;
      return 2;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Омилени рецепти')),
      body: favs.isEmpty
          ? const Center(child: Text('Немаш додадено омилени.'))
          : LayoutBuilder(
        builder: (context, c) => GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols(c.maxWidth),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemCount: favs.length,
          itemBuilder: (_, i) {
            final MealSummary m = favs[i];
            return MealCard(
              meal: m,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(mealId: m.id),
                ),
              ),
              onToggleFavorite: () =>
                  context.read<FavoritesProvider>().toggle(m),
              isFavoriteFuture:
              context.read<FavoritesProvider>().isFavorite(m.id),
            );
          },
        ),
      ),
    );
  }
}
