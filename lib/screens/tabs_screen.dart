import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/main_drawer.dart';
import '../models/meal.dart';
import '../screens/favorites_screen.dart';

import './categories_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen();

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  List<Meal> favoriteMeals = [];

  @override
  void initState() {
    getData().whenComplete(() {});
    _pages = [
      {
        'page': CategoriesScreen(),
        'title': 'Categories',
      },
      {
        'page': FavoritesScreen(
          favoriteMeals: favoriteMeals,
        ),
        'title': 'Your Favorite',
      },
    ];
    super.initState();
  }

  Future<void> getData() async {
    try {
      final data = await FirebaseFirestore.instance.collection('meals').get();
      data.docs.forEach((doc) {
        if (Meal.fromJson(doc.data()).isFavorited)
          favoriteMeals.add(Meal.fromJson(doc.data()));
      });
      favoriteMeals = favoriteMeals.where((meal) => meal.isFavorited).toList();
    } catch (e) {
      print(e.toString());
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      drawer: MainDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.orange[400],
        currentIndex: _selectedPageIndex,
        //  type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
