import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dish.dart';

class DishesDatabase {
  static Future<List<Dish>> getAllDishes() async {
    final snapshot = await FirebaseFirestore.instance.collection('dishes').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Dish(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        ingredients: List<String>.from(data['ingredients']),
        calories: data['calories'],
      );
    }).toList();
  }
}
