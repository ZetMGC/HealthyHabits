import 'package:flutter/material.dart';
import '../widgets/DropdownDatepicker.dart';
import '../widgets/DropdownCardRating.dart';
import '../widgets/AppBar.dart';
import '../widgets/MealDescriptionCard.dart';
import '../widgets/StoreSelectionCard.dart';

class FoodIntakeScreen extends StatefulWidget {
  const FoodIntakeScreen({super.key});

  @override
  State<FoodIntakeScreen> createState() => _FoodIntakeScreenState();
}

class _FoodIntakeScreenState extends State<FoodIntakeScreen> {

  @override
  Widget build(BuildContext context) {
    final String description = "Нежный жидкий желток и корочка из расплавленного сыра — вот что делает их такими вкусными и аппетитными. Идеально на завтрак.";
    final List<String> ingredients = [
      "Тостовый хлеб",
      "Сливочное масло",
      "Яйца",
      "Сыр",
      "Соль",
      "Молотый чёрный перец"
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: "Добавить прием пищи",
        showBackButton: false, // Отключаем кнопку "Назад"
        trailingIcon: Icons.notifications,
        onTrailingPressed: () {
          print("Открыть настройки!");
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 35),
            Center(
              child: DropdownCardDatepicker(
                initialTitle: "Завтрак",
                initialDate: DateTime(2024, 3, 29), // Открыт сразу
              ),
            ),
            MealDescriptionCard(
              description: description,
              ingredients: ingredients,
            ),
            Center(
              child: DropdownCardRating(),
            ),
            const SizedBox(height: 12),
            Center(
              child: StoreSelectorCard(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFE14E31), fixedSize: const Size(350, 50), shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // здесь будет логика сохранения
                print("Добавлено!");
              },
              child: DefaultTextStyle.merge(style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                  child: const Text("Добавить")
              ),
            ),
          ]
        ),
      ),
    );
  }
}