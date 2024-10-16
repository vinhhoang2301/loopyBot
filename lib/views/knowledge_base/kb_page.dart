import 'package:final_project/utils/global_methods.dart';
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
        onPressed: () {
          Utils.showBottomSheet(
            context,
            sheet: const AddKBPage(),
            showFullScreen: true,
          );
        },
        tooltip: 'Add Knowledge Base',
        child: const Icon(Icons.add),
      ),
    );
  }
}
