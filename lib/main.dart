import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/screens/category_meals_screen.dart';
import 'package:recipe_app/screens/filters_screen.dart';
import 'package:recipe_app/screens/meal_detail_screen.dart';
import 'package:recipe_app/screens/categories_screen.dart';
import 'package:recipe_app/screens/tabs_screen.dart';

import 'firebase_options.dart';
import 'models/meal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };
  List<Meal> _avaiableMeals = [];
  //List<Meal> _favoriteMeals = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    try {
      final data = await FirebaseFirestore.instance.collection('meals').get();
      data.docs.forEach((doc) {
        _avaiableMeals.add(Meal.fromJson(doc.data()));
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;
      _avaiableMeals = _avaiableMeals.where((meal) {
        if (_filters['gluten'] && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['lactose'] && !meal.isLactoseFree) {
          return false;
        }
        if (_filters['vegan'] && !meal.isVegan) {
          return false;
        }
        if (_filters['vegetarian'] && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  // void _toggleFavorite(String mealId) {
  //   final existingIndex =
  //       _favoriteMeals.indexWhere((meal) => meal.id == mealId);
  //   if (existingIndex >= 0) {
  //     setState(() {
  //       _favoriteMeals.removeAt(existingIndex);
  //     });
  //   } else {
  //     setState(() {
  //       _favoriteMeals.add(
  //         _avaiableMeals.firstWhere((meal) => meal.id == mealId),
  //       );
  //     });
  //   }
  // }

  // bool _isMealFavorite(String id) {
  //   return _favoriteMeals.any((meal) => meal.isFavorited == id);
  // }

  @override
  Widget build(BuildContext context) {
    // final favorites = _avaiableMeals.where((meal) => meal.isFavorited).toList();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: Colors.red,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.red[700],
              //secondary: Color.fromARGB(255, 247, 217, 217),
              secondary: Colors.red[100],
            ),
        canvasColor: Color.fromARGB(255, 253, 253, 253),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline5: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      // home: CategoriesScreen(),
      initialRoute: '/', // default is '/'
      routes: {
        '/': (ctx) => TabsScreen(),
        CategoryMealsScreen.routeName: (ctx) =>
            CategoryMealsScreen(_avaiableMeals),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen(),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters, _setFilters),
      },
      // onGenerateRoute: (settings) {
      //   print(settings.arguments);
      // },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
      },
    );
  }
}
