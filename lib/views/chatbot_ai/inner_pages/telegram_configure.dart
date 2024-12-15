import 'package:final_project/consts/app_color.dart';
import 'package:final_project/services/ai_assistant_service.dart';
import 'package:final_project/views/chatbot_ai/inner_pages/header_section_widget.dart';
import 'package:final_project/widgets/material_button_custom_widget.dart';
import 'package:flutter/material.dart';

class TelegramConfigurePage extends StatefulWidget {
  const TelegramConfigurePage({super.key});

  @override
  State<TelegramConfigurePage> createState() => _TelegramConfigurePageState();
}

class _TelegramConfigurePageState extends State<TelegramConfigurePage> {
  final TextEditingController tokenCtrl = TextEditingController();

  String? errorText;
  bool isConfiguring = false;

  @override
  void dispose() {
    tokenCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure Telegram Bot'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.inverseTextColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(
                title:
                    'Connect to Telegram Bots and chat with this bot in Telegram App',
                description: 'How to obtain Telegram configurations?',
                urlString:
                    'https://jarvis.cx/help/knowledge-base/publish-bot/telegram',
              ),
              const SizedBox(height: 12),
              _TelegramInformation(
                tokenCtrl: tokenCtrl,
                errorText: errorText,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButtonCustomWidget(
                    onPressed: () => Navigator.of(context).pop(),
                    title: 'Cancel',
                    isApproved: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  isConfiguring
                      ? Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          height: 16,
                          width: 16,
                          child: const CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : MaterialButtonCustomWidget(
                          onPressed: handleConfigure,
                          title: 'Configure',
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validateFields() {
    bool isValid = true;

    if (tokenCtrl.text.trim().isEmpty) {
      errorText = 'Token is required';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  void handleConfigure() async {
    if (validateFields()) {
      setState(() => isConfiguring = true);

      final botToken = tokenCtrl.text.trim();
      final result = await AiAssistantService.verifyTelegramBotConfigure(
        context: context,
        botToken: botToken,
      );

      setState(() => isConfiguring = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: result
              ? const Text('Configuration Saved Successfully')
              : const Text('Verify Telegram Bot Failed'),
          backgroundColor: result ? Colors.green : Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );

      if (result) {
        Navigator.of(context).pop(botToken);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}

class _TelegramInformation extends StatelessWidget {
  const _TelegramInformation({
    required this.tokenCtrl,
    this.errorText,
  });

  final TextEditingController tokenCtrl;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Telegram Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        buildInputField(
          controller: tokenCtrl,
          label: 'Token',
          isRequired: true,
          errorText: errorText,
        ),
      ],
    );
  }
}
