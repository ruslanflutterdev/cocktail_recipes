import 'package:flutter/material.dart';
import '../models/cocktail_model.dart';
import '../repository/cocktail_recipe_repository.dart';

class CocktailSearchScreen extends StatefulWidget {
  const CocktailSearchScreen({super.key});

  @override
  State<CocktailSearchScreen> createState() => _CocktailSearchScreenState();
}

class _CocktailSearchScreenState extends State<CocktailSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CocktailModel> _searchResults = [];
  bool _isLoading = false;

  Future<void> _fetchCocktails(String query) async {
    setState(() {
      _isLoading = true;
      _searchResults = [];
    });
    try {
      final results = await searchCocktails(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Коктейли загружены!')));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Поиск коктейлей')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Название коктейля',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _fetchCocktails(_searchController.text);
                  },
                  child: Text('Найти'),
                ),
              ],
            ),
          ),
          Expanded(
            child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.8,
              ),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final cocktail = _searchResults[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child:
                        cocktail.strDrinkThumb != null
                            ? Image.network(
                          cocktail.strDrinkThumb!,
                          fit: BoxFit.cover,
                          errorBuilder: (
                              context,
                              error,
                              stackTrace,
                              ) {
                            return Center(
                              child: Text(
                                'Ошибка загрузки изображения',
                              ),
                            );
                          },
                        )
                            : Center(
                          child: Text('Нет изображения'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          cocktail.strDrink ?? 'Нет названия',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
