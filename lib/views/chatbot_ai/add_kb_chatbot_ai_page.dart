import 'package:final_project/consts/app_color.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/knowledge_base/add_kb_page.dart';
import 'package:final_project/widgets/kb_item.dart';
import 'package:flutter/material.dart';

class AddKBToChatbot extends StatefulWidget {
  const AddKBToChatbot({super.key});

  @override
  State<AddKBToChatbot> createState() => _AddKBPage();
}

class _AddKBPage extends State<AddKBToChatbot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Knowledge Base to chatbot'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.inverseTextColor,
      ),
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
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.inverseTextColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
