import 'package:final_project/consts/app_color.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/chatbot_ai/add_chatbot_ai_page.dart';
import 'package:final_project/views/chatbot_ai/preview_chatbot_ai_page.dart';
import 'package:final_project/widgets/chatbot_ai_item.dart';
import 'package:final_project/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';

class ChatbotAIPage extends StatefulWidget {
  const ChatbotAIPage({super.key});

  @override
  State<ChatbotAIPage> createState() => _ChatbotAIPage();
}

class _ChatbotAIPage extends State<ChatbotAIPage> {
  String? _selectedValue;
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chatbot AI'),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.inverseTextColor,
        ),
        drawer: const TabBarWidget(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 2.0,
                        ),
                      ),
                      hintText: 'Search your Chatbot',
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
                children: _items.map((item) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PreviewChatbot(),
                        ),
                      );
                    },
                    child: const ChatbotAIItem(),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Utils.showBottomSheet(
              context,
              sheet: const AddChatbotAIPage(),
              showFullScreen: true,
            );
          },
          tooltip: 'Add Chatbot AI',
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.inverseTextColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
