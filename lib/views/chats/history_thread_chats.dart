import 'dart:developer';

import 'package:final_project/consts/app_color.dart';
import 'package:final_project/models/conversation_model.dart';
import 'package:final_project/services/ai_chat_service.dart';
import 'package:final_project/widgets/thread_chat_item.dart';
import 'package:flutter/material.dart';

class HistoryThreadChatPage extends StatefulWidget {
  const HistoryThreadChatPage({super.key});

  @override
  State<HistoryThreadChatPage> createState() => _HistoryThreadChatPageState();
}

class _HistoryThreadChatPageState extends State<HistoryThreadChatPage> {
  final FocusNode _searchNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  List<ConversationModel> _listConversations = [];
  List<ConversationModel> _filteredConversations = [];
  bool isLoading = false;

  @override
  void initState() {
    _getConversationsData();

    _searchController.addListener(onSearchChanged);
    _searchNode.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _searchNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _searchNode.unfocus();
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 48,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Conversation History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // todo: refactor this row
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchNode,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.backgroundColor2,
                          width: 2.0,
                        ),
                      ),
                      hintText: 'Search conversation',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                              onPressed: _searchController.clear,
                            )
                          : const Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.backgroundColor2,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.star_border_outlined,
                        size: 28,
                        color: AppColors.backgroundColor2,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.backgroundColor2,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.delete_outline_outlined,
                        size: 28,
                        color: AppColors.backgroundColor2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _filteredConversations.length,
                      itemBuilder: (context, index) {
                        final thread = _filteredConversations[index];
                        return ThreadChatItem(
                          id: thread.id ?? '',
                          title: thread.title ?? '',
                          createAt: thread.createdAt ?? 0,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _getConversationsData() async {
    setState(() => isLoading = true);

    try {
      _listConversations = await AiChatServices.getConversations(
        context,
        assistantId: 'gpt-4o-mini',
      );

      _filteredConversations = _listConversations;
    } catch (e) {
      log('Error when loading history thread chats: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load conversations'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        _filteredConversations = _listConversations;
      } else {
        _filteredConversations = _listConversations.where((conversation) {
          return conversation.title?.toLowerCase().contains(query) ?? false;
        }).toList();
      }
    });
  }
}
