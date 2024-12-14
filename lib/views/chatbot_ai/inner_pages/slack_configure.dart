import 'dart:developer';

import 'package:final_project/consts/app_color.dart';
import 'package:final_project/views/chatbot_ai/inner_pages/header_section_widget.dart';
import 'package:final_project/widgets/copy_link_section_widget.dart';
import 'package:final_project/widgets/material_button_custom_widget.dart';
import 'package:flutter/material.dart';

class SlackConfigurePage extends StatefulWidget {
  const SlackConfigurePage({super.key});

  @override
  State<SlackConfigurePage> createState() => _SlackConfigurePageState();
}

class _SlackConfigurePageState extends State<SlackConfigurePage> {
  final TextEditingController tokenCtrl = TextEditingController();
  final TextEditingController clientIdCtrl = TextEditingController();
  final TextEditingController clientSecretCtrl = TextEditingController();
  final TextEditingController signSecretCtrl = TextEditingController();

  Map<String, String?> fieldErrors = {
    'token': null,
    'clientId': null,
    'clientSecret': null,
    'signSecret': null,
  };

  @override
  void dispose() {
    tokenCtrl.dispose();
    clientIdCtrl.dispose();
    clientSecretCtrl.dispose();
    signSecretCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure Slack Bot'),
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
                title: 'Connect to Slack Bots and chat with this bot in Slack App',
                description: 'How to obtain Slack configurations?',
                urlString: 'https://jarvis.cx/help/knowledge-base/publish-bot/slack',
              ),
              const SizedBox(height: 12),
              const _SlackCopyLinkSection(),
              const SizedBox(height: 12),
              _SlackInformation(
                tokenCtrl: tokenCtrl,
                clientIdCtrl: clientIdCtrl,
                clientSecretCtrl: clientSecretCtrl,
                signSecretCtrl: signSecretCtrl,
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
      'clientId': null,
      'clientSecret': null,
      'signSecret': null,
    };

    if (tokenCtrl.text.trim().isEmpty) {
      fieldErrors['token'] = 'Token is required';
      isValid = false;
    }

    if (clientIdCtrl.text.trim().isEmpty) {
      fieldErrors['clientId'] = 'Client ID is required';
      isValid = false;
    }

    if (clientSecretCtrl.text.trim().isEmpty) {
      fieldErrors['clientSecret'] = 'Client Secret is required';
      isValid = false;
    }

    if (signSecretCtrl.text.trim().isEmpty) {
      fieldErrors['signSecret'] = 'Signing Secret is required';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  void handleConfigure() {
    if (validateFields()) {
      final slackConfig = {
        'token': tokenCtrl.text.trim(),
        'clientId': clientIdCtrl.text.trim(),
        'clientSecret': clientSecretCtrl.text.trim(),
        'signingSecret': signSecretCtrl.text.trim(),
      };

      log('Slack Configuration: $slackConfig');

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

class _SlackCopyLinkSection extends StatelessWidget {
  const _SlackCopyLinkSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. Slack Copy Link',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Copy the following content to your Slack app configuration page.',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 16),
        CopyLinkSection(
          title: 'OAuth2 Redirect URLs',
          url:
              'https://knowledge-api.jarvis.cx/kb-core/v1/bot-integration/slack/auth/00637faf-16ee-4533-9b88-6d030e22098f',
        ),
        SizedBox(height: 16),
        CopyLinkSection(
          title: 'Event Request URL',
          url:
              'https://knowledge-api.jarvis.cx/kb-core/v1/hook/slack/00637faf-16ee-4533-9b88-6d030e22098f',
        ),
        SizedBox(height: 16),
        CopyLinkSection(
          title: 'Slash Request URL',
          url:
              'https://knowledge-api.jarvis.cx/kb-core/v1/hook/slack/slash/00637faf-16ee-4533-9b88-6d030e22098f',
        ),
      ],
    );
  }
}

class _SlackInformation extends StatelessWidget {
  const _SlackInformation({
    required this.tokenCtrl,
    required this.clientIdCtrl,
    required this.clientSecretCtrl,
    required this.signSecretCtrl,
    required this.fieldErrors,
  });

  final TextEditingController tokenCtrl;
  final TextEditingController clientIdCtrl;
  final TextEditingController clientSecretCtrl;
  final TextEditingController signSecretCtrl;
  final Map<String, String?> fieldErrors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Slack Information',
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
          errorText: fieldErrors['token'],
        ),
        const SizedBox(height: 12),
        buildInputField(
          controller: clientIdCtrl,
          label: 'Client ID',
          isRequired: true,
          errorText: fieldErrors['clientId'],
        ),
        const SizedBox(height: 12),
        buildInputField(
          controller: clientSecretCtrl,
          label: 'Client Secret',
          isRequired: true,
          errorText: fieldErrors['clientSecret'],
        ),
        const SizedBox(height: 12),
        buildInputField(
          controller: signSecretCtrl,
          label: 'Signing Secret',
          isRequired: true,
          errorText: fieldErrors['signSecret'],
        ),
      ],
    );
  }
}
