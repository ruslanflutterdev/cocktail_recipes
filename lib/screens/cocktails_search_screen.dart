import 'package:cocktail_recipes/screens/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/cocktail_model.dart';
import '../repository/cocktail_details_repository.dart';
import '../repository/cocktail_recipe_repository.dart';
import 'cocktails_details_screen.dart';

class CocktailSearchScreen extends StatefulWidget {
  const CocktailSearchScreen({super.key});

  @override
  State<CocktailSearchScreen> createState() => _CocktailSearchScreenState();
}

class _CocktailSearchScreenState extends State<CocktailSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CocktailModel> _searchResults = [];

  // Список для хранения результатов поиска коктейлей.
  bool _isLoading = false;

  // Флаг, указывающий, идёт ли загрузка данных.
  final List<String> _favoriteCocktails = [];

  // Список для хранения идентификаторов избранных коктейлей.

  Future<void> _fetchCocktails(String query) async {
    // Асинхронный метод для поиска коктейлей по запросу.
    setState(() {
      // Вызывает setState для обновления интерфейса.
      _isLoading = true;
      // Устанавливает флаг загрузки в true.
      _searchResults = [];
      // Очищает список результатов поиска.
    });
    try {
      // Начинает блок обработки ошибок.
      final results = await searchCocktails(query);
      // Выполняет поиск коктейлей по переданному запросу.
      setState(() {
        // Обновляет интерфейс после получения результатов.
        _searchResults = results;
        // Сохраняет результаты поиска в список.
        _isLoading = false;
        // Устанавливает флаг загрузки в false.
      });
      if (mounted) {
        // Проверяет, существует ли виджет в дереве.
        ScaffoldMessenger.of(
          // Использует ScaffoldMessenger для показа уведомлений.
          context,
          // Передаёт текущий контекст.
        ).showSnackBar(SnackBar(content: Text('Коктейли загружены!')));
        // Показывает уведомление об успешной загрузке.
      }
    } catch (e) {
      // Обрабатывает ошибки, возникшие при поиске.
      setState(() {
        // Обновляет интерфейс при ошибке.
        _isLoading = false;
        // Устанавливает флаг загрузки в false.
      });
      if (mounted) {
        // Проверяет, существует ли виджет.
        ScaffoldMessenger.of(
          // Использует ScaffoldMessenger для уведомлений.
          context,
          // Передаёт текущий контекст.
        ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
        // Показывает уведомление с текстом ошибки.
      }
    }
  }

  Future<void> _navigateToCocktailDetails(String cocktailId) async {
    // Асинхронный метод для перехода на экран деталей коктейля.
    setState(() {
      // Обновляет интерфейс.
      _isLoading = true;
      // Устанавливает флаг загрузки в true.
    });
    final cocktailDetails = await fetchCocktailDetails(cocktailId);
    // Загружает детали коктейля по идентификатору.
    setState(() {
      // Обновляет интерфейс после загрузки.

      _isLoading = false;
      // Устанавливает флаг загрузки в false.
    });
    if (cocktailDetails != null && mounted) {
      // Проверяет, были ли загружены детали и существует ли виджет.
      Navigator.push(
        // Переходит на новый экран.
        context,
        // Передаёт текущий контекст.
        MaterialPageRoute(
          // Создаёт маршрут для перехода.
          builder:
              (context) => CocktailDetailsScreen(cocktail: cocktailDetails),
          // Создаёт экран деталей коктейля с переданными данными.
        ),
      );
    } else if (mounted) {
      // Проверяет, существует ли виджет, если детали не загружены.
      ScaffoldMessenger.of(context).showSnackBar(
        // Показывает уведомление об ошибке.
        SnackBar(content: Text('Не удалось загрузить детали коктейля')),
      );
    }
  }

  void _toggleFavorite(String cocktailId) {
    // Метод для добавления или удаления коктейля из избранного.
    setState(() {
      // Обновляет интерфейс.
      if (_favoriteCocktails.contains(cocktailId)) {
        // Проверяет, есть ли коктейль в списке избранного.
        _favoriteCocktails.remove(cocktailId);
        // Удаляет коктейль из списка, если он там есть.
      } else {
        // Если коктейль отсутствует в избранном.
        _favoriteCocktails.add(cocktailId);
        // Добавляет коктейль в список избранного.
      }
    });
  }

  Future<void> _navigateToFavorites() async {
    // Асинхронный метод для перехода на экран избранного.
    await Navigator.push(
      // Переходит на новый экран и ждёт завершения.
      context,
      // Передаёт текущий контекст.
      MaterialPageRoute(
        // Создаёт маршрут для перехода.
        builder:
            (_) => FavoritesScreen(
              // Создаёт экран избранных коктейлей.
              favoriteIds: List.from(_favoriteCocktails),
              // Передаёт копию списка идентификаторов избранных коктейлей.
              onFavoritesChanged: (updatedList) {
                // Определяет функцию обратного вызова для обновления списка.
                setState(() {
                  // Обновляет интерфейс.
                  _favoriteCocktails.clear();
                  // Очищает текущий список избранного.
                  _favoriteCocktails.addAll(updatedList);
                  // Добавляет обновлённый список избранного.
                });
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Поиск коктейлей'),
        actions: [
          // Определяет действия (кнопки) в правой части панели.
          IconButton(
            onPressed: _navigateToFavorites,
            // Устанавливает действие для перехода на экран избранного.
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
      body: Column(
        // Создаёт столбец для размещения виджетов.
        children: [
          // Список дочерних виджетов столбца.
          Padding(
            // Добавляет отступы вокруг дочернего виджета.
            padding: EdgeInsets.all(8.0),
            child: Row(
              // Создаёт строку для размещения текстового поля и кнопки.
              children: [
                // Список дочерних виджетов строки.
                Expanded(
                  // Расширяет дочерний виджет, чтобы он занял всё доступное пространство.
                  child: TextField(
                    controller: _searchController,
                    // Привязывает контроллер к текстовому полю.
                    decoration: InputDecoration(
                      // Задаёт оформление текстового поля.
                      labelText: 'Название коктейля',
                      // Устанавливает метку поля.
                      border: OutlineInputBorder(),
                      // Добавляет рамку вокруг поля.
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Определяет действие при нажатии кнопки.
                    _fetchCocktails(_searchController.text);
                    // Выполняет поиск коктейлей по введённому тексту.
                  },
                  child: Text('Найти'),
                ),
              ],
            ),
          ),
          Expanded(
            // Расширяет дочерний виджет, чтобы он занял всё оставшееся пространство.
            child:
                // Определяет дочерний виджет.
                _isLoading
                    // Проверяет, идёт ли загрузка.
                    ? Center(
                      // Если идёт загрузка, отображает виджет по центру.
                      child: Lottie.asset(
                        'assets/animation.json',
                        width: 500,
                        height: 500,
                      ),
                    )
                    : GridView.builder(
                      // Иначе создаёт сетку для отображения результатов.
                      padding: EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        // Определяет структуру сетки.
                        crossAxisCount: 2,
                        // Устанавливает 2 столбца в сетке.
                        crossAxisSpacing: 8.0,
                        // Устанавливает расстояние между столбцами.
                        mainAxisSpacing: 8.0,
                        // Устанавливает расстояние между строками.
                        childAspectRatio: 0.8,
                        // Устанавливает соотношение сторон элементов сетки.
                      ),
                      itemCount: _searchResults.length,
                      // Устанавливает количество элементов в сетке.
                      itemBuilder: (context, index) {
                        // Определяет, как строится каждый элемент сетки.
                        final cocktail = _searchResults[index];
                        // Полуает коктейль по текущему индексу.
                        final isFavorite = _favoriteCocktails.contains(
                          // Проверяет, находится ли коктейль в избранном.
                          cocktail.idDrink,
                          // Использует идентификатор коктейля.
                        );
                        return Card(
                          // Создаёт карточку для отображения коктейля.
                          child: Stack(
                            // Создаёт стек для наложения виджетов.
                            children: [
                              // Список дочерних виджетов стека.
                              InkWell(
                                // Создаёт область, реагирующую на нажатия.
                                onTap: () {
                                  // Определяет действие при нажатии.

                                  if (cocktail.idDrink != null) {
                                    // Проверяет, есть ли идентификатор коктейля.
                                    _navigateToCocktailDetails(
                                      // Переходит на экран деталей.
                                      cocktail.idDrink!,
                                      // Передаёт идентификатор коктейля.
                                    );
                                  }
                                },
                                child: Column(
                                  // Создаёт столбец для содержимого карточки.
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  // Растягивает содержимое по горизонтали.
                                  children: [
                                    // Список дочерних виджетов столбца.
                                    Expanded(
                                      // Расширяет виджет, чтобы он занял всё пространство.
                                      child:
                                          // Определяет дочерний виджет.
                                          cocktail.strDrinkThumb != null
                                              // Проверяет, есть ли URL изображения.
                                              ? Image.network(
                                                // Если есть, загружает изображение.
                                                cocktail.strDrinkThumb!,
                                                // URL изображения коктейля.
                                                fit: BoxFit.cover,
                                                // Растягивает изображение по ширине.
                                                errorBuilder: (
                                                  // Определяет обработчик ошибок загрузки.
                                                  context,
                                                  error,
                                                  stackTrace,
                                                  // Стек вызовов.
                                                ) {
                                                  return Center(
                                                    // Возвращает виджет по центру.
                                                    child: Text(
                                                      // Отображает текст ошибки.
                                                      'Ошибка загрузки изображения',
                                                    ),
                                                  );
                                                },
                                              )
                                              : Center(
                                                // Если изображения нет, отображает текст.
                                                child: Text('Нет изображения'),
                                              ),
                                    ),
                                    Padding(
                                      // Добавляет отступы вокруг текста.
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        // Отображает название коктейля.
                                        cocktail.strDrink ?? 'Нет названия',
                                        // Использует название или заглушку.
                                        textAlign: TextAlign.center,
                                        // Выравнивает текст по центру.
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        // Ограничивает текст двумя строками.
                                        overflow: TextOverflow.ellipsis,
                                        // Добавляет многоточие при переполнении.
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                // Размещает виджет в определённой позиции в стеке.
                                top: 0,
                                // Устанавливает позицию сверху.
                                right: 0,
                                // Устанавливает позицию справа.
                                child: IconButton(
                                  icon: Icon(
                                    isFavorite
                                        // Проверяет, является ли коктейль избранным.
                                        ? Icons.favorite
                                        // Если избран, показывает полное сердце.
                                        : Icons.favorite_border,
                                    // Если не избран, показывает контур сердца.
                                    color:
                                        isFavorite ? Colors.red : Colors.grey,
                                    // Устанавливает цвет иконки (красный или серый).
                                  ),
                                  onPressed: () {
                                    if (cocktail.idDrink != null) {
                                      // Проверяет, есть ли идентификатор.
                                      _toggleFavorite(cocktail.idDrink!);
                                      // Добавляет или удаляет коктейль из избранного.
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
