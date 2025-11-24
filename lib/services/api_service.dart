import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal_summary.dart';
import '../models/meal_detail.dart';


class ApiService {
  static const String base = 'https://www.themealdb.com/api/json/v1/1';


  static Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$base/categories.php');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed to load categories');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final list = (data['categories'] as List).cast<Map<String, dynamic>>();
    return list.map(Category.fromJson).toList();
  }


  static Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final url = Uri.parse('$base/filter.php?c=$category');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed to load meals for $category');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final list = (data['meals'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    return list.map(MealSummary.fromJson).toList();
  }


  static Future<List<MealSummary>> searchMeals(String query) async {
    final url = Uri.parse('$base/search.php?s=$query');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Search failed');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final list = (data['meals'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    return list.map(MealSummary.fromJson).toList();
  }


  static Future<MealDetail> fetchMealDetail(String id) async {
    final url = Uri.parse('$base/lookup.php?i=$id');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed to load meal detail');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final list = (data['meals'] as List).cast<Map<String, dynamic>>();
    return MealDetail.fromJson(list.first);
  }


  static Future<MealDetail> fetchRandomMeal() async {
    final url = Uri.parse('$base/random.php');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed to load random meal');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final list = (data['meals'] as List).cast<Map<String, dynamic>>();
    return MealDetail.fromJson(list.first);
  }
}