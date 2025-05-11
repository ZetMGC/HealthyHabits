import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MealTypeList extends StatefulWidget {
  const MealTypeList({super.key});

  @override
  State<MealTypeList> createState() => _MealTypeListState();
}

class _MealTypeListState extends State<MealTypeList> {
  final types = ['Завтрак', 'Обед', 'Ужин', 'Перекус'];
  final colors = [Colors.pink, Colors.purple, Colors.orange, Colors.yellow];
  final calorieLimits = {
    'Завтрак': 400,
    'Обед': 600,
    'Ужин': 500,
    'Перекус': 200,
  };

  Map<String, int> caloriesPerType = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCalories();
  }

 Future<void> fetchCalories() async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  final snapshot = await FirebaseFirestore.instance
      .collection('meal_entries')
      .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
      .where('date', isLessThanOrEqualTo: Timestamp.fromDate(today.add(const Duration(days: 1))))
      .where('userId', isEqualTo: user.uid)
      .get();

  final Map<String, int> temp = {};

  for (var doc in snapshot.docs) {
    final data = doc.data();
    final type = data['mealType'];
    final dishId = data['dishId'];

    if (type != null && dishId != null) {
      final dishSnap = await FirebaseFirestore.instance.collection('dishes').doc(dishId).get();
      final dishData = dishSnap.data();
      final calories = (dishData?['calories'] ?? 0).toInt();

      temp[type] = ((temp[type] ?? 0) + calories).toInt();
    }
  }

  setState(() {
    caloriesPerType = temp;
    loading = false;
  });
}


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ваши приёмы пищи", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        ...List.generate(types.length, (i) {
          final type = types[i];
          final total = caloriesPerType[type] ?? 0;
          final limit = calorieLimits[type]!;
          final percent = (total / limit).clamp(0.0, 1.0);
          final color = total > limit ? Colors.red : colors[i];

          return GestureDetector(
            onTap: () => _showMealPopup(context, type),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  Icon(Icons.fastfood, color: color),
                  const SizedBox(width: 12),
                  Expanded(child: Text(type, style: const TextStyle(fontWeight: FontWeight.w500))),
                  CircularPercentIndicator(
                    radius: 22,
                    lineWidth: 4,
                    percent: percent,
                    animation: true,
                    animationDuration: 800,
                    backgroundColor: Colors.grey.shade200,
                    progressColor: color,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      "$total\n/$limit",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showMealPopup(BuildContext context, String mealType) {
    final now = DateTime.now();
    final user = FirebaseAuth.instance.currentUser;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          initialChildSize: 0.6,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(mealType, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('meal_entries')
                          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(now.year, now.month, now.day)))
                          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(DateTime(now.year, now.month, now.day).add(const Duration(days: 1))))
                          .where('mealType', isEqualTo: mealType)
                          .where('userId', isEqualTo: user?.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final docs = snapshot.data?.docs ?? [];
                        if (docs.isEmpty) {
                          return const Center(child: Text("Нет записей"));
                        }

                        return ListView.builder(
                          controller: controller,
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data() as Map<String, dynamic>;
                            final dishId = data['dishId'];

                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection('dishes').doc(dishId).get(),
                              builder: (context, dishSnapshot) {
                                if (dishSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                if (dishSnapshot.hasError || !dishSnapshot.hasData) {
                                  return const Center(child: Text("Ошибка загрузки данных блюда"));
                                }

                                final dishData = dishSnapshot.data?.data() as Map<String, dynamic>?;
                                final dishTitle = dishData?['name'] ?? 'Без названия';
                                final dishDescription = dishData?['description'] ?? 'Описание отсутствует';

                                return Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: ListTile(
                                    leading: const Icon(Icons.restaurant),
                                    title: Text(dishTitle),
                                    subtitle: Text("$dishDescription, ${data['calories'] ?? 0} ккал"),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () {
                                      // TODO: открыть экран редактирования
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
