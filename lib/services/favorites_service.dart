import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal_summary.dart';

class FavoritesService {
  static const _key = 'favorites_v1';

  Future<List<MealSummary>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? <String>[];
    return raw.map((e) => MealSummary.fromJson(jsonDecode(e))).toList();
  }

  Future<bool> isFavorite(String id) async {
    final items = await getFavorites();
    return items.any((m) => m.id == id);
  }

  Future<void> add(MealSummary meal) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getFavorites();
    if (items.any((m) => m.id == meal.id)) return;
    items.add(meal);
    await prefs.setStringList(
      _key,
      items.map((m) => jsonEncode(m.toJson())).toList(),
    );
  }

  Future<void> remove(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getFavorites();
    items.removeWhere((m) => m.id == id);
    await prefs.setStringList(
      _key,
      items.map((m) => jsonEncode(m.toJson())).toList(),
    );
  }

  Future<void> toggle(MealSummary meal) async {
    if (await isFavorite(meal.id)) {
      await remove(meal.id);
    } else {
      await add(meal);
    }
  }
}
