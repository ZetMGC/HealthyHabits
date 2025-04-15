import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/DropdownCardBase.dart';
import '../data/dishes_database.dart';
import '../models/dish.dart';

class DishDropdownCard extends StatefulWidget {
  final Function(Dish) onMealSelected;

  const DishDropdownCard({super.key, required this.onMealSelected});

  @override
  State<DishDropdownCard> createState() => _DishDropdownCardState();
}

class _DishDropdownCardState extends State<DishDropdownCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isExpanded = false;
  Dish? selectedMeal;
  String searchQuery = '';
  late Future<List<Dish>> dishesFuture;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    dishesFuture = DishesDatabase.getAllDishes(); // 👈 Загрузка из Firebase
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
        selectedMeal?.name ?? "Выберите блюдо",
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      expandedChild: FutureBuilder<List<Dish>>(
        future: dishesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Нет доступных блюд"));
          }

          List<Dish> filteredMeals = snapshot.data!
              .where((dish) =>
              dish.name.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return Column(
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
                constraints: const BoxConstraints(maxHeight: 200),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: filteredMeals.length,
                    itemBuilder: (context, index) {
                      final meal = filteredMeals[index];
                      return ListTile(
                        title: Text(meal.name),
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
          );
        },
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
