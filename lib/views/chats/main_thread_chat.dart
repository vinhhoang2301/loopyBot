import 'dart:developer';

import 'package:final_project/consts/app_color.dart';
import 'package:final_project/consts/app_routes.dart';
import 'package:final_project/models/chat_response_model.dart';
import 'package:final_project/services/ai_chat_service.dart';
import 'package:final_project/services/token_service.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/chats/history_thread_chats.dart';
import 'package:final_project/widgets/dropdown_model_ai.dart';
import 'package:final_project/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainThreadChatPage extends StatefulWidget {
  const MainThreadChatPage({super.key});

  @override
  State<MainThreadChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainThreadChatPage> {
  final List<ChatResponseModel> messages = [];
  final TextEditingController _chatController = TextEditingController();
  final FocusNode _conversationNode = FocusNode();
  final ImagePicker _picker = ImagePicker();

  late final String? accessToken;
  late int totalTokens = -1;
  late int availableTokens = -1;

  String modelId = '';

  @override
  void initState() {
    _conversationNode.addListener(() {
      setState(() {});
    });

    initChatTokens();

    super.initState();
  }

  @override
  void dispose() {
    _conversationNode.dispose();
    super.dispose();
  }

  void initChatTokens() async {
    totalTokens = await getTotalTokens();
    availableTokens = await getAvailableTokens();
  }

  Future<int> getTotalTokens() async {
    return await TokenService.getTotalToken(context);
  }

  Future<int> getAvailableTokens() async {
    return await TokenService.getAvailableTokens(context);
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
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    child: Align(
                      alignment: message.remainingUsage == -1 ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: message.remainingUsage == -1 ? Colors.blueAccent.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          message.message,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
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
                          onModelSelected: (String id) {
                            setState(() => modelId = id);
                            log('Selected AI Model AI: $modelId');
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
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
                              // todo: create new conversation
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
                        color: _conversationNode.hasFocus ? AppColors.primaryColor : AppColors.backgroundColor2,
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
                                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.promptPage),
                                  icon: const Icon(Icons.settings_suggest_outlined),
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
                                    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: AppColors.primaryColor,
                                  ),
                                  onPressed: () async {
                                    await _sendMessage();
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

  Future<void> _sendMessage() async {
    if (_chatController.text.trim().isEmpty || modelId.isEmpty) return;

    final userMessage = ChatResponseModel(
      message: _chatController.text.trim(),
      conversationId: '',
      remainingUsage: -1,
    );

    setState(() {
      messages.insert(0, userMessage);
      _chatController.clear();
    });

    final response = await AiChatServices.doAiChat(
      context,
      modelId: modelId,
      msg: userMessage.message,
    );

    if (response != null) {
      setState(() {
        messages.insert(0, response);
        availableTokens = response.remainingUsage;
      });
    }
  }
}
