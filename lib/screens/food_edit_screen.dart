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

class FoodEditScreen extends StatefulWidget {
  final String mealEntryId;

  const FoodEditScreen({required this.mealEntryId, super.key});

  @override
  State<FoodEditScreen> createState() => _FoodEditScreenState();
}

class _FoodEditScreenState extends State<FoodEditScreen> {
  final ScrollController _scrollController = ScrollController();

  Dish? selectedDish;
  DateTime selectedDate = DateTime.now();
  String selectedMealType = "Завтрак";
  int selectedRating = 0;
  String comment = '';
  Store? selectedStore;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMealEntry();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadMealEntry() async {
    final doc = await FirebaseFirestore.instance
        .collection('meal_entries')
        .doc(widget.mealEntryId)
        .get();

    final data = doc.data();
    if (data == null) return;

    final dishSnap = await FirebaseFirestore.instance
        .collection('dishes')
        .doc(data['dishId'])
        .get();
    final dishData = dishSnap.data();

    setState(() {
      selectedDish = Dish(
        id: dishSnap.id,
        name: dishData?['name'] ?? '',
        description: dishData?['description'] ?? '',
        ingredients: List<String>.from(dishData?['ingredients'] ?? []),
        calories: dishData?['calories'] ?? 0,
      );

      selectedDate = (data['date'] as Timestamp).toDate();
      selectedMealType = data['mealType'];
      selectedRating = data['rating'] ?? 0;
      comment = data['comment'] ?? '';

      if (data['store'] != null) {
        selectedStore = Store(
          name: data['store']['name'] ?? '',
          address: data['store']['address'] ?? '',
          type: data['store']['type'] ?? '',
        );
      }

      loading = false;
    });
  }

  Future<void> _updateMealEntry() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || selectedDish == null) return;

    final updateData = {
      'date': Timestamp.fromDate(selectedDate),
      'mealType': selectedMealType,
      'dishId': selectedDish!.id,
      'comment': comment,
      'rating': selectedRating,
      'store': selectedStore != null
          ? {
              'name': selectedStore!.name,
              'address': selectedStore!.address,
              'type': selectedStore!.type,
            }
          : null,
    };

    try {
      await FirebaseFirestore.instance
          .collection('meal_entries')
          .doc(widget.mealEntryId)
          .update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Прием пищи обновлён')),
      );

      Navigator.pop(context); // Вернуться назад после сохранения
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при обновлении: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "Редактировать приём пищи",
        showBackButton: true,
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
                initialDishId: selectedDish?.id,
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
              const SizedBox(height: 12),
              Center(
                child: DropdownCardRating(
                  initialRating: selectedRating,
                  initialComment: comment,
                  onRatingChanged: (val) => selectedRating = val,
                  onCommentChanged: (val) => comment = val,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: StoreSelectorCard(
                  initialStore: selectedStore,
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
                onPressed: _updateMealEntry,
                child: const Text(
                  "Сохранить изменения",
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
