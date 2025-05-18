import 'package:flutter/material.dart';
import '../widgets/home_screen/HomeHeader.dart';
import '../widgets/home_screen/DailyPlanCard.dart';
import '../widgets/home_screen/MealTypeList.dart';
import '../widgets/home_screen/SuggestionCard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HomeHeader(),
              SizedBox(height: 24),
              DailyPlanCard(),
              SizedBox(height: 24),
              SuggestionsSection(),
              SizedBox(height: 24),
              MealTypeList(),
            ],
          ),
        ),
      ),
    );
  }
}
