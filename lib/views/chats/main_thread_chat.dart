import 'dart:developer';

import 'package:final_project/consts/app_color.dart';
import 'package:final_project/consts/app_routes.dart';
import 'package:final_project/models/ai_agent_model.dart';
import 'package:final_project/models/chat_metadata.dart';
import 'package:final_project/services/ai_chat_service.dart';
import 'package:final_project/services/token_service.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/chats/history_thread_chats.dart';
import 'package:final_project/widgets/chat_message_widget.dart';
import 'package:final_project/widgets/dropdown_model_ai.dart';
import 'package:final_project/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainThreadChatPage extends StatefulWidget {
  const MainThreadChatPage({
    super.key,
    this.conversationId,
  });

  final String? conversationId;

  @override
  State<MainThreadChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainThreadChatPage> {
  final TextEditingController _chatController = TextEditingController();
  final FocusNode _conversationNode = FocusNode();
  final ImagePicker _picker = ImagePicker();

  late final String? accessToken;
  int availableTokens = 0;
  late AiAgentModel currentAiAgent;

  List<ChatMetaData> _messages = [];
  String? _conversationId;

  @override
  void initState() {
    super.initState();

    initChatTokens();

    if (widget.conversationId != null && widget.conversationId!.isNotEmpty) {
      _conversationId = widget.conversationId;

      initHistory();
    }

    _conversationNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _conversationNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _conversationNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chat with AI',
          ),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.inverseTextColor,
        ),
        drawer: const TabBarWidget(),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  
                  return ChatMessageWidget(
                    isUser: message.role == "user",
                    content: message.content ?? '',
                    aiAgentThumbnail: message.assistant?.thumbnail ?? 'assets/icon/robot.png',
                  );
                },
              ),
            ),
            const Divider(height: 1.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: DropdownModelAI(
                          onModelSelected: (AiAgentModel aiAgent) {
                            setState(() => currentAiAgent = aiAgent);
                            log('Selected AI Model AI: ${currentAiAgent.id}');
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department_rounded),
                            const SizedBox(width: 4),
                            Text(
                              availableTokens.toString(),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'History',
                            onPressed: () {
                              Utils.showBottomSheet(
                                context,
                                sheet: const HistoryThreadChatPage(),
                                showFullScreen: true,
                              );
                            },
                            icon: const Icon(
                              Icons.access_time_outlined,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          IconButton(
                            tooltip: 'New Conversation',
                            onPressed: () {
                              setState(() {
                                _chatController.clear();
                                _conversationId = null;
                                _messages.clear();
                              });
                            },
                            icon: const Icon(
                              Icons.add_comment,
                              color: AppColors.primaryColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _conversationNode.hasFocus
                            ? AppColors.primaryColor
                            : AppColors.backgroundColor2,
                        width: _conversationNode.hasFocus ? 2.0 : 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            controller: _chatController,
                            focusNode: _conversationNode,
                            minLines: 1,
                            maxLines: 4,
                            expands: false,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Ask me anything',
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(AppRoutes.promptPage),
                                  icon: const Icon(
                                      Icons.settings_suggest_outlined),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.image,
                                    color: AppColors.primaryColor,
                                  ),
                                  onPressed: () async {
                                    // todo: allow upload image from camera
                                    final XFile? pickedFile = await _picker
                                        .pickImage(source: ImageSource.gallery);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: AppColors.primaryColor,
                                  ),
                                  onPressed: () async {
                                    await _sendMessage(_conversationId);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initChatTokens() async {
    availableTokens = await TokenService.getAvailableTokens(context);
    setState(() {});
  }

  Future<void> initHistory() async {
    _messages = await AiChatServices.getConversationHistory(
      context,
      conversationId: widget.conversationId ?? '',
      assistantId: 'gpt-4o',
    );

    setState(() {});
  }

  Future<void> _sendMessage(String? conversationId) async {
    if (_chatController.text.trim().isEmpty || currentAiAgent.id.isEmpty) {
      return;
    }

    final userMessage = ChatMetaData(
      content: _chatController.text.trim(),
      assistant: currentAiAgent,
      role: "user",
    );

    setState(() {
      _messages.insert(0, userMessage);
      _chatController.clear();
    });

    final response = await AiChatServices.sendMessages(
      context,
      content: userMessage.content!,
      aiAgent: currentAiAgent,
      id: conversationId,
      metaDataMessages: _messages,
    );

    if (response != null) {
      setState(() {
        _messages.insert(
          0,
          ChatMetaData(
            role: "model",
            assistant: currentAiAgent,
            content: response.message,
          ),
        );

        availableTokens = response.remainingUsage!;
        _conversationId = response.conversationId!;
      });
    }
  }
}
