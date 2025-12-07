import 'package:flutter/foundation.dart';
import '../models/meal_summary.dart';
import 'favorites_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesService _svc;
  FavoritesProvider(this._svc);

  List<MealSummary> _items = [];
  List<MealSummary> get items => List.unmodifiable(_items);

  Future<void> load() async {
    _items = await _svc.getFavorites();
    notifyListeners();
  }

  Future<void> toggle(MealSummary meal) async {
    await _svc.toggle(meal);
    await load();
  }

  Future<bool> isFavorite(String id) => _svc.isFavorite(id);
}
