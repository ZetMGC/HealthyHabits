import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:healthyhabits/screens/food_edit_screen.dart';

import '../widgets/HorizontalDatePicker.dart';
import '../widgets/AppBar.dart';

class FoodEntriesScreen extends StatefulWidget {
  const FoodEntriesScreen({super.key});

  @override
  State<FoodEntriesScreen> createState() => _FoodEntriesScreenState();
}

class _FoodEntriesScreenState extends State<FoodEntriesScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedMealType = 'Все';

  final List<String> mealTypes = ['Все', 'Завтрак', 'Обед', 'Ужин', 'Перекус'];

  Stream<QuerySnapshot<Map<String, dynamic>>> getMealEntriesStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    final startOfDay = Timestamp.fromDate(DateTime(selectedDate.year, selectedDate.month, selectedDate.day).toUtc());
    final endOfDay = Timestamp.fromDate(DateTime(selectedDate.year, selectedDate.month, selectedDate.day).add(const Duration(days: 1)).toUtc());

    print("Start of day: $startOfDay, End of day: $endOfDay"); // Добавьте логи

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('meal_entries')
        .where('userId', isEqualTo: user.uid)
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThan: endOfDay);

    if (selectedMealType != 'Все') {
      query = query.where('mealType', isEqualTo: selectedMealType);
    }

    return query.orderBy('date').snapshots();
  }

  Future<Map<String, dynamic>?> getDishById(String dishId) async {
    print("Fetching dish with ID: $dishId"); // Логирование ID
    final doc = await FirebaseFirestore.instance.collection('dishes').doc(dishId).get();
    if (doc.exists) {
      print("Dish found: ${doc.data()}");
    } else {
      print("Dish not found");
    }
    return doc.exists ? doc.data() : null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "Добавить прием пищи",
          showBackButton: false,
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 35),
          HorizontalDatePicker(
            initialDate: selectedDate,
            onDateSelected: (date) {
              setState(() => selectedDate = date);
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40, // фиксированная высота под чипы
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: mealTypes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final type = mealTypes[index];
                final isSelected = type == selectedMealType;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (_) => setState(() => selectedMealType = type),
                  selectedColor: const Color(0xFFE14E31),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( 
              stream: getMealEntriesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Нет приёмов пищи на этот день.'));
                }

                final meals = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final mealDoc = meals[index];
                    final mealData = mealDoc.data();
                    final mealEntryId = mealDoc.id;  // Ид документа meal_entries
                    final mealTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(mealData['date'].toDate());
                    final mealType = mealData['mealType'];
                    final dishId = mealData['dishId'];

                    return FutureBuilder<Map<String, dynamic>?>(
                      future: getDishById(dishId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }

                        final dish = snapshot.data!;
                        final dishName = dish['name'] ?? 'Без названия';
                        final calories = dish['calories']?.toString() ?? '–';

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FoodEditScreen(mealEntryId: mealEntryId),
                              ),
                            ).then((_) {
                              // После возврата с экрана редактирования, можно обновить состояние,
                              // чтобы обновить список, если нужно
                              setState(() {});
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Блюдо на $mealType",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dishName,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16, color: Colors.purple),
                                    const SizedBox(width: 4),
                                    Text(
                                      mealTime,
                                      style: const TextStyle(color: Colors.purple),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "$calories ккал",
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
