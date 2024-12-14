import 'package:final_project/consts/app_color.dart';
import 'package:final_project/views/chatbot_ai/inner_pages/header_section_widget.dart';
import 'package:final_project/widgets/copy_link_section_widget.dart';
import 'package:final_project/widgets/material_button_custom_widget.dart';
import 'package:flutter/material.dart';

class MessengerConfigurePage extends StatefulWidget {
  const MessengerConfigurePage({super.key});

  @override
  State<MessengerConfigurePage> createState() => _MessengerConfigurePageState();
}

class _MessengerConfigurePageState extends State<MessengerConfigurePage> {
  final TextEditingController botTokenCtrl = TextEditingController();
  final TextEditingController botPageIdCtrl = TextEditingController();
  final TextEditingController botAppSecretCtrl = TextEditingController();

  Map<String, String?> fieldErrors = {
    'token': null,
    'botPageId': null,
    'botAppSecret': null,
  };

  @override
  void dispose() {
    botTokenCtrl.dispose();
    botPageIdCtrl.dispose();
    botAppSecretCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure Messenger Bot'),
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
                    'Connect to Messenger Bots and chat with this bot in Messenger App',
                description: 'How to obtain Messenger configurations?',
                urlString:
                    'https://jarvis.cx/help/knowledge-base/publish-bot/messenger',
              ),
              const SizedBox(height: 12),
              const _MessengerCopyLinkSection(),
              const SizedBox(height: 12),
              _MessengerInformation(
                botTokenCtrl: botTokenCtrl,
                botPageID: botPageIdCtrl,
                botAppSecretCtrl: botAppSecretCtrl,
                fieldErrors: fieldErrors,
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
                  MaterialButtonCustomWidget(
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

    fieldErrors = {
      'token': null,
      'botPageId': null,
      'botAppSecret': null,
    };

    if (botTokenCtrl.text.trim().isEmpty) {
      fieldErrors['token'] = 'Bot Token is required';
      isValid = false;
    }

    if (botPageIdCtrl.text.trim().isEmpty) {
      fieldErrors['botPageId'] = 'Bot Page ID is required';
      isValid = false;
    }

    if (botAppSecretCtrl.text.trim().isEmpty) {
      fieldErrors['botAppSecret'] = 'Bot App Secret is required';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  void handleConfigure() {
    if (validateFields()) {
      // final slackConfig = {
      //   'token': tokenCtrl.text.trim(),
      //   'clientId': clientIdCtrl.text.trim(),
      //   'clientSecret': clientSecretCtrl.text.trim(),
      //   'signingSecret': signSecretCtrl.text.trim(),
      // };
      
      // print('Slack Configuration: $slackConfig');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuration saved successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );

      Navigator.of(context).pop();
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

class _MessengerCopyLinkSection extends StatelessWidget {
  const _MessengerCopyLinkSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. Messenger Copy Link',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Copy the following content to your Messenger app configuration page.',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 16),
        CopyLinkSection(
          title: 'Callback URL',
          url:
              'https://knowledge-api.jarvis.cx/kb-core/v1/bot-integration/slack/auth/00637faf-16ee-4533-9b88-6d030e22098f',
        ),
        SizedBox(height: 16),
        CopyLinkSection(
          title: 'Verify Token',
          url: 'knowledge',
        ),
      ],
    );
  }
}

class _MessengerInformation extends StatelessWidget {
  const _MessengerInformation({
    required this.botTokenCtrl,
    required this.botPageID,
    required this.botAppSecretCtrl,
    required this.fieldErrors,
  });

  final TextEditingController botTokenCtrl;
  final TextEditingController botPageID;
  final TextEditingController botAppSecretCtrl;
  final Map<String, String?> fieldErrors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Messenger Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        buildInputField(
          controller: botTokenCtrl,
          label: 'Messenger Bot Token',
          isRequired: true,
          errorText: fieldErrors['token'],
        ),
        const SizedBox(height: 12),
        buildInputField(
          controller: botPageID,
          label: 'Messenger Bot Page ID',
          isRequired: true,
          errorText: fieldErrors['botPageId'],
        ),
        const SizedBox(height: 12),
        buildInputField(
          controller: botAppSecretCtrl,
          label: 'Messenger Bot App Secret',
          isRequired: true,
          errorText: fieldErrors['botAppSecret'],
        ),
      ],
    );
  }
}
