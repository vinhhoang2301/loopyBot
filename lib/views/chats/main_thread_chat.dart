import 'dart:developer';
import 'package:final_project/consts/app_color.dart';
import 'package:final_project/models/ai_agent_model.dart';
import 'package:final_project/models/chat_metadata.dart';
import 'package:final_project/models/prompt_model.dart';
import 'package:final_project/services/ai_chat_service.dart';
import 'package:final_project/services/prompt_service.dart';
import 'package:final_project/services/token_service.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/chats/history_thread_chats.dart';
import 'package:final_project/widgets/chat_message_widget.dart';
import 'package:final_project/widgets/dropdown_model_ai.dart';
import 'package:final_project/widgets/tab_bar_widget.dart';
import 'package:final_project/widgets/typing_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:final_project/views/prompt/prompt_library.dart';

class MainThreadChatPage extends StatefulWidget {
  const MainThreadChatPage({
    super.key,
    this.conversationId,
    this.initialPromptContent,
  });

  final String? conversationId;
  final String? initialPromptContent;

  @override
  State<MainThreadChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainThreadChatPage> {
  final TextEditingController _chatController = TextEditingController();
  final FocusNode _conversationNode = FocusNode();
  final ImagePicker _picker = ImagePicker();

  late final String? accessToken;
  late AiAgentModel currentAiAgent;

  List<ChatMetaData> _messages = [];
  List<PromptModel> _promptHints = [];
  String? _conversationId;
  int availableTokens = 0;
  bool isLoading = false;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialPromptContent != null) {
      _chatController.text = widget.initialPromptContent!;
    }

    initChatTokens();

    if (widget.conversationId != null && widget.conversationId!.isNotEmpty) {
      _conversationId = widget.conversationId;
      initHistory();
    }

    _conversationNode.addListener(() {
      setState(() {});
    });

    _chatController.addListener(_onChatTextChanged);

    currentAiAgent = const AiAgentModel(
      id: 'gpt-4o-mini',
      name: 'GPT-4o mini',
      thumbnail: 'assets/icon/gpt_4o_mini.png',
    );
  }

  @override
  void dispose() {
    _conversationNode.dispose();
    _chatController.dispose();
    super.dispose();
  }

  void _onChatTextChanged() {
    final text = _chatController.text;
    if (text.startsWith('/')) {
      final query = text.substring(1);
      if (query.isNotEmpty) {
        _fetchPromptHints(query);
      } else {
        setState(() {
          _promptHints.clear();
        });
      }
    } else {
      setState(() {
        _promptHints.clear();
      });
    }
  }

  Future<void> _fetchPromptHints(String query) async {
    try {
      final prompts =
          await PromptService().fetchPromptsByPartialTitle(context, query);
      setState(() {
        _promptHints = prompts;
      });
    } catch (e) {
      log('Error fetching prompt hints: $e');
    }
  }

  Future<void> _navigateToPromptLibrary() async {
    final selectedPrompt = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PromptLibrary(),
      ),
    );

    if (selectedPrompt != null && selectedPrompt is String) {
      setState(() {
        _chatController.text += '\n$selectedPrompt';
      });
    }
  }

  Future<void> _onPromptHintSelected(PromptModel prompt) async {
    setState(() {
      _chatController.text = prompt.content;
      _promptHints.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _conversationNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat with AI'),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.inverseTextColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.library_books),
              onPressed: _navigateToPromptLibrary,
            ),
          ],
        ),
        drawer: const TabBarWidget(),
        body: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      reverse: true,
                      itemCount: _messages.length + (isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final messageIndex = isTyping ? index - 1 : index;

                        if (isTyping && index == 0) {
                          return TypingIndicatorWidget(
                            aiAgentThumbnail: message.assistant?.thumbnail,
                          );
                        }

                        if (messageIndex >= 0 && messageIndex < _messages.length) {
                          final message = _messages[messageIndex];
                          return ChatMessageWidget(
                            isUser: message.role == "user",
                            content: message.content ?? '',
                            aiAgentThumbnail: message.assistant?.thumbnail ??
                                'assets/icon/robot.png',
                          );
                        }

                        return const SizedBox.shrink(); 
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              controller: _chatController,
                              focusNode: _conversationNode,
                              onChanged: (_) {
                                _onChatTextChanged();
                              },
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
                          if (_promptHints.isNotEmpty)
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount: _promptHints.length,
                                itemBuilder: (context, index) {
                                  final prompt = _promptHints[index];
                                  return ListTile(
                                    title: Text(prompt.title),
                                    onTap: () => _onPromptHintSelected(prompt),
                                  );
                                },
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.image,
                                    color: AppColors.primaryColor),
                                onPressed: () async {
                                  final XFile? pickedFile = await _picker
                                      .pickImage(source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    await _sendMessage(_conversationId, pickedFile);
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.send,
                                    color: AppColors.primaryColor),
                                onPressed: () async {
                                  await _sendMessage(_conversationId);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
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
    setState(() => isLoading = true);

    try {
      _messages = await AiChatServices.getConversationHistory(
        context,
        conversationId: widget.conversationId ?? '',
        assistantId: 'gpt-4o',
      );
    } catch (e) {
      log('Error loading history chat: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load chat history'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _sendMessage(String? conversationId, [XFile? pickedFile]) async {
    if ((pickedFile == null && _chatController.text.trim().isEmpty) || currentAiAgent.id.isEmpty) {
      return;
    }

    ChatMetaData userMessage;
    if (pickedFile != null) {
      userMessage = ChatMetaData(
        content: 'Image: ${pickedFile.path}',
        assistant: currentAiAgent,
        role: "user",
      );
    } else {
      userMessage = ChatMetaData(
        content: _chatController.text.trim(),
        assistant: currentAiAgent,
        role: "user",
      );
    }

    setState(() {
      _messages.insert(0, userMessage);
      if (pickedFile == null) {
        _chatController.clear();
      }
      isTyping = true;
    });

    try {
      final response = await AiChatServices.sendMessages(
        context,
        content: userMessage.content!,
        aiAgent: currentAiAgent,
        id: conversationId,
        metaDataMessages: _messages,
      );
      if (response != null) {
        setState(() {
          isTyping = false;
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
    } catch (err) {
      setState(() => isTyping = false);
    }
  }
}
