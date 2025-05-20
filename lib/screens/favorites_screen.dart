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
  }

  Future<void> _loadFavoriteDetails() async {
    List<CocktailModel> loaded = [];

    for (String id in widget.favoriteIds) {
      final details = await fetchCocktailDetails(id);
      if (details != null) {
        loaded.add(details);
      }
    }

    setState(() {
      _favoriteCocktails = loaded;
      _isLoading = false;
    });
  }

  void _removeFromFavorites(String id) {
    setState(() {
      _favoriteCocktails.removeWhere((cocktail) => cocktail.idDrink == id);
    });
    widget.onFavoritesChanged(
      _favoriteCocktails.map((c) => c.idDrink!).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Избранные коктейли')),
      body:
          _isLoading
              ? Center(
                child: Lottie.asset(
                  'assets/animation.json',
                  width: 500,
                  height: 500,
                ),
              )
              : _favoriteCocktails.isEmpty
              ? Center(child: Text('Список избранного пуст'))
              : ListView.builder(
                itemCount: _favoriteCocktails.length,
                itemBuilder: (context, index) {
                  final cocktail = _favoriteCocktails[index];
                  return ListTile(
                    leading:
                        cocktail.strDrinkThumb != null
                            ? Image.network(cocktail.strDrinkThumb!)
                            : null,
                    title: Text(cocktail.strDrink ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _removeFromFavorites(cocktail.idDrink!);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
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
