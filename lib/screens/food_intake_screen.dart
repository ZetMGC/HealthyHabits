import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final ScrollController _scrollController = ScrollController();

  Dish? selectedDish;
  DateTime selectedDate = DateTime.now(); // <- теперь это DateTime
  String selectedMealType = "Завтрак";
  int selectedRating = 0;
  String comment = '';
  Store? selectedStore;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addMealEntry() async {
    if (selectedDish == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка: пользователь не вошёл')),
      );
      return;
    }

    final entryData = {
      'userId': user.uid,
      'date': Timestamp.fromDate(selectedDate), // <-- конвертация здесь
      'mealType': selectedMealType,
      'dishId': selectedDish!.id,
      'comment': comment,
      'store': selectedStore != null
          ? {
              'name': selectedStore!.name,
              'address': selectedStore!.address,
              'type': selectedStore!.type,
            }
          : null,
      'rating': selectedRating,
    };

    try {
      await FirebaseFirestore.instance.collection('meal_entries').add(entryData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Прием пищи сохранён в Firebase')),
      );

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
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: "Добавить прием пищи",
          showBackButton: true,
        ),
        body: const Center(
          child: Text(
            'Пожалуйста, войдите в аккаунт, чтобы добавить приём пищи.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

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
          controller: _scrollController,
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
                      selectedDate = date.toDate();
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
                    selectedRating = val;
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
