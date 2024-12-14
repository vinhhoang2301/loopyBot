import 'package:final_project/consts/app_color.dart';
import 'package:final_project/models/kb_model.dart';
import 'package:final_project/services/ai_assistant_service.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/chatbot_ai/import_knowledge_page.dart';
import 'package:final_project/views/empty_page.dart';
import 'package:final_project/views/error_page.dart';
import 'package:final_project/widgets/kb_item.dart';
import 'package:flutter/material.dart';

class ChatbotKnowledgePage extends StatefulWidget {
  const ChatbotKnowledgePage({
    super.key,
    required this.id,
    required this.assistantName,
  });

  final String id;
  final String assistantName;

  @override
  State<ChatbotKnowledgePage> createState() => _AddKBPage();
}

class _AddKBPage extends State<ChatbotKnowledgePage> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  List<KbModel>? importedKnowledge = [];
  List<KbModel>? filteredKnowledge = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    fetchImportedKnowledge();

    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchFocusNode.unfocus();
    _searchController.dispose();

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
          title: Text('Knowledge Base of ${widget.assistantName}'),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.inverseTextColor,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: TextField(
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
                  hintText: 'Search Knowledge Base',
                  suffixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Utils.showBottomSheet(
              context,
              sheet: ImportKnowledgePage(
                assistantName: widget.assistantName,
                assistantId: widget.id,
              ),
              showFullScreen: true,
            );
          },
          tooltip: 'Add Knowledge Base',
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.inverseTextColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.defaultTextColor,
        ),
      );
    }

    if (filteredKnowledge == null) {
      return const ErrorPage(content: 'Something went wrong. Please try again');
    }

    if (filteredKnowledge!.isEmpty) {
      return const EmptyPage(content: 'No Knowledge Base. Let Add It');
    }

    return ListView.builder(
      itemCount: filteredKnowledge!.length,
      itemBuilder: (context, index) {
        final knowledgeBase = filteredKnowledge![index];

        DateTime createdAt = DateTime.parse(knowledgeBase.createdAt.toString());
        return knowledgeBase.kbId != null
            ? KBItem(
                createdAt: createdAt,
                kbName: knowledgeBase.knowledgeName!,
                id: knowledgeBase.kbId!,
                delete: () {
                  // todo: need handle here
                },
              )
            : const SizedBox(
                height: 40,
                child: Text(
                  'Failed to get KB',
                  style: TextStyle(color: Colors.red),
                ),
              );
      },
    );
  }

  Future<void> fetchImportedKnowledge() async {
    try {
      setState(() => _isLoading = true);

      final result = await AiAssistantService.getImportedKnowledge(
        context: context,
        assistantId: widget.id,
      );

      setState(() {
        importedKnowledge = result;
        filteredKnowledge = result;
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        importedKnowledge = null;
        _isLoading = false;
      });
    }
  }
}
