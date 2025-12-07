import 'package:flutter/material.dart';
import '../models/meal_summary.dart';

class MealCard extends StatelessWidget {
  final MealSummary meal;
  final VoidCallback onTap;
  final VoidCallback? onToggleFavorite;
  final Future<bool>? isFavoriteFuture;

  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
    this.onToggleFavorite,
    this.isFavoriteFuture,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Hero(
                    tag: 'meal:${meal.id}',
                    child: Image.network(meal.thumbnail, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Text(
                    meal.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            if (onToggleFavorite != null)
              Positioned(
                top: 8,
                right: 8,
                child: FutureBuilder<bool>(
                  future: isFavoriteFuture,
                  builder: (context, snap) {
                    final isFav = snap.data ?? false;
                    return IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white70,
                      ),
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                      color: isFav ? Colors.red : Colors.black87,
                      onPressed: onToggleFavorite,
                      tooltip: isFav ? 'Отстрани од омилени' : 'Додај во омилени',
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
