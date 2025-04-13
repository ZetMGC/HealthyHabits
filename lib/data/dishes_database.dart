import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:healthyhabits/models/dish.dart';

class DishesDatabase {
  static Future<List<Dish>> loadDishes() async {
    final data = await rootBundle.loadString('assets/data/dishes.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => Dish.fromJson(json)).toList();
  }
}
