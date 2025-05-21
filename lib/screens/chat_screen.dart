import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  bool _isLoading = false;

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": text});
      _isLoading = true;
    });

    try {
      final response = await http.post(
       Uri.parse('http://10.0.2.2:5000/meal_plan'), // Заменить при деплое
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'allergies': [],
          'preferences': [text],
          'goal': 'сбалансированное питание',
        }),
      );

      final data = jsonDecode(response.body);
      final String reply = data['plan'] ?? "Не удалось получить ответ";

      setState(() {
        _messages.add({"role": "bot", "text": reply});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({"role": "bot", "text": "Ошибка: $e"});
        _isLoading = false;
      });
    }

    _controller.clear();
  }

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['role'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.redAccent : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message['text'] ?? '',
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF2FF),
      appBar: AppBar(
        title: const Text("Чат АлгУс"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              reverse: true,
              children: _messages.reversed.map(_buildMessage).toList(),
            ),
          ),
          if (_isLoading) const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Написать сообщение...",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () => _sendMessage(_controller.text),
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.send),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
