import 'package:cocktail_recipes/models/cocktail_model.dart';
import 'package:cocktail_recipes/repository/cocktail_details_repository.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'cocktails_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<String> favoriteIds;
  final ValueChanged<List<String>> onFavoritesChanged;

  const FavoritesScreen({
    super.key,
    required this.favoriteIds,
    required this.onFavoritesChanged,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<CocktailModel> _favoriteCocktails = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteDetails();
    // Вызывает метод для загрузки деталей избранных коктейлей.
  }

  Future<void> _loadFavoriteDetails() async {
    // Асинхронный метод для загрузки деталей избранных коктейлей.
    List<CocktailModel> loaded = [];
    // Создаёт пустой список для хранения загруженных коктейлей.
    for (String id in widget.favoriteIds) {
      // Перебирает все идентификаторы избранных коктейлей.
      final details = await fetchCocktailDetails(id);
      // Загружает детали коктейля по его идентификатору.
      if (details != null) {
        // Проверяет, были ли успешно загружены детали.
        loaded.add(details);
        // Добавляет загруженные детали в список.
      }
    }
    setState(() {
      // Вызывает setState для обновления пользовательского интерфейса.
      _favoriteCocktails = loaded;
      // Обновляет список избранных коктейлей.
      _isLoading = false;
      // Устанавливает флаг загрузки в false, так как загрузка завершена.
    });
  }

  void _removeFromFavorites(String id) {
    setState(() {
      _favoriteCocktails.removeWhere((cocktail) => cocktail.idDrink == id);
      // Удаляет коктейль из списка по его идентификатору.
    });
    widget.onFavoritesChanged(
      // Вызывает функцию обратного вызова для обновления списка избранного.
      _favoriteCocktails.map((c) => c.idDrink!).toList(),
      // Передаёт обновлённый список идентификаторов избранных коктейлей.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Избранные коктейли')),
      body:
      // Определяет тело экрана.
      _isLoading
      // Проверяет, идёт ли загрузка.
          ? Center(
        // Если идёт загрузка, отображает виджет по центру.
        child: Lottie.asset(
          'assets/animation.json',
          width: 500,
          height: 500,
        ),
      ) : _favoriteCocktails.isEmpty
      // Проверяет, пуст ли список избранных коктейлей.
          ? Center(child: Text('Список избранного пуст'))
      // Если список пуст, отображает сообщение по центру.
          : ListView.builder(
        // Иначе создаёт список для отображения коктейлей.
        itemCount: _favoriteCocktails.length,
        // Устанавливает количество элементов в списке.
        itemBuilder: (context, index) {
          // Определяет, как строится каждый элемент списка.
          final cocktail = _favoriteCocktails[index];
          // Получает коктейль по текущему индексу.
          return ListTile(
            // Создаёт элемент списка для коктейля.
            leading:
            // Определяет виджет, отображаемый слева (например, изображение).
            cocktail.strDrinkThumb != null
            // Проверяет, есть ли URL изображения коктейля.
                ? Image.network(cocktail.strDrinkThumb!)
            // Если есть, загружает изображение по URL.
                : null,
            // Если изображения нет, возвращает null.
            title: Text(cocktail.strDrink ?? ''),
            // Устанавливает название коктейля или пустую строку, если названия нет.
            trailing: IconButton(
              // Создаёт кнопку с иконкой справа.
              icon: Icon(Icons.delete, color: Colors.red),
              // Устанавливает иконку удаления красного цвета.
              onPressed: () {
                // Определяет действие при нажатии на кнопку.
                _removeFromFavorites(cocktail.idDrink!);
                // Удаляет коктейль из избранного по его идентификатору.
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Создаёт маршрут для перехода на экран деталей.
                  builder:
                      (_) => CocktailDetailsScreen(cocktail: cocktail),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
