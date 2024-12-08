import 'dart:developer';

import 'package:final_project/consts/app_color.dart';
import 'package:final_project/services/ai_assistant_service.dart';
import 'package:final_project/widgets/material_button_custom_widget.dart';
import 'package:final_project/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';

class AddChatbotAIPage extends StatefulWidget {
  const AddChatbotAIPage({super.key});

  @override
  State<AddChatbotAIPage> createState() => _AddChatbotAIPageState();
}

class _AddChatbotAIPageState extends State<AddChatbotAIPage> {
  final TextEditingController chatbotNameCtrl = TextEditingController();
  final TextEditingController chatbotDesCtrl = TextEditingController();
  final TextEditingController chatbotInsCtrl = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    chatbotNameCtrl.dispose();
    chatbotDesCtrl.dispose();
    chatbotInsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                'Create Chatbot AI',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          RichText(
            text: const TextSpan(
              text: '* ',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'Chatbot AI Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: chatbotNameCtrl,
            hintText: 'Chatbot AI 001',
          ),
          const SizedBox(height: 20),
          const Text(
            'Chatbot AI Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: chatbotDesCtrl,
            hintText: 'Enter your description',
          ),
          const SizedBox(height: 20),
          const Text(
            'Chatbot AI Instructions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: chatbotInsCtrl,
            hintText: 'Enter your instructions',
          ),
          const SizedBox(height: 20),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: isLoading ? null : createAiAssistant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                  ),
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
                      : const Text('Create'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void createAiAssistant() async {
    if (isLoading) return;

    try {
      setState(() {
        isLoading = true;
      });

      var result = await AiAssistantService.createAssistant(
        context: context,
        assistantName: chatbotNameCtrl.text.trim(),
        description: chatbotDesCtrl.text.trim(),
        instructions: chatbotInsCtrl.text.trim(),
      );

      chatbotNameCtrl.clear();
      chatbotDesCtrl.clear();
      chatbotInsCtrl.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result != null
                  ? 'AI Assistant created successfully!'
                  : 'AI Assistant created failed',
            ),
            backgroundColor: result != null ? Colors.green : Colors.red,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (err) {
      log('Error when submitting create Chatbot AI: ${err.toString()}');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
}
