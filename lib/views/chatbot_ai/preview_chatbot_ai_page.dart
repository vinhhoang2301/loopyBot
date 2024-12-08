import 'dart:developer';

import 'package:final_project/consts/app_color.dart';
import 'package:final_project/models/ai_assistant_model.dart';
import 'package:final_project/services/ai_assistant_service.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/chatbot_ai/add_chatbot_ai_page.dart';
import 'package:final_project/views/chatbot_ai/add_kb_chatbot_ai_page.dart';
import 'package:final_project/views/chatbot_ai/develop_chatbot_ai.dart';
import 'package:final_project/views/chatbot_ai/edit_chatbot_ai_page.dart';
import 'package:final_project/views/empty_page.dart';
import 'package:final_project/widgets/dropdown_model_ai.dart';
import 'package:final_project/widgets/text_input_widget.dart';
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
  AiAssistantModel? assistant;

  late final String _assistantId;

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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_outlined),
            onSelected: (value) async {
              switch (value) {
                case 'edit_assistant':
                  editAssistant();
                  break;
                case 'update_instructions':
                  updateInstructions();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit_assistant',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: AppColors.primaryColor),
                    SizedBox(width: 8),
                    Text('Edit Assistant'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'update_instructions',
                child: Row(
                  children: [
                    Icon(Icons.description, color: AppColors.primaryColor),
                    SizedBox(width: 8),
                    Text('Update Instructions'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
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
                                  // Utils.showBottomSheet(
                                  //   context,
                                  //   sheet: const EditChatbotAIPage(),
                                  //   showFullScreen: true,
                                  // );
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

  void editAssistant() async {
    if (assistant == null) {
      log('assistant is null now, can not edit');
      return;
    }

    final result = await Utils.showBottomSheet(
      context,
      sheet: EditChatbotAIPage(
        id: assistant!.id!,
        curAssistantName: assistant?.assistantName,
        curAssistantDescription: assistant?.description,
        curAssistantInstructions: assistant?.instructions,
      ),
      showFullScreen: true,
    );

    if (result) {
      log('update assistant successfully');
    } else {
      log('update assistant failed');
    }
  }

  void updateInstructions() async {
    if (assistant == null) {
      log('assistant is null now, can not update instructions');
      return;
    }

    final TextEditingController instructionCtrl = TextEditingController();

    instructionCtrl.text = assistant?.instructions ?? '';
    bool isLoading = false;

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _UpdateInstructionsSheet(
        instructionCtrl: instructionCtrl,
        assistant: assistant!,
      ),
    );

    if (result == true) {
      fetchAssistant();
      log('update instructions successfully');
    } else {
      log('update instructions failed');
    }
  }
}

class _UpdateInstructionsSheet extends StatefulWidget {
  final TextEditingController instructionCtrl;
  final AiAssistantModel assistant;

  const _UpdateInstructionsSheet({
    required this.instructionCtrl,
    required this.assistant,
  });

  @override
  State<_UpdateInstructionsSheet> createState() =>
      _UpdateInstructionsSheetState();
}

class _UpdateInstructionsSheetState extends State<_UpdateInstructionsSheet> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Update Instructions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(controller: widget.instructionCtrl),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed:
                    isLoading ? null : () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                ),
                onPressed: isLoading ? null : _handleUpdate,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Update'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _handleUpdate() async {
    setState(() => isLoading = true);
    try {
      await AiAssistantService.updateAssistant(
        context: context,
        id: widget.assistant.id!,
        assistantName: widget.assistant.assistantName!,
        assistantDes: widget.assistant.description,
        assistantIns: widget.instructionCtrl.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Instructions updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update instructions: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context, false);
      }
    }
    setState(() => isLoading = false);
  }
}
