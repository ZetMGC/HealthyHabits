import '../models/meal.dart';

final List<Meal> mockMeals = [
  Meal(
    title: "Тосты с Яичницей",
    type: "Завтрак",
    place: "Дом",
    time: "08:00",
    calories: 100,
    date: DateTime(2025, 5, 25),
    description: "Хрустящие тосты с жареными яйцами, подаются горячими.",
    ingredients: ["Хлеб", "Яйца", "Масло", "Соль", "Перец"],
  ),
  Meal(
    title: "Плов с курицей",
    type: "Обед",
    place: "Офис",
    time: "12:00",
    calories: 1000,
    date: DateTime(2025, 5, 25),
    description: "Традиционный плов с ароматным рисом и сочной курицей.",
    ingredients: ["Рис", "Курица", "Морковь", "Лук", "Чеснок", "Приправы"],
  ),
  Meal(
    title: "Плов с курицей",
    type: "Обед",
    place: "Офис",
    time: "12:00",
    calories: 1000,
    date: DateTime(2025, 10, 25),
    description: "Традиционный плов с ароматным рисом и сочной курицей.",
    ingredients: ["Рис", "Курица", "Морковь", "Лук", "Чеснок", "Приправы"],
  ),
  Meal(
    title: "Кофе с Маффином",
    type: "Перекус",
    place: "Столовая",
    time: "16:00",
    calories: 1000,
    date: DateTime(2025, 5, 25),
    description: "Свежесваренный кофе и сладкий шоколадный маффин.",
    ingredients: ["Кофе", "Молоко", "Сахар", "Маффин", "Шоколад"],
  ),
  Meal(
    title: "Цезарь с Креветками",
    type: "Ужин",
    place: "Ресторан",
    time: "20:00",
    calories: 1000,
    date: DateTime(2025, 5, 25),
    description: "Классический салат Цезарь с хрустящими креветками.",
    ingredients: ["Креветки", "Салат Романо", "Сухарики", "Пармезан", "Соус Цезарь"],
  ),
];
