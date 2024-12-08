import 'package:final_project/consts/app_color.dart';
import 'package:final_project/services/ai_assistant_service.dart';
import 'package:final_project/widgets/material_button_custom_widget.dart';
import 'package:final_project/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';

class EditChatbotAIPage extends StatefulWidget {
  const EditChatbotAIPage({
    super.key,
    required this.id,
    required this.curAssistantName,
    required this.curAssistantDescription,
    required this.curAssistantInstructions,
  });

  final String id;
  final String? curAssistantName;
  final String? curAssistantDescription;
  final String? curAssistantInstructions;

  @override
  State<EditChatbotAIPage> createState() => _EditChatbotAIPageState();
}

class _EditChatbotAIPageState extends State<EditChatbotAIPage> {
  late final String _id;

  final TextEditingController chatbotNameCtrl = TextEditingController();
  final TextEditingController chatbotDesCtrl = TextEditingController();
  final TextEditingController chatbotInsCtrl = TextEditingController();

  bool _isLoading = false;
  bool _emptyName = false;

  @override
  void initState() {
    _id = widget.id;

    chatbotNameCtrl.text = widget.curAssistantName ?? '';
    chatbotDesCtrl.text = widget.curAssistantDescription ?? '';
    chatbotInsCtrl.text = widget.curAssistantInstructions ?? '';

    super.initState();
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
                'Update Chatbot AI',
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
          if (_emptyName) ...[
            const SizedBox(height: 4),
            const Text(
              'Name must be not empty',
              style: TextStyle(color: Colors.red),
            ),
          ],
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
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : updateAssistant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
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
          ),
        ],
      ),
    );
  }

  Future<void> updateAssistant() async {
    if (chatbotNameCtrl.text.trim().isEmpty) {
      setState(() {
        _emptyName = true;
      });
    } else {
      setState(() {
        _emptyName = false;
        _isLoading = true;
      });

      final result = await AiAssistantService.updateAssistant(
        context: context,
        id: _id,
        assistantName: chatbotNameCtrl.text.trim(),
        assistantDes: chatbotDesCtrl.text.trim(),
        assistantIns: chatbotInsCtrl.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result
                  ? 'AI Assistant updated successfully!'
                  : 'AI Assistant updated failed',
            ),
            backgroundColor: result ? Colors.green : Colors.red,
          ),
        );
        Navigator.pop(context, true);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
