import 'package:flutter/material.dart';
import '../models/cocktail_model.dart';

class CocktailDetailsScreen extends StatelessWidget {
  final CocktailModel cocktail;

  const CocktailDetailsScreen({super.key, required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // Создаёт контроллер вкладок для управления вкладками.
      length: 3,
      // Устанавливает количество вкладок (3).
      child: Scaffold(
        // Создаёт базовую структуру экрана.
        appBar: AppBar(
          // Создаёт верхнюю панель приложения.
          title: Text(cocktail.strDrink ?? 'Детали коктейля'),
          // Устанавливает заголовок панели или заглушку, если названия нет.
          bottom: TabBar(
            // Создаёт панель вкладок в нижней части AppBar.
            tabs: [
              // Список вкладок.
              Tab(text: 'Ингредиенты'),
              // Вкладка для отображения ингредиентов.
              Tab(text: 'Инструкция'),
              // Вкладка для отображения инструкций.
              Tab(text: 'Дополнительно'),
              // Вкладка для дополнительной информации.
            ],
          ),
        ),
        body: TabBarView(
          // Создаёт область для отображения содержимого вкладок.
          children: [
            // Список содержимого для каждой вкладки.
            _buildIngredientsTab(),
            // Вызывает метод для построения вкладки ингредиентов.
            _buildInstructionsTab(),
            // Вызывает метод для построения вкладки инструкций.
            _buildAdditionalInfoTab(),
            // Вызывает метод для построения вкладки дополнительной информации.
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsTab() {
    // Метод для построения вкладки ингредиентов.
    return ListView.builder(
      // Создаёт прокручиваемый список ингредиентов.
      itemCount: cocktail.ingredients.length,
      // Устанавливает количество элементов (ингредиентов).
      itemBuilder: (context, index) {
        // Определяет, как строится каждый элемент списка.
        final ingredientName = cocktail.ingredients.keys.elementAt(index);
        // Получает название ингредиента по индексу.
        final measure = cocktail.ingredients.values.elementAt(index);
        // Получает меру ингредиента (если есть).
        final imageUrl =
            'https://www.thecocktaildb.com/images/ingredients/$ingredientName-Small.png';
        // Формирует URL изображения ингредиента.
        return Padding(
          // Добавляет отступы вокруг элемента.
          padding: EdgeInsets.all(8.0),
          // Устанавливает отступы 8 пикселей.
          child: Row(
            // Создаёт строку для отображения ингредиента.
            children: [
              // Список дочерних виджетов строки.
              SizedBox(
                // Фиксирует размер области для изображения.
                width: 50,
                height: 50,
                child: Image.network(
                  // Загружает изображение ингредиента по URL.
                  imageUrl,
                  // URL изображения.
                  fit: BoxFit.contain,
                  // Устанавливает режим отображения изображения.
                  errorBuilder: (context, error, stackTrace) {
                    // Определяет обработчик ошибок загрузки изображения.
                    return Icon(Icons.no_food, size: 30);
                    // Возвращает иконку при ошибке загрузки.
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                // Расширяет виджет, чтобы он занял доступное пространство.
                child: Text(
                  // Отображает название ингредиента.
                  ingredientName,
                  // Название ингредиента.
                  style: TextStyle(fontWeight: FontWeight.bold),
                  // Устанавливает жирный шрифт.
                ),
              ),
              if (measure != null) Text(measure),
              // Если мера есть, отображает её.
            ],
          ),
        );
      },
    );
  }

  Widget _buildInstructionsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Text(cocktail.strInstructions ?? 'Инструкция отсутствует.'),
      // Отображает инструкцию или заглушку, если инструкции нет.
    );
  }

  Widget _buildAdditionalInfoTab() {
    // Метод для построения вкладки дополнительной информации.
    return Padding(
      // Добавляет отступы вокруг содержимого.
      padding: EdgeInsets.all(16.0),
      // Устанавливает отступы 16 пикселей.
      child: Column(
        // Создаёт столбец для размещения информации.
        crossAxisAlignment: CrossAxisAlignment.start,
        // Выравнивает содержимое по левому краю.
        children: [
          // Список дочерних виджетов столбца.
          if (cocktail.strCategory != null)
          // Проверяет, есть ли категория коктейля.
            Text(
              // Отображает категорию.
              'Категория: ${cocktail.strCategory}',
              // Текст с категорией коктейля.
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          if (cocktail.strCategory != null) SizedBox(height: 8),
          // Если категория есть, добавляет промежуток 8 пикселей.
          if (cocktail.strAlcoholic != null)
          // Проверяет, есть ли информация об алкоголе.
            Text(
              // Отображает информацию об алкоголе.
              'Алкоголь: ${cocktail.strAlcoholic}',
              // Текст с типом алкоголя.
              style: TextStyle(fontWeight: FontWeight.bold),
              // Устанавливает жирный шрифт.
            ),
          if (cocktail.strAlcoholic != null) SizedBox(height: 8),
          // Если информация об алкоголе есть, добавляет промежуток.
          if (cocktail.strGlass != null)
          // Проверяет, есть ли информация о бокале.
            Text(
              // Отображает информацию о бокале.
              'Бокал: ${cocktail.strGlass}',
              // Текст с типом бокала.
              style: TextStyle(fontWeight: FontWeight.bold),
              // Устанавливает жирный шрифт.
            ),
        ],
      ),
    );
  }
}
