import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/dish.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();

  Future<void> _saveDish() async {
    if (!_formKey.currentState!.validate()) return;

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final calories = int.tryParse(_caloriesController.text.trim()) ?? 0;
    final ingredients = _ingredientsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final dish = Dish(
      id: id,
      name: name,
      description: description,
      ingredients: ingredients,
      calories: calories,
    );

    await FirebaseFirestore.instance.collection('dishes').doc(id).set({
      'id': dish.id,
      'name': dish.name,
      'description': dish.description,
      'ingredients': dish.ingredients,
      'calories': dish.calories,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Блюдо добавлено в базу')),
    );

    _formKey.currentState!.reset();
    _nameController.clear();
    _caloriesController.clear();
    _descriptionController.clear();
    _ingredientsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить блюдо'),
        backgroundColor: const Color(0xFFE14E31),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Название блюда'),
                validator: (value) => value!.isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Калорийность'),
                validator: (value) => value!.isEmpty ? 'Введите калории' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Описание'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ingredientsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Ингредиенты (через запятую)',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveDish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE14E31),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Сохранить блюдо',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
