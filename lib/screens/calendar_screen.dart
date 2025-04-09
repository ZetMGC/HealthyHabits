import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../data/MockData.dart';
import '../models/meal.dart';
import '../widgets/DateSelector.dart';
import '../widgets/FilterButtons.dart';
import '../widgets/MealCard.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  DateTime selectedDate = DateTime(2025, 5, 25);
  String selectedType = "Все";

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ru_RU', null);
  }

  List<DateTime> get allDates {
    return mockMeals.map((meal) => meal.date).toSet().toList()..sort();
  }

  List<String> get types {
    return ["Все", ...{for (var m in mockMeals) m.type}];
  }

  List<Meal> get filteredMeals {
    return mockMeals.where((meal) {
      final matchDate = meal.date == selectedDate;
      final matchType = selectedType == "Все" || meal.type == selectedType;
      return matchDate && matchType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Мой план питания"),
        centerTitle: true,
        leading: const Icon(Icons.arrow_back),
        actions: const [Icon(Icons.notifications)],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateSelector(
            dates: allDates,
            selectedDate: selectedDate,
            onDateSelected: (date) {
              setState(() => selectedDate = date);
            },
          ),
          const SizedBox(height: 8),
          FilterButtons(
            filters: types,
            selected: selectedType,
            onChanged: (type) {
              setState(() => selectedType = type);
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredMeals.isEmpty
                ? const Center(child: Text("Нет данных на выбранную дату"))
                : ListView.builder(
              itemCount: filteredMeals.length,
              itemBuilder: (context, index) {
                final meal = filteredMeals[index];
                return MealCard(
                  meal: meal,
                  onTap: () {
                    Navigator.pushNamed(context, '/edit', arguments: meal);
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
