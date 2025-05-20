class CocktailModel {
  final String? idDrink;
  final String? strDrink;
  final String? strDrinkThumb;
  final String? strCategory;
  final String? strAlcoholic;
  final String? strGlass;
  final String? strInstructions;
  final Map<String, String?> ingredients;

  CocktailModel({
    this.idDrink,
    this.strDrink,
    this.strDrinkThumb,
    this.strCategory,
    this.strAlcoholic,
    this.strGlass,
    this.strInstructions,
    this.ingredients = const {},
  });

  factory CocktailModel.fromJson(Map<String, dynamic> json) {
    final ingredients = <String, String?>{};
    for (var i = 1; i <= 15; i++) {
      final ingredient = json['strIngredient$i'] as String?;
      final measure = json['strMeasure$i'] as String?;
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients[ingredient] = measure;
      }
    }
    return CocktailModel(
      idDrink: json['idDrink'],
      strDrink: json['strDrink'],
      strDrinkThumb: json['strDrinkThumb'],
      strCategory: json['strCategory'],
      strAlcoholic: json['strAlcoholic'],
      strGlass: json['strGlass'],
      strInstructions: json['strInstructions'],
      ingredients: ingredients,
    );
  }
}
