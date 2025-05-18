import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DailyPlanCard extends StatefulWidget {
  const DailyPlanCard({super.key});

  @override
  State<DailyPlanCard> createState() => _DailyPlanCardState();
}

class _DailyPlanCardState extends State<DailyPlanCard> {
  final int total = 2000;
  int consumed = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchDailyCalories();
  }

  Future<void> fetchDailyCalories() async {
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

    int totalCalories = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final dishId = data['dishId'];

      if (dishId != null) {
        final dishSnap = await FirebaseFirestore.instance.collection('dishes').doc(dishId).get();
        final dishData = dishSnap.data();
        totalCalories += (dishData?['calories'] as num?)?.toInt() ?? 0;
      }
    }

    setState(() {
      consumed = totalCalories;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final overConsumed = consumed > total;
    final remaining = (total - consumed).abs();
    final progress = (consumed / total).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE14E31),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                const Text(
                  "Это твой сегодняшний план",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text("Показать план", style: TextStyle(color: Color(0xFFE14E31))),
                ),
                const SizedBox(height: 10),
                if (overConsumed)
                  Text(
                    "Ты превысил лимит!",
                    style: TextStyle(color: Colors.yellow[100], fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 40),
          loading
              ? const CircularProgressIndicator(color: Colors.white)
              : CircularPercentIndicator(
                  radius: 60,
                  lineWidth: 10.0,
                  percent: progress,
                  animation: true,
                  animationDuration: 800,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        overConsumed ? "+$remaining" : "$remaining",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        overConsumed ? "перебор" : "остаток",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  progressColor: overConsumed ? Colors.redAccent : Colors.white,
                  backgroundColor: Colors.white24,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
          const SizedBox(width: 30),
        ],
      ),
    );
  }
}
