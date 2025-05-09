import 'store.dart';

class MealEntry {
  final String id;
  final String dishId;
  final String mealType;
  final String place;
  final DateTime date;
  final Store? store;
  final int rating;

  MealEntry({
    required this.id,
    required this.dishId,
    required this.mealType,
    required this.place,
    required this.date,
    this.store,
    required this.rating,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'dishId': dishId,
    'mealType': mealType,
    'place': place,
    'date': date.toIso8601String(),
    'store': store?.toJson(),
    'rating': rating,
  };

  static MealEntry fromJson(Map<String, dynamic> json) => MealEntry(
    id: json['id'],
    dishId: json['dishId'],
    mealType: json['mealType'],
    place: json['place'],
    date: DateTime.parse(json['date']),
    store: json['store'] != null ? Store.fromJson(json['store']) : null,
    rating: json['rating'] ?? 0,
  );
}
