import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cocktail_model.dart';

Future<List<CocktailModel>> searchCocktails(String query) async {
// Асинхронный метод для поиска коктейлей по запросу.
  if (query.isEmpty) {
    // Проверяет, пустой ли запрос.
    return [];
    // Возвращает пустой список, если запрос пуст.
  }
  final url = Uri.parse(
    // Создаёт объект URL для запроса.
    'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$query',
    // Формирует URL с параметром поиска.

  );
  try {
    // Начинает блок обработки ошибок.
    final response = await http.get(url);
    // Выполняет HTTP GET-запрос по указанному URL.
    if (response.statusCode == 200) {
      // Проверяет, успешен ли запрос (код 200).
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Декодирует JSON-ответ в словарь.
      if (data.containsKey('drinks') && data['drinks'] != null) {
        // Проверяет, содержит ли ответ ключ 'drinks' и не является ли он null.
        final List<dynamic> drinksData = data['drinks'];
        // Получает список коктейлей из ответа.
        return drinksData.map((json) => CocktailModel.fromJson(json)).toList();
        // Преобразует каждый элемент JSON в объект CocktailModel и возвращает список.
      } else {
        // Если ключ 'drinks' отсутствует или равен null.
        return [];
        // Возвращает пустой список.
      }
    } else {
      // Если код ответа не 200.
      throw Exception('Ошибка при загрузке коктейлей');
      // Выбрасывает исключение с сообщением об ошибке.
    }
  } catch (e) {
    // Обрабатывает ошибки запроса.
    throw Exception('Произошла ошибка: $e');
    // Выбрасывает исключение с описанием ошибки.
  }
}
