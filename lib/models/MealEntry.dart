// models/meal_entry.dart

class MealEntry {
  final DateTime date;
  final String type; // завтрак, обед и т.д.
  final String place;
  final String mealTitle;

  MealEntry({
    required this.date,
    required this.type,
    required this.place,
    required this.mealTitle,
  });
}
