import 'package:final_project/consts/app_color.dart';
import 'package:final_project/models/ai_assistant_model.dart';
import 'package:final_project/services/ai_assistant_service.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/chatbot_ai/add_kb_chatbot_ai_page.dart';
import 'package:final_project/views/chatbot_ai/develop_chatbot_ai.dart';
import 'package:final_project/views/chatbot_ai/edit_chatbot_ai_page.dart';
import 'package:final_project/views/empty_page.dart';
import 'package:final_project/widgets/dropdown_model_ai.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PreviewChatbot extends StatefulWidget {
  const PreviewChatbot({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<PreviewChatbot> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<PreviewChatbot> {
  final List<String> messages = [
    'hehe',
    'hihi',
  ];
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  late final String _assistantId;
  AiAssistantModel? assistant;

  @override
  void initState() {
    _assistantId = widget.id;
    fetchAssistant();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          assistant != null ? assistant!.assistantName! : '...',
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.inverseTextColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_outlined),
          ),
        ],
      ),
      body: assistant != null
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              messages[messages.length - 1 - index],
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
                          const Flexible(child: DropdownModelAI()),
                          Row(
                            children: [
                              IconButton(
                                tooltip: 'Edit',
                                onPressed: () {
                                  Utils.showBottomSheet(
                                    context,
                                    sheet: const EditChatbotAIPage(),
                                    showFullScreen: true,
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Develop',
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const DevelopChatbotAI();
                                      },
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.developer_board,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Add KB',
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const AddKBToChatbot();
                                      },
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.book,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.backgroundColor2,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextField(
                                controller: _controller,
                                minLines: 1,
                                maxLines: 4,
                                expands: false,
                                onSubmitted: (value) {},
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ask me anything',
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
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
                                        final XFile? pickedFile =
                                            await _picker.pickImage(
                                                source: ImageSource.gallery);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.send,
                                        color: AppColors.primaryColor,
                                      ),
                                      onPressed: () {},
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
            )
          : _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Center(
                  child:
                      EmptyPage(content: 'Failed to Get AI Assistant Chatbot'),
                ),
    );
  }

  Future<void> fetchAssistant() async {
    try {
      setState(() => _isLoading = true);

      final result = await AiAssistantService.getAssistant(
        context: context,
        id: _assistantId,
      );

      setState(() {
        assistant = result;
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        assistant = null;
        _isLoading = false;
      });
    }
  }
}
