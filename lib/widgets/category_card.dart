import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  category.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Text(
                category.name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: cs.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                category.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: cs.onSurfaceVariant, height: 1.25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
