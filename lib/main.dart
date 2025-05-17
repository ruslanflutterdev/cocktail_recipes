import 'package:flutter/material.dart';
import 'screens/cocktails_search_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Поиск коктейлей',
      theme: ThemeData(
        primarySwatch:  Colors.yellow,
      ),
      home: const CocktailSearchScreen(),
    );
  }
}
