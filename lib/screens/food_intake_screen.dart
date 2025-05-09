import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthyhabits/models/dish.dart';
import 'package:healthyhabits/models/store.dart';

import '../widgets/DropdownDatepicker.dart';
import '../widgets/DropdownCardRating.dart';
import '../widgets/AppBar.dart';
import '../widgets/MealDescriptionCard.dart';
import '../widgets/StoreSelectionCard.dart';
import '../widgets/DropdownDishSelector.dart';

class FoodIntakeScreen extends StatefulWidget {
  const FoodIntakeScreen({super.key});

  @override
  State<FoodIntakeScreen> createState() => _FoodIntakeScreenState();
}

class _FoodIntakeScreenState extends State<FoodIntakeScreen> {
  Dish? selectedDish;
  DateTime selectedDate = DateTime.now();
  String selectedMealType = "Завтрак";
  int selectedRating = 0;
  String comment = '';
  Store? selectedStore;

  void _addMealEntry() async {
    if (selectedDish == null) return;

    final entryData = {
      'date': selectedDate.toIso8601String(),
      'mealType': selectedMealType,
      'dishId': selectedDish!.id,
      'place': comment,
      'store': selectedStore != null
          ? {
        'name': selectedStore!.name,
        'address': selectedStore!.address,
        'type': selectedStore!.type,
      }
          : null,
      'rating': selectedRating,
    };

    print('rating: $selectedRating'); // ✅ для отладки

    try {
      await FirebaseFirestore.instance.collection('meal_entries').add(entryData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Прием пищи сохранён в Firebase')),
      );

      // Очистить поля после сохранения
      setState(() {
        selectedDish = null;
        selectedRating = 0;
        comment = '';
        selectedStore = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении: $e')),
      );
    }
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
                  initialTitle: selectedMealType,
                  initialDate: selectedDate,
                  onChanged: (type, date) {
                    setState(() {
                      selectedMealType = type;
                      selectedDate = date;
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              DishDropdownCard(
                onMealSelected: (Dish dish) {
                  setState(() {
                    selectedDish = dish;
                  });
                },
              ),
              if (selectedDish != null)
                MealDescriptionCard(
                  description: selectedDish!.description,
                  ingredients: selectedDish!.ingredients,
                ),
              if (selectedDish == null) const SizedBox(height: 12),
              Center(
                child: DropdownCardRating(
                  onRatingChanged: (val) {
                    selectedRating = val; // ✅ фикс: без setState
                  },
                  onCommentChanged: (val) => comment = val,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: StoreSelectorCard(
                  onStoreChanged: (store) => setState(() => selectedStore = store),
                ),
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
                onPressed: _addMealEntry,
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
