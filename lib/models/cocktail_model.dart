class CocktailModel {
  final String? idDrink;
  final String? strDrink;
  final String? strDrinkThumb;

  CocktailModel({this.idDrink, this.strDrink, this.strDrinkThumb});

  factory CocktailModel.fromJson(Map<String, dynamic> json) {
    return CocktailModel(
      idDrink: json['idDrink'],
      strDrink: json['strDrink'],
      strDrinkThumb: json['strDrinkThumb'],
    );
  }
}
