import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cocktail_model.dart';

Future<List<CocktailModel>> searchCocktails(String query) async {
  if (query.isEmpty) {
    return [];
  }
  final url = Uri.parse(
    'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$query',
  );
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('drinks') && data['drinks'] != null) {
        final List<dynamic> drinksData = data['drinks'];
        return drinksData.map((json) => CocktailModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Ошибка при загрузке коктейлей');
    }
  } catch (e) {
    throw Exception('Произошла ошибка: $e');
  }
}
