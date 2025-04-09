import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
  });

  Color getTypeColor(String type) {
    switch (type) {
      case "Завтрак":
        return Colors.deepPurple;
      case "Обед":
        return Colors.pink;
      case "Перекус":
        return Colors.amber;
      case "Ужин":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getTypeColor(meal.type);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Icon(Icons.lock, color: color),
          title: Text(meal.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Блюдо на ${meal.type} в ${meal.place}"),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(meal.time, style: TextStyle(color: color)),
              Text("${meal.calories} ккал", style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
