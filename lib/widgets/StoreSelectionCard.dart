import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Store {
  final String name;
  final String address;
  final String type;

  Store({required this.name, required this.address, required this.type});

  Map<String, String> toJson() => {
    'name': name,
    'address': address,
    'type': type,
  };

  static Store fromJson(Map<String, dynamic> json) => Store(
    name: json['name'],
    address: json['address'],
    type: json['type'],
  );

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Store &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              address == other.address &&
              type == other.type;

  @override
  int get hashCode => name.hashCode ^ address.hashCode ^ type.hashCode;
}

class StoreSelectorCard extends StatefulWidget {
  const StoreSelectorCard({super.key});

  @override
  State<StoreSelectorCard> createState() => _StoreSelectorCardState();
}

class _StoreSelectorCardState extends State<StoreSelectorCard> {
  List<Store> _stores = [];
  Store? _selectedStore;

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    final prefs = await SharedPreferences.getInstance();
    final storesJson = prefs.getStringList('stores') ?? [];
    setState(() {
      _stores = storesJson.map((s) => Store.fromJson(json.decode(s))).toList();
      if (_stores.isNotEmpty) {
        _selectedStore ??= _stores.first;
      }
    });
  }

  Future<void> _saveStores() async {
    final prefs = await SharedPreferences.getInstance();
    final storeStrings = _stores.map((s) => json.encode(s.toJson())).toList();
    await prefs.setStringList('stores', storeStrings);
  }

  void _showStorePopup({Store? storeToEdit}) {
    bool isEditing = storeToEdit != null;
    String name = storeToEdit?.name ?? '';
    String address = storeToEdit?.address ?? '';
    String type = storeToEdit?.type ?? 'Магазин';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Управление магазином",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Store>(
                value: _selectedStore,
                decoration: InputDecoration(
                  labelText: "Выберите магазин",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _stores.map((store) {
                  return DropdownMenuItem(
                    value: store,
                    child: Text(store.name),
                  );
                }).toList(),
                onChanged: (store) {
                  if (store != null) {
                    setModalState(() {
                      name = store.name;
                      address = store.address;
                      type = store.type;
                    });
                    setState(() => _selectedStore = store);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: TextEditingController(text: name),
                decoration: InputDecoration(
                  labelText: "Название магазина",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: TextEditingController(text: address),
                decoration: InputDecoration(
                  labelText: "Адрес",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => address = value,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: type,
                decoration: InputDecoration(
                  labelText: "Тип",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: ["Магазин", "Супермаркет", "Мини-маркет"]
                    .map((t) => DropdownMenuItem(
                  value: t,
                  child: Text(t),
                ))
                    .toList(),
                onChanged: (val) => setModalState(() => type = val ?? type),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (isEditing)
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _stores.remove(storeToEdit);
                            _selectedStore =
                            _stores.isNotEmpty ? _stores.first : null;
                          });
                          _saveStores();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Удалить",
                            style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  if (isEditing) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (name.isNotEmpty && address.isNotEmpty) {
                          final newStore =
                          Store(name: name, address: address, type: type);
                          setState(() {
                            if (isEditing) {
                              final index = _stores.indexOf(storeToEdit!);
                              _stores[index] = newStore;
                            } else {
                              _stores.add(newStore);
                            }
                            _selectedStore = newStore;
                          });
                          _saveStores();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(isEditing ? "Сохранить" : "Добавить"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showStorePopup(); // перезапуск с пустыми полями
                },
                child: const Text("Создать новый магазин"),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.teal,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedStore?.name ?? "Нет магазина",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                Text(
                  _selectedStore?.type ?? "",
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.2),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => _showStorePopup(storeToEdit: _selectedStore),
            child: const Text(
              "Изменить",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
