import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cocktail_model.dart';

Future<CocktailModel?> fetchCocktailDetails(String id) async {
// Асинхронный метод для получения деталей коктейля по идентификатору.
  final url = Uri.parse(
    // Создаёт объект URL для запроса.
    'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$id',
    // Формирует URL с параметром идентификатора коктейля.
  );
  try {
    // Начинает блок обработки ошибок.
    final response = await http.get(url);
    // Выполняет HTTP GET-запрос по указанному URL.
    if (response.statusCode == 200) {
      // Проверяет, успешен ли запрос (код 200).
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Декодирует JSON-ответ в словарь.
      if (data.containsKey('drinks') &&
          data['drinks'] != null &&
          data['drinks'].isNotEmpty) {
        // Проверяет, содержит ли ответ ключ 'drinks', не null ли он и не пустой ли список.
        return CocktailModel.fromJson(data['drinks'].first);
        // Преобразует первый элемент JSON в объект CocktailModel и возвращает его.
      } else {
        // Если данные отсутствуют.
        return null;
        // Возвращает null.
      }
      // Закрывает условие.
    } else {
      // Если код ответа не 200.
      throw Exception('Ошибка при загрузке деталей коктейля');
      // Выбрасывает исключение с сообщением об ошибке.
    }
  } catch (e) {
    // Обрабатывает ошибки запроса.
    throw Exception('Произошла ошибка при загрузке деталей коктейля: $e');
    // Выбрасывает исключение с описанием ошибки.
  }
}
