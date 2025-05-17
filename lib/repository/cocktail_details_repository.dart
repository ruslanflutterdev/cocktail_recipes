import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cocktail_model.dart';

Future<CocktailModel?> fetchCocktailDetails(String id) async {
  final url = Uri.parse(
    'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$id',
  );
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('drinks') &&
          data['drinks'] != null &&
          data['drinks'].isNotEmpty) {
        return CocktailModel.fromJson(data['drinks'].first);
      } else {
        return null;
      }
    } else {
      throw Exception('Ошибка при загрузке деталей коктейля');
    }
  } catch (e) {
    throw Exception('Произошла ошибка при загрузке деталей коктейля: $e');
  }
}
