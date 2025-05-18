import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:healthyhabits/models/store.dart';

class StoreSelectorCard extends StatefulWidget {
  final Function(Store?) onStoreChanged;
  final Store? initialStore; 

  const StoreSelectorCard({
    super.key,
    required this.onStoreChanged,
    this.initialStore, 
  });

  @override
  State<StoreSelectorCard> createState() => _StoreSelectorCardState();
}


class _StoreSelectorCardState extends State<StoreSelectorCard> {
  List<Store> _stores = [];
  Store? _selectedStore;

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  String _type = 'Магазин';

  @override
  void initState() {
    super.initState();
    _selectedStore = widget.initialStore;
    _loadStores();
  }


  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadStores() async {
    final prefs = await SharedPreferences.getInstance();
    final storesJson = prefs.getStringList('stores') ?? [];
    setState(() {
      _stores = storesJson.map((s) => Store.fromJson(json.decode(s))).toList();
      if (_stores.isNotEmpty) {
        _selectedStore ??= _stores.first;
        widget.onStoreChanged(_selectedStore);
      }
    });
  }

  Future<void> _saveStores() async {
    final prefs = await SharedPreferences.getInstance();
    final storeStrings = _stores.map((s) => json.encode(s.toJson())).toList();
    await prefs.setStringList('stores', storeStrings);
  }

  void _showStorePopup({Store? storeToEdit}) {
    final isEditing = storeToEdit != null;

    _nameController.text = storeToEdit?.name ?? '';
    _addressController.text = storeToEdit?.address ?? '';
    _type = storeToEdit?.type ?? 'Магазин';

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
                      _nameController.text = store.name;
                      _addressController.text = store.address;
                      _type = store.type;
                    });
                    setState(() {
                      _selectedStore = store;
                      widget.onStoreChanged(_selectedStore);
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Название магазина",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: "Адрес",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _type,
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
                onChanged: (val) => setModalState(() => _type = val ?? _type),
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
                            _selectedStore = _stores.isNotEmpty ? _stores.first : null;
                            widget.onStoreChanged(_selectedStore);
                          });
                          _saveStores();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Удалить", style: TextStyle(color: Colors.red)),
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
                        final name = _nameController.text.trim();
                        final address = _addressController.text.trim();
                        if (name.isNotEmpty && address.isNotEmpty) {
                          final newStore = Store(name: name, address: address, type: _type);
                          setState(() {
                            if (isEditing) {
                              final index = _stores.indexOf(storeToEdit!);
                              _stores[index] = newStore;
                            } else {
                              _stores.add(newStore);
                            }
                            _selectedStore = newStore;
                            widget.onStoreChanged(_selectedStore);
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
                  _showStorePopup();
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
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
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
                borderRadius: BorderRadius.circular(10),
              ),
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
