import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal_summary.dart';
import '../services/api_service.dart';
import '../services/favorites_provider.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String category;
  const MealsScreen({super.key, required this.category});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  late Future<List<MealSummary>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchMealsByCategory(widget.category);
  }

  Future<List<MealSummary>> _load() async {
    if (_query.isEmpty) return ApiService.fetchMealsByCategory(widget.category);
    final search = await ApiService.searchMeals(_query);
    final byCat = await ApiService.fetchMealsByCategory(widget.category);
    final byCatIds = byCat.map((m) => m.id).toSet();
    return search.where((m) => byCatIds.contains(m.id)).toList();
  }

  int _cols(double w) {
    if (w >= 1400) return 5;
    if (w >= 1200) return 4;
    if (w >= 900) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: LayoutBuilder(
        builder: (context, c) {
          final cols = _cols(c.maxWidth);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search meals in category',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => setState(() => _query = v.trim()),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<MealSummary>>(
                  future: _query.isEmpty ? _future : _load(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final meals = snapshot.data ?? [];
                    if (meals.isEmpty) {
                      return const Center(child: Text('No meals found'));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: meals.length,
                      itemBuilder: (context, i) {
                        final meal = meals[i];
                        return MealCard(
                          meal: meal,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MealDetailScreen(mealId: meal.id),
                              ),
                            );
                          },
                          onToggleFavorite: () =>
                              context.read<FavoritesProvider>().toggle(meal),
                          isFavoriteFuture:
                          context.read<FavoritesProvider>().isFavorite(meal.id),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
