class MealDetail {
  final String id;
  final String name;
  final String thumbnail;
  final String instructions;
  final String? youtubeUrl;
  final List<Ingredient> ingredients;


  MealDetail({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.instructions,
    required this.youtubeUrl,
    required this.ingredients,
  });


  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final id = json['idMeal'] as String;
    final name = json['strMeal'] as String;
    final thumb = json['strMealThumb'] as String;
    final instructions = (json['strInstructions'] as String?)?.trim() ?? '';
    final youtube = (json['strYoutube'] as String?)?.trim();


    final ing = <Ingredient>[];
    for (int i = 1; i <= 20; i++) {
      final ingName = (json['strIngredient$i'] as String?)?.trim();
      final measure = (json['strMeasure$i'] as String?)?.trim();
      final hasName = ingName != null && ingName.isNotEmpty;
      final hasMeasure = measure != null && measure.isNotEmpty;
      if (hasName) {
        ing.add(Ingredient(name: ingName!, measure: hasMeasure ? measure! : ''));
      }
    }


    return MealDetail(
      id: id,
      name: name,
      thumbnail: thumb,
      instructions: instructions,
      youtubeUrl: (youtube != null && youtube.isNotEmpty) ? youtube : null,
      ingredients: ing,
    );
  }
}


class Ingredient {
  final String name;
  final String measure;
  Ingredient({required this.name, required this.measure});
}