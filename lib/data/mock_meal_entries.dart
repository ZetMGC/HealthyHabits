import '../models/meal_entry.dart';
import '../models/store.dart';

final mockMealEntries = [
  MealEntry(
    id: 'entry1',
    date: DateTime(2025, 4, 9),
    mealType: 'Завтрак',
    dishId: 'dish1',
    place: 'Дом',
    store: null,
    rating: 5
  ),
  MealEntry(
    id: 'entry2',
    date: DateTime(2025, 4, 9),
    mealType: 'Обед',
    dishId: 'dish2',
    place: 'Работа',
    store: Store(name: 'Магнит', address: 'ул. Ленина 1', type: 'Супермаркет'),
    rating: 4,
  ),
  MealEntry(
    id: 'entry3',
    date: DateTime(2025, 4, 8),
    mealType: 'Ужин',
    dishId: 'dish3',
    place: 'Дом',
    store: Store(name: 'Пятёрочка', address: 'ул. Советская 7', type: 'Мини-маркет'),
    rating: 3,
  ),
];
