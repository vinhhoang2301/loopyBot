import 'package:final_project/views/chatbot_ai/add_chatbot_ai_page.dart';
import 'package:final_project/widgets/chatbot_ai_item.dart';
import 'package:flutter/material.dart';

class ChatbotAIPage extends StatefulWidget {
  const ChatbotAIPage({super.key, required this.title});

  final String title;

  @override
  State<ChatbotAIPage> createState() => _ChatbotAIPage();
}

class _ChatbotAIPage extends State<ChatbotAIPage> {
  String? _selectedValue;
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Your Chatbot AI'),
      ),
      drawer: const Drawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Enter text',
                    suffixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedValue,
                  hint: const Text('Select an item'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedValue = newValue;
                    });
                  },
                  items: _items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: const <Widget>[
                ChatbotAIItem(),
                ChatbotAIItem(),
                ChatbotAIItem(),
                ChatbotAIItem(),
                ChatbotAIItem(),
                ChatbotAIItem(),
                ChatbotAIItem(),
                ChatbotAIItem(),
                ChatbotAIItem(),
                ChatbotAIItem(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFullModal(context),
        tooltip: 'Add Chatbot AI',
        child: const Icon(Icons.add),
      ),
    );
  }

  void showFullModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        builder: (context) {
          return const AddChatbotAIPage();
        },
    );
  }
}
