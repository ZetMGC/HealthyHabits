class Dish {
  final String id;
  final String name;
  final String description;
  final int calories;
  final List<String> ingredients;

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.calories,
    required this.ingredients,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'calories': calories,
    'ingredients': ingredients,
  };

  static Dish fromJson(Map<String, dynamic> json) => Dish(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    calories: json['calories'],
    ingredients: List<String>.from(json['ingredients']),
  );
}
