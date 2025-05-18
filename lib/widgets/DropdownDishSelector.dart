import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/dish.dart';

class DishDropdownCard extends StatefulWidget {
  final Function(Dish) onMealSelected;
  final String? initialDishId; 

  const DishDropdownCard({
    super.key,
    required this.onMealSelected,
    this.initialDishId, 
  });

  @override
  State<DishDropdownCard> createState() => _DishDropdownCardState();
}

class _DishDropdownCardState extends State<DishDropdownCard>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  List<Dish> allMeals = [];
  List<Dish> filteredMeals = [];
  String searchQuery = '';
  Dish? selectedMeal;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    fetchMeals();

    if (widget.initialDishId != null) {
      loadInitialDish(widget.initialDishId!);
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> fetchMeals() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('dishes').get();

    final meals = snapshot.docs.map((doc) {
      final data = doc.data();
      return Dish(
        id: doc.id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        ingredients: List<String>.from(data['ingredients'] ?? []),
        calories: data['calories'] ?? 0,
      );
    }).toList();

    setState(() {
      allMeals = meals;
      filteredMeals = meals;
    });
  }

  Future<void> loadInitialDish(String dishId) async {
    final doc = await FirebaseFirestore.instance
        .collection('dishes')
        .doc(dishId)
        .get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        final dish = Dish(
          id: doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          ingredients: List<String>.from(data['ingredients'] ?? []),
          calories: data['calories'] ?? 0,
        );

        setState(() {
          selectedMeal = dish;
        });

        widget.onMealSelected(dish);
      }
    }
  }

  void filterMeals(String query) {
    setState(() {
      searchQuery = query;
      filteredMeals = allMeals
          .where((meal) =>
              meal.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: toggleExpand,
          child: Container(
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(
                selectedMeal?.name ?? 'Выбрать блюдо',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: selectedMeal != null
                  ? Text('${selectedMeal!.calories} ккал')
                  : const Text('Не выбрано'),
              trailing: RotationTransition(
                turns: Tween(begin: 0.0, end: 0.5).animate(_animationController),
                child: SvgPicture.asset(
                  'assets/icons/downarrow.svg',
                  width: 14,
                  height: 14,
                  colorFilter:
                      const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: -1,
          child: Center(
            child: Container(
              width: 350,
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Поиск по названию...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                    ),
                    onChanged: filterMeals,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _scrollController,
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
                                _controller.clear();
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
