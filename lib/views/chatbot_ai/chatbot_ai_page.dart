import 'dart:developer';

import 'package:final_project/consts/app_color.dart';
import 'package:final_project/models/ai_assistant_model.dart';
import 'package:final_project/services/ai_assistant_service.dart';
import 'package:final_project/services/authen_service.dart';
import 'package:final_project/services/kb_authen_service.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/chatbot_ai/add_chatbot_ai_page.dart';
import 'package:final_project/views/empty_page.dart';
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

  bool isLoading = false;

  List<AiAssistantModel>? aiAssistants = [];
  List<AiAssistantModel>? filteredAssistants = [];

  @override
  void initState() {
    super.initState();

    _initializeData();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
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
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      color: AppColors.defaultTextColor,
                    ),
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
              child: _buildContent(),
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

  Future<void> signIn() async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    if (mounted) {
      await KBAuthService.signInFromExternalClient(context, accessToken: accessToken);
    }
  }

  Future<void> fetchAiAssistant() async {
    final assistants = await AiAssistantService.getAllAssistants(context: context);

    aiAssistants = assistants;
    filteredAssistants = assistants;
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        filteredAssistants = aiAssistants;
      } else {
        filteredAssistants = aiAssistants?.where((assistant) {
          final name = assistant.assistantName?.toLowerCase() ?? '';
          return name.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _initializeData() async {
    try {
      setState(() => isLoading = true);

      await signIn();
      await fetchAiAssistant();
    } catch (err) {
      log('Error when Initialize Data in Chatbot AI');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.defaultTextColor,
        ),
      );
    }

    log('filtered assistants = $filteredAssistants');

    if (filteredAssistants == null || filteredAssistants!.isEmpty) {
      return const EmptyPage(content: 'No AI Assistant. Let Create It');
    }

    return ListView.builder(
      itemCount: filteredAssistants!.length,
      itemBuilder: (context, index) {
        final chatbotItem = filteredAssistants![index];

        DateTime createdAt = DateTime.parse(chatbotItem.createdAt.toString());

        return ChatbotAIItem(
          chatbotName: chatbotItem.assistantName ?? 'null',
          createdAt: createdAt,
        );
      },
    );
  }
}
