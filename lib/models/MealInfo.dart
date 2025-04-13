class MealInfo {
  final String id;
  final String title;
  final String description;
  final int calories;
  final List<String> ingredients;

  MealInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.calories,
    required this.ingredients,
  });
}
