import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/DropdownCardBase.dart';
import '../data/MockData.dart';
import '../models/meal.dart';

class MealDropdownCard extends StatefulWidget {
  final Function(Meal) onMealSelected;

  const MealDropdownCard({super.key, required this.onMealSelected});

  @override
  State<MealDropdownCard> createState() => _MealDropdownCardState();
}

class _MealDropdownCardState extends State<MealDropdownCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isExpanded = false;
  Meal? selectedMeal;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Meal> filteredMeals = mockMeals
        .where((meal) =>
        meal.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return DropdownCardBase(
      icon: SvgPicture.asset(
        'assets/icons/food.svg',
        width: 20,
        height: 20,
        colorFilter: const ColorFilter.mode(
          Colors.black,
          BlendMode.srcIn,
        ),
      ),
      title: "Название блюда",
      subtitle: Text(
        selectedMeal?.title ?? "Выберите блюдо",
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      expandedChild: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Поиск...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 200, // Максимальная высота
            ),
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: filteredMeals.length,
                itemBuilder: (context, index) {
                  final meal = filteredMeals[index];
                  return ListTile(
                    title: Text(meal.title),
                    subtitle: Text('${meal.calories} ккал'),
                    onTap: () {
                      setState(() {
                        selectedMeal = meal;
                        widget.onMealSelected(meal);
                        toggleExpand();
                        searchQuery = '';
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      animationController: _controller,
      onTap: toggleExpand,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
