import 'dart:developer';

import 'package:final_project/consts/app_color.dart';
import 'package:final_project/models/published_assistant_model.dart';
import 'package:final_project/services/ai_assistant_service.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/chatbot_ai/inner_pages/messenger_configure.dart';
import 'package:final_project/views/chatbot_ai/inner_pages/slack_configure.dart';
import 'package:final_project/views/chatbot_ai/inner_pages/telegram_configure.dart';
import 'package:final_project/views/chatbot_ai/publish_results_page.dart';
import 'package:flutter/material.dart';

class PublishAssistantPage extends StatefulWidget {
  const PublishAssistantPage({
    super.key,
    required this.assistantId,
    required this.assistantName,
  });

  final String assistantId;
  final String assistantName;

  @override
  State<PublishAssistantPage> createState() => _PublishAssistantPageState();
}

class _PublishAssistantPageState extends State<PublishAssistantPage> {
  List<PublishedAssistant>? publishedAssistants = [];

  Map<String, bool> selectedPlatforms = {
    'slack': false,
    'telegram': false,
    'messenger': false,
  };
  Map<String, bool> configuredPlatforms = {
    'slack': false,
    'telegram': false,
    'messenger': false,
  };

  bool isLoading = false;
  bool isPublishing = false;
  String? preTelegramConfigurations;
  Map<String, dynamic> preSlackConfigurations = {
    'botToken': null,
    'clientId': null,
    'clientSecret': null,
    'signingSecret': null,
  };
  Map<String, dynamic> preMessengerConfigurations = {
    'botToken': null,
    'pageId': null,
    'appSecret': null,
  };

  String? curTelegramConfigurations;
  Map<String, dynamic>? curSlackConfigurations = {};
  Map<String, dynamic>? curMessengerConfigurations = {};

  @override
  void initState() {
    fetchPublishedAssistants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    bool hasSelectedPlatform = selectedPlatforms.values.any((selected) => selected);

    return Scaffold(
      appBar: AppBar(
        title: Text('Publish ${widget.assistantName}'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.inverseTextColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: AppColors.backgroundColor1,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms and Conditions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'By publishing your bot on the following platforms, you fully understand and agree to abide by Terms of service for each publishing channel (including, but not limited to, any privacy policy, community guidelines, data processing agreement, etc.).',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : Column(
                    children: [
                      _PublishAppItem(
                        name: 'Slack',
                        asset: 'assets/icon/slack.png',
                        isSelected: selectedPlatforms['slack'] ?? false,
                        onSelected: (value) {
                          setState(() => selectedPlatforms['slack'] = value);
                        },
                        onConfigure: () async {
                          curSlackConfigurations = await Utils.showBottomSheet(
                            context,
                            sheet: Padding(
                              padding: EdgeInsets.only(top: paddingTop),
                              child: SlackConfigurePage(
                                assistantId: widget.assistantId,
                                configurations: preSlackConfigurations,
                              ),
                            ),
                            showFullScreen: true,
                          );

                          if (curSlackConfigurations?['token'] == null) {
                            setState(() {
                              configuredPlatforms['slack'] = false;
                              preSlackConfigurations = {
                                'botToken': null,
                                'clientId': null,
                                'clientSecret': null,
                                'signingSecret': null,
                              };
                            });
                          } else {
                            setState(() => configuredPlatforms['slack'] = true);
                          }
                        },
                        isConfigured: configuredPlatforms['slack'] ?? false,
                      ),
                      const SizedBox(height: 12),
                      _PublishAppItem(
                        name: 'Telegram',
                        asset: 'assets/icon/telegram.png',
                        isSelected: selectedPlatforms['telegram'] ?? false,
                        onSelected: (value) {
                          setState(() => selectedPlatforms['telegram'] = value);
                        },
                        onConfigure: () async {
                          curTelegramConfigurations = await Utils.showBottomSheet(
                            context,
                            sheet: Padding(
                              padding: EdgeInsets.only(top: paddingTop),
                              child: TelegramConfigurePage(
                                assistantId: widget.assistantId,
                                configurations: preTelegramConfigurations,
                              ),
                            ),
                            showFullScreen: true,
                          );

                          if (curMessengerConfigurations == null || curMessengerConfigurations!.isEmpty) {
                            setState(() {
                              preTelegramConfigurations = '';
                              configuredPlatforms['telegram'] = false;
                            });
                          } else {
                            setState(() => configuredPlatforms['telegram'] = true);
                          }
                        },
                        isConfigured: configuredPlatforms['telegram'] ?? false,
                      ),
                      const SizedBox(height: 12),
                      _PublishAppItem(
                        name: 'Messenger',
                        asset: 'assets/icon/messenger.png',
                        isSelected: selectedPlatforms['messenger'] ?? false,
                        onSelected: (value) {
                          setState(() => selectedPlatforms['messenger'] = value);
                        },
                        onConfigure: () async {
                          curMessengerConfigurations = await Utils.showBottomSheet(
                            context,
                            sheet: Padding(
                              padding: EdgeInsets.only(top: paddingTop),
                              child: MessengerConfigurePage(
                                assistantId: widget.assistantId,
                                configurations: preMessengerConfigurations,
                              ),
                            ),
                            showFullScreen: true,
                          );

                          if (curMessengerConfigurations?['botToken'] == null) {
                            setState(() {
                              configuredPlatforms['messenger'] = false;
                              preMessengerConfigurations = {
                                'botToken': null,
                                'pageId': null,
                                'appSecret': null,
                              };
                            });
                          } else {
                            setState(() => configuredPlatforms['messenger'] = true);
                          }
                        },
                        isConfigured: configuredPlatforms['messenger'] ?? false,
                      ),
                    ],
                  )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isPublishing
              ? null
              : hasSelectedPlatform
                  ? publishChatbot
                  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.inverseTextColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: isPublishing
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.inverseTextColor,
                  ),
                )
              : const Text(
                  'Publish Chatbot',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> fetchPublishedAssistants() async {
    setState(() => isLoading = true);

    publishedAssistants = await AiAssistantService.getConfigurations(
      context: context,
      assistantId: widget.assistantId,
    );

    if (publishedAssistants != null) {
      for (final publishedAssistant in publishedAssistants!) {
        final String type = publishedAssistant.type.toString();

        setState(() {
          configuredPlatforms[type.toString()] = true;

          log('metadata: ${publishedAssistant.metadata}');
          switch (type.toString()) {
            case 'telegram':
              final botToken = publishedAssistant.metadata?['botToken'];
              preTelegramConfigurations = botToken;
              break;
            case 'slack':
              final botToken = publishedAssistant.metadata?['botToken'];
              final clientId = publishedAssistant.metadata?['clientId'];
              final clientSecret = publishedAssistant.metadata?['clientSecret'];
              final signingSecret = publishedAssistant.metadata?['signingSecret'];

              preSlackConfigurations['botToken'] = botToken;
              preSlackConfigurations['clientId'] = clientId;
              preSlackConfigurations['clientSecret'] = clientSecret;
              preSlackConfigurations['signingSecret'] = signingSecret;
              break;
            case 'messenger':
              final botToken = publishedAssistant.metadata?['botToken'];
              final pageId = publishedAssistant.metadata?['pageId'];
              final appSecret = publishedAssistant.metadata?['appSecret'];

              preMessengerConfigurations['botToken'] = botToken;
              preMessengerConfigurations['pageId'] = pageId;
              preMessengerConfigurations['appSecret'] = appSecret;
              break;
            default:
              break;
          }
        });
      }
    }

    setState(() => isLoading = false);
  }

  Future<void> publishChatbot() async {
    List<Map<String, dynamic>> publishResults = [];

    for (String platform in selectedPlatforms.keys) {
      if (selectedPlatforms[platform]! && !configuredPlatforms[platform]!) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please configure ${platform.capitalize()} before publishing',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1),
          ),
        );

        return;
      } else if (selectedPlatforms[platform]! && configuredPlatforms[platform]!) {
        setState(() => isPublishing = true);

        try {
          String? redirectUrl = '';

          switch (platform) {
            case 'slack':
              redirectUrl = await publishToSlack(widget.assistantId);
              break;
            case 'telegram':
              redirectUrl = await publishToTelegram(widget.assistantId);
              break;
            case 'messenger':
              redirectUrl = await publishToMessenger(widget.assistantId);
              break;
            default:
              log('Something went wrong when publishing. Platform: $platform');
              break;
          }

          if (redirectUrl == null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Publish $platform failed. Try again please.',
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          } else {
            publishResults.add({
              'platform': platform,
              'redirectUrl': redirectUrl,
            });
          }
        } catch (e) {
          log('Failed when Publishing $platform, error: ${e.toString()}');
        }

        setState(() => isPublishing = false);

        if (publishResults.isNotEmpty) {
          if (!mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PublishResultsPage(
                results: publishResults,
                assistantName: widget.assistantName,
              ),
            ),
          );
        }
      }
    }
  }

  Future<String?> publishToSlack(String assistantId) async {
    final result = await AiAssistantService.publishSlackBot(
      context: context,
      assistantId: assistantId,
      botToken: curSlackConfigurations!['token'].toString(),
      clientId: curSlackConfigurations!['clientId'].toString(),
      clientSecret: curSlackConfigurations!['clientSecret'].toString(),
      signingSecret: curSlackConfigurations!['signingSecret'].toString(),
    );

    return result;
  }

  Future<String?> publishToTelegram(String assistantId) async {
    final result = await AiAssistantService.publishTelegramBot(
      context: context,
      assistantId: assistantId,
      botToken: curTelegramConfigurations.toString(),
    );

    return result;
  }

  Future<String?> publishToMessenger(String assistantId) async {
    final result = await AiAssistantService.publishMessengerBot(
      context: context,
      assistantId: assistantId,
      botToken: curMessengerConfigurations!['botToken'].toString(),
      pageId: curMessengerConfigurations!['pageId'].toString(),
      appSecret: curMessengerConfigurations!['appSecret'].toString(),
    );

    return result;
  }
}

class _PublishAppItem extends StatelessWidget {
  const _PublishAppItem({
    required this.name,
    required this.asset,
    required this.isSelected,
    required this.onSelected,
    required this.onConfigure,
    this.isConfigured = false,
  });

  final String name;
  final String asset;
  final bool isSelected;
  final bool isConfigured;
  final ValueChanged<bool> onSelected;
  final void Function() onConfigure;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelected(!isSelected),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.backgroundColor2,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (value) => onSelected(value ?? false),
                  activeColor: AppColors.primaryColor,
                ),
                Image.asset(
                  asset,
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isConfigured ? Colors.green.shade100 : AppColors.backgroundColor2,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isConfigured ? 'Verified' : 'Not Configure',
                    style: TextStyle(
                      color: isConfigured ? Colors.green : AppColors.defaultTextColor,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primaryColor.withOpacity(0.15),
                    foregroundColor: AppColors.primaryColor,
                  ),
                  onPressed: onConfigure,
                  child: const Text(
                    'Configure',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
