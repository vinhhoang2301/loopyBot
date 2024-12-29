import 'dart:developer';
import 'package:final_project/consts/app_color.dart';
import 'package:final_project/models/ai_agent_model.dart';
import 'package:final_project/models/ai_assistant_model.dart';
import 'package:final_project/models/chat_metadata.dart';
import 'package:final_project/models/prompt_model.dart';
import 'package:final_project/services/ai_assistant_service.dart';
import 'package:final_project/services/ai_chat_service.dart';
import 'package:final_project/services/authen_service.dart';
import 'package:final_project/services/kb_authen_service.dart';
import 'package:final_project/services/prompt_service.dart';
import 'package:final_project/services/token_service.dart';
import 'package:final_project/utils/ad_helper.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/chats/history_thread_chats.dart';
import 'package:final_project/widgets/chat_message_widget.dart';
import 'package:final_project/widgets/dropdown_model_ai.dart';
import 'package:final_project/widgets/tab_bar_widget.dart';
import 'package:final_project/widgets/typing_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:final_project/views/prompt/prompt_library.dart';
import 'package:final_project/views/email/write_email.dart';
// import 'package:camera/camera.dart';

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
  dynamic currentAiAgent;

  List<ChatMetaData> _messages = [];
  List<PromptModel> _promptHints = [];
  List<AiAssistantModel>? aiAssistants = [];
  String? _conversationId;
  int availableTokens = 0;
  bool isLoading = false;
  bool isTyping = false;
  BannerAd? bannerAd;

  // CameraController? _cameraController;
  // XFile? _imageFile;

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });

    if (widget.initialPromptContent != null) {
      _chatController.text = widget.initialPromptContent!;
    }

    initChatTokens();
    _createBannerAd();

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

    kbSignIn();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _conversationNode.dispose();
    _chatController.dispose();
    // _cameraController?.dispose();
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
      final prompts = await PromptService().fetchPromptsByPartialTitle(context, query);
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
  void _navigateToWriteEmail() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WriteEmailPage()),
    );
  }
  Future<void> _onPromptHintSelected(PromptModel prompt) async {
    setState(() {
      _chatController.text = prompt.content;
      _promptHints.clear();
    });
  }

  // Future<void> _initializeCamera() async {
  //   try {
  //     final cameras = await availableCameras();
  //     final firstCamera = cameras.first;

  //     _cameraController = CameraController(
  //       firstCamera,
  //       ResolutionPreset.high,
  //     );

  //     await _cameraController?.initialize();
  //   } catch (e) {
  //     print('Error initializing camera: $e');
  //   }
  // }

  // Future<void> _takePicture() async {
  //   if (_cameraController == null || !_cameraController!.value.isInitialized) {
  //     return;
  //   }

  //   if (_cameraController!.value.isTakingPicture) {
  //     return;
  //   }

  //   try {
  //     final image = await _cameraController!.takePicture();
  //     setState(() {
  //       _imageFile = image;
  //     });
  //     await _sendMessage(_conversationId, _imageFile);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

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
              icon: Image.asset(
                'assets/icon/prompt.png',
                color: AppColors.inverseTextColor,
                height: 28,
                width: 28,
              ),
              onPressed: _navigateToPromptLibrary,
            ),
            IconButton(
              icon: Icon(
                Icons.mail,
                color: AppColors.inverseTextColor,
              ),
              onPressed: _navigateToWriteEmail,
            ),
          ],
        ),
        drawer: const TabBarWidget(),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ListView.builder(
                          reverse: true,
                          itemCount: _messages.length + (isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (isTyping && index == 0) {
                              return TypingIndicatorWidget(
                                aiAgentThumbnail: currentAiAgent is AiAgentModel ? currentAiAgent.thumbnail : 'assets/icon/chatbot.png',
                              );
                            }

                            final messageIndex = isTyping ? index - 1 : index;
                            if (messageIndex >= 0 && messageIndex < _messages.length) {
                              final message = _messages[messageIndex];
                              return ChatMessageWidget(
                                isUser: message.role == "user",
                                content: message.content ?? '',
                                aiAgentThumbnail: message.assistant?.thumbnail ?? 'assets/icon/robot.png',
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                        if (bannerAd != null)
                          Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: bannerAd!.size.width.toDouble(),
                              height: bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: bannerAd!),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
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
                              child: FutureBuilder<List<AiAssistantModel>?>(
                                future: formatAssistantToAiAgent(),
                                builder: (context, snapshot) {
                                  // if (snapshot.connectionState == ConnectionState.waiting) {
                                  //   return const SizedBox(
                                  //     width: 4,
                                  //     height: 4,
                                  //     child: CircularProgressIndicator(),
                                  //   );
                                  // } else
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return DropdownModelAI(
                                      currentModel: currentAiAgent,
                                      personalAssistant: const [],
                                      onModelSelected: (dynamic aiAgent) {
                                        setState(() => currentAiAgent = aiAgent);
                                      },
                                    );
                                  } else {
                                    return DropdownModelAI(
                                      currentModel: currentAiAgent,
                                      personalAssistant: snapshot.data!,
                                      onModelSelected: (dynamic aiAgent) {
                                        setState(() => currentAiAgent = aiAgent);
                                        log('in here');
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
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
                              color: _conversationNode.hasFocus ? AppColors.primaryColor : AppColors.backgroundColor2,
                              width: _conversationNode.hasFocus ? 2.0 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                      icon: const Icon(
                                        Icons.image,
                                        color: AppColors.primaryColor,
                                      ),
                                      onPressed: () async {
                                        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                                        if (pickedFile != null) {
                                          await _sendMessage(_conversationId, pickedFile);
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.camera_alt,
                                        color: AppColors.primaryColor,
                                      ),
                                      onPressed: () async {
                                        // await _initializeCamera();
                                        // await _takePicture();
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

  void _createBannerAd() {
    AdHelper.createBannerAd(
      size: const AdSize(width: 400, height: 60),
      onAdLoaded: (ad) {
        setState(() => bannerAd = ad);
      },
      onAdFailedToLoad: (error) {
        log('Failed to load a banner ad in Update Account: $error');
      },
    );
  }

  Future<void> initChatTokens() async {
    availableTokens = await TokenService.getAvailableTokens(context);
    setState(() {});
  }

  Future<void> initHistory() async {
    try {
      final result = await AiChatServices.getConversationHistory(
        context,
        conversationId: widget.conversationId ?? '',
        assistantId: 'gpt-4o',
      );

      if (result != null) {
        _messages = result;
      }
    } catch (e) {
      log('Error loading history chat: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load chat history'),
          ),
        );
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
      if (currentAiAgent is AiAssistantModel) {
        userMessage = ChatMetaData(
          content: _chatController.text.trim(),
          assistant: AiAgentModel(
            id: (currentAiAgent as AiAssistantModel).openAiThreadIdPlay.toString(),
            name: (currentAiAgent as AiAssistantModel).assistantName.toString(),
            thumbnail: 'assets/icon/chatbot.png',
          ),
          role: "user",
        );
      } else {
        userMessage = ChatMetaData(
          content: _chatController.text.trim(),
          assistant: currentAiAgent,
          role: "user",
        );
      }
    }

    setState(() {
      _messages.insert(0, userMessage);
      if (pickedFile == null) {
        _chatController.clear();
      }
      isTyping = true;
    });

    try {
      if(currentAiAgent is AiAgentModel) {
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
      } else if(currentAiAgent is AiAssistantModel) {
        final response = await AiAssistantService.askAssistant(
          context: context,
          assistantId: (currentAiAgent as AiAssistantModel).id.toString(),
          msg: userMessage.content!,
          openAiThreadId: (currentAiAgent as AiAssistantModel).openAiThreadIdPlay.toString(),
        );

        log('response: ${response.toString()}');

        if (response != null) {
          setState(() {
            isTyping = false;
            _messages.insert(
              0,
              ChatMetaData(
                role: "model",
                assistant: AiAgentModel(
                  id: (currentAiAgent as AiAssistantModel).openAiThreadIdPlay.toString(),
                  name: (currentAiAgent as AiAssistantModel).assistantName.toString(),
                  thumbnail: 'assets/icon/chatbot.png',
                ),
                content: response,
              ),
            );
          });
        }
      }
    } catch (err) {
      setState(() => isTyping = false);
    }
  }

  Future<void> kbSignIn() async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    if (mounted) {
      if (accessToken != null) {
        await KBAuthService.signInFromExternalClient(
          context,
          accessToken: accessToken,
        );
      }

      fetchAiAssistants();
    }
  }

  Future<void> fetchAiAssistants() async {
    final assistants = await AiAssistantService.getAllAssistants(context: context);
    setState(() {
      aiAssistants = assistants;
    });
  }

  Future<List<AiAssistantModel>?> formatAssistantToAiAgent() async {
    if (aiAssistants == null || aiAssistants!.isEmpty) return [];
    return aiAssistants;
  }
}
