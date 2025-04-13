import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal_entry.dart';

class MealEntriesDatabase {
  static const _storageKey = 'meal_entries';

  static Future<List<MealEntry>> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final rawEntries = prefs.getStringList(_storageKey) ?? [];

    return rawEntries
        .map((entry) => MealEntry.fromJson(json.decode(entry)))
        .toList();
  }

  static Future<void> saveEntry(MealEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = prefs.getStringList(_storageKey) ?? [];

    entries.add(json.encode(entry.toJson()));
    await prefs.setStringList(_storageKey, entries);
  }

  static Future<void> deleteEntry(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = prefs.getStringList(_storageKey) ?? [];

    entries.removeWhere((entry) {
      final decoded = json.decode(entry);
      return decoded['id'] == id;
    });

    await prefs.setStringList(_storageKey, entries);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
