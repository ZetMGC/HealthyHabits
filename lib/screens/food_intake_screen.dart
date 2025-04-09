import 'package:flutter/material.dart';
import 'package:healthyhabits/models/meal.dart';
import '../widgets/DropdownDatepicker.dart';
import '../widgets/DropdownCardRating.dart';
import '../widgets/AppBar.dart';
import '../widgets/MealDescriptionCard.dart';
import '../widgets/StoreSelectionCard.dart';
import '../widgets/DropdownMealType.dart';
import '../data/MockData.dart';

class FoodIntakeScreen extends StatefulWidget {
  const FoodIntakeScreen({super.key});

  @override
  State<FoodIntakeScreen> createState() => _FoodIntakeScreenState();
}

class _FoodIntakeScreenState extends State<FoodIntakeScreen> {
  Meal? selectedMeal;

  @override
  void initState() {
    super.initState();
    selectedMeal = mockMeals.first; // по умолчанию первое блюдо
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Добавить прием пищи",
        showBackButton: false,
        trailingIcon: Icons.notifications,
        onTrailingPressed: () {
          print("Открыть настройки!");
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            children: [
              const SizedBox(height: 35),
              Center(
                child: DropdownCardDatepicker(
                  initialTitle: "Завтрак",
                  initialDate: DateTime(2024, 3, 29),
                ),
              ),
              const SizedBox(height: 12),
              MealDropdownCard(
                onMealSelected: (Meal meal) {
                  setState(() {
                    selectedMeal = meal;
                  });
                },
              ),
              if (selectedMeal != null)
                MealDescriptionCard(
                  description: selectedMeal!.description,
                  ingredients: selectedMeal!.ingredients,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE14E31),
                  fixedSize: const Size(350, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  print("Добавлено блюдо: ${selectedMeal?.title}");
                },
                child: const Text(
                  "Добавить",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
