import 'package:flutter/material.dart';
import '../models/cocktail_model.dart';

class CocktailDetailsScreen extends StatelessWidget {
  final CocktailModel cocktail;

  const CocktailDetailsScreen({super.key, required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(cocktail.strDrink ?? 'Детали коктейля'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Ингредиенты'),
              Tab(text: 'Инструкция'),
              Tab(text: 'Дополнительно'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildIngredientsTab(),
            _buildInstructionsTab(),
            _buildAdditionalInfoTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return ListView.builder(
      itemCount: cocktail.ingredients.length,
      itemBuilder: (context, index) {
        final ingredientName = cocktail.ingredients.keys.elementAt(index);
        final measure = cocktail.ingredients.values.elementAt(index);
        final imageUrl =
            'https://www.thecocktaildb.com/images/ingredients/$ingredientName-Small.png';
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.no_food, size: 30);
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  ingredientName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (measure != null) Text(measure),
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
    );
  }

  Widget _buildAdditionalInfoTab() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cocktail.strCategory != null)
            Text(
              'Категория: ${cocktail.strCategory}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          if (cocktail.strCategory != null) SizedBox(height: 8),
          if (cocktail.strAlcoholic != null)
            Text(
              'Алкоголь: ${cocktail.strAlcoholic}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          if (cocktail.strAlcoholic != null) SizedBox(height: 8),
          if (cocktail.strGlass != null)
            Text(
              'Бокал: ${cocktail.strGlass}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
