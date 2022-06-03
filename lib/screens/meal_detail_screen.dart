import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealDetailScreen extends StatefulWidget {
  static const routeName = '/meal-detail';
  MealDetailScreen({this.meal});

  final Meal meal;

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  bool isFavorited;
  @override
  void initState() {
    isFavorited = widget.meal.isFavorited;
    super.initState();
  }

  Future<void> setFavorite() async {
    final newValue = !isFavorited;
    isFavorited = newValue;
    setState(() {});
    try {
      await FirebaseFirestore.instance
          .collection('meals')
          .doc(widget.meal.id)
          .update({'isFavorited': newValue});
    } catch (e) {
      print(e.toString());
    }
  }

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(text, style: Theme.of(context).textTheme.headline5),
    );
  }

  Widget BuildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      height: 150,
      width: 300,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final mealId = ModalRoute.of(context).settings.arguments as String;
    final selectedMeal = widget.meal;
    return Scaffold(
        appBar: AppBar(
          title: Text('${selectedMeal.title}'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                width: double.infinity,
                child: Image.asset(
                  selectedMeal.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              buildSectionTitle(context, 'Ingredients'),
              BuildContainer(
                ListView.builder(
                  itemBuilder: (ctx, index) => Card(
                      color: Theme.of(context).colorScheme.secondary,
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Text(selectedMeal.ingredients[index]))), //????
                  itemCount: selectedMeal.ingredients.length,
                ),
              ),
              buildSectionTitle(context, 'Steps'),
              BuildContainer(ListView.builder(
                itemBuilder: ((ctx, index) => Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            child: Text('# ${(index + 1)}'),
                            backgroundColor: Colors.red[700],
                          ),
                          title: Text(
                            selectedMeal.steps[index],
                          ),
                        ),
                        Divider(),
                      ],
                    )),
                itemCount: selectedMeal.steps.length,
              ))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
            ),
            backgroundColor: Colors.orange[800],
            onPressed: () => setFavorite()));
  }
}
