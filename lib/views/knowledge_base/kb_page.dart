import 'package:final_project/views/chatbot_ai/add_chatbot_ai_page.dart';
import 'package:final_project/views/knowledge_base/add_kb_page.dart';
import 'package:final_project/widgets/kb_item.dart';
import 'package:flutter/material.dart';

class KBPage extends StatefulWidget {
  const KBPage({super.key, required this.title});

  final String title;

  @override
  State<KBPage> createState() => _KBPage();
}

class _KBPage extends State<KBPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Your Knowledge Base'),
      ),
      drawer: const Drawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Enter text',
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ListView(
              children: const <Widget>[
                KBItem(),
                KBItem(),
                KBItem(),
                KBItem(),
                KBItem(),
                KBItem(),
                KBItem(),
                KBItem(),
                KBItem(),
                KBItem(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFullModal(context),
        tooltip: 'Add Knowledge Base',
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
        return const AddKBPage();
      },
    );
  }
}
