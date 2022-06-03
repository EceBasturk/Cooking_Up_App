part of 'meal.dart';

Meal _$MealFromJson(Map<String, dynamic> json) {
  return Meal(
      id: json['id'],
      categories: List.from(json['categories']),
      title: json['title'],
      imageUrl: json['imageUrl'],
      ingredients: List.from(json['ingredients']),
      steps: List.from(json['steps']),
      duration: json['duration'],
      complexity: complexityFromString(json['complexity']),
      affordability: affordabilityFromString(json['affordability']),
      isGlutenFree: json['isGlutenFree'],
      isLactoseFree: json['isLactoseFree'],
      isVegan: json['isVegan'],
      isVegetarian: json['isVegetarian'],
      isFavorited: json['isFavorited']);
}

Map<String, dynamic> _$MealToJson(Meal instance){
  return <String, dynamic>{
    'id': instance.id,
    'categories': instance.categories,
    'title': instance.title,
    'imageUrl': instance.imageUrl,
    'ingredients': instance.ingredients,
    'steps': instance.steps,
    'duration': instance.duration,
    'complexity': instance.complexity.name,
    'affordability': instance.affordability.name,
    'isGlutenFree': instance.isGlutenFree,
    'isLactoseFree': instance.isLactoseFree,
    'isVegan': instance.isVegan,
    'isVegetarian': instance.isVegetarian,
    'isFavorited': instance.isFavorited,
  };
}

Affordability affordabilityFromString(String affordability) {
  switch (affordability) {
    case 'affordable':
      return Affordability.Affordable;
    case 'pricey':
      return Affordability.Pricey;
    case 'luxurious':
      return Affordability.Luxurious;
    default:
      return Affordability.Affordable;
  }
}

Complexity complexityFromString(String complexity) {
  switch (complexity) {
    case 'simple':
      return Complexity.Simple;
    case 'challenging':
      return Complexity.Challenging;
    case 'hard':
      return Complexity.Hard;
    default:
    return Complexity.Simple;
  }
}
