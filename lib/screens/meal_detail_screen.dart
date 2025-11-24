import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/meal_detail.dart';
import '../services/api_service.dart';
import '../widgets/ingredient_chip.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final MealDetail? preload;
  const MealDetailScreen({super.key, required this.mealId, this.preload});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late Future<MealDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.preload != null
        ? Future.value(widget.preload)
        : ApiService.fetchMealDetail(widget.mealId);
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('YouTube link copied')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe')),
      body: FutureBuilder<MealDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final meal = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'meal:${meal.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(meal.thumbnail, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(meal.name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),

                    if (meal.youtubeUrl != null) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SelectableText(
                              meal.youtubeUrl!,
                              style: TextStyle(
                                color: cs.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Copy link',
                            onPressed: () => _copyToClipboard(meal.youtubeUrl!),
                            icon: const Icon(Icons.copy),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    Text('Ingredients', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: meal.ingredients
                          .map((i) => IngredientChip(
                        text: i.measure.isEmpty ? i.name : '${i.measure} • ${i.name}',
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Text('Instructions', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(meal.instructions, style: const TextStyle(height: 1.35)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
