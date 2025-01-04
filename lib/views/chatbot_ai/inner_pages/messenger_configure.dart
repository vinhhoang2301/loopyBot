import 'package:final_project/consts/api.dart';
import 'package:final_project/consts/app_color.dart';
import 'package:final_project/services/ai_assistant_service.dart';
import 'package:final_project/views/chatbot_ai/inner_pages/header_section_widget.dart';
import 'package:final_project/widgets/copy_link_section_widget.dart';
import 'package:final_project/widgets/material_button_custom_widget.dart';
import 'package:flutter/material.dart';

class MessengerConfigurePage extends StatefulWidget {
  const MessengerConfigurePage({
    super.key,
    required this.assistantId,
    required this.configurations,
  });

  final String assistantId;
  final Map<String, dynamic> configurations;

  @override
  State<MessengerConfigurePage> createState() => _MessengerConfigurePageState();
}

class _MessengerConfigurePageState extends State<MessengerConfigurePage> {
  late final bool hasConfigurations;

  final TextEditingController botTokenCtrl = TextEditingController();
  final TextEditingController botPageIdCtrl = TextEditingController();
  final TextEditingController botAppSecretCtrl = TextEditingController();

  bool isConfiguring = false;
  Map<String, String?> fieldErrors = {
    'token': null,
    'botPageId': null,
    'botAppSecret': null,
  };

  @override
  void initState() {
    botTokenCtrl.text = widget.configurations['botToken'] ?? '';
    botPageIdCtrl.text = widget.configurations['pageId'] ?? '';
    botAppSecretCtrl.text = widget.configurations['appSecret'] ?? '';

    hasConfigurations = botTokenCtrl.text.isNotEmpty;
    super.initState();
  }

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
              _MessengerCopyLinkSection(widget.assistantId),
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
                  isConfiguring
                      ? Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: hasConfigurations
                                ? Colors.red
                                : AppColors.primaryColor,
                          ),
                        )
                      : hasConfigurations
                          ? MaterialButtonCustomWidget(
                              onPressed: handleDisconnect,
                              title: 'Disconnect',
                              isDenied: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 12.0,
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

  void handleConfigure() async {
    if (validateFields()) {
      setState(() => isConfiguring = true);
      final messengerConfig = {
        'botToken': botTokenCtrl.text.trim(),
        'pageId': botPageIdCtrl.text.trim(),
        'appSecret': botAppSecretCtrl.text.trim(),
      };

      final result = await AiAssistantService.verifyMessengerBotConfigure(
        context: context,
        botToken: messengerConfig['botToken'].toString(),
        pageId: messengerConfig['pageId'].toString(),
        appSecret: messengerConfig['appSecret'].toString(),
      );

      setState(() => isConfiguring = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: result
              ? const Text('Configuration Saved Successfully')
              : const Text('Verify Messenger Bot Failed'),
          backgroundColor: result ? Colors.green : Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );

      if (result) {
        Navigator.of(context).pop(messengerConfig);
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

  void handleDisconnect() async {
    setState(() => isConfiguring = true);
    final messengerConfig = <String, dynamic>{
      'botToken': null,
      'pageId': null,
      'appSecret': null,
    };

    final result = await AiAssistantService.disconnectBotIntegration(
      context: context,
      assistantId: widget.assistantId,
      botType: 'messenger',
    );

    setState(() => isConfiguring = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: result
            ? const Text('Disconnect Bot Integration Successfully')
            : const Text('Disconnect Bot Integration Failed'),
        backgroundColor: result ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );

    if (result) {
      Navigator.of(context).pop(messengerConfig);
    }
  }
}

class _MessengerCopyLinkSection extends StatelessWidget {
  const _MessengerCopyLinkSection(this.assistantId);

  final String assistantId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Messenger Copy Link',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Copy the following content to your Messenger app configuration page.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        CopyLinkSection(
          title: 'Callback URL',
          url: '$kbAPIUrl/kb-core/v1/hook/messenger/$assistantId',
        ),
        const SizedBox(height: 16),
        const CopyLinkSection(
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
