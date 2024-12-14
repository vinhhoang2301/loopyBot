import 'package:final_project/consts/app_color.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/chatbot_ai/inner_pages/messenger_configure.dart';
import 'package:final_project/views/chatbot_ai/inner_pages/slack_configure.dart';
import 'package:final_project/views/chatbot_ai/inner_pages/telegram_configure.dart';
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

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    bool hasSelectedPlatform =
        selectedPlatforms.values.any((selected) => selected);


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
            _PublishAppItem(
              name: 'Slack',
              asset: 'assets/icon/slack.png',
              isSelected: selectedPlatforms['slack'] ?? false,
              onSelected: (value) {
                setState(() => selectedPlatforms['slack'] = value);
              },
              onConfigure: () async {
                setState(() => configuredPlatforms['slack'] = true);
                await Utils.showBottomSheet(
                  context,
                  sheet: Padding(
                    padding: EdgeInsets.only(top: paddingTop),
                    child: const SlackConfigurePage(),
                  ),
                  showFullScreen: true,
                );
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
                setState(() => configuredPlatforms['telegram'] = true);
                await Utils.showBottomSheet(
                  context,
                  sheet: Padding(
                    padding: EdgeInsets.only(top: paddingTop),
                    child: const TelegramConfigurePage(),
                  ),
                  showFullScreen: true,
                );
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
                setState(() => configuredPlatforms['messenger'] = true);
                await Utils.showBottomSheet(
                  context,
                  sheet: Padding(
                    padding: EdgeInsets.only(top: paddingTop),
                    child: const MessengerConfigurePage(),
                  ),
                  showFullScreen: true,
                );
              },
              isConfigured: configuredPlatforms['messenger'] ?? false,
            ),
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
          onPressed: hasSelectedPlatform ? () {} : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.inverseTextColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
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
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.backgroundColor2,
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
                const SizedBox(width: 8),
                Image.asset(
                  asset,
                  width: 36,
                  height: 36,
                ),
                const SizedBox(width: 12),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Status'),
                const SizedBox(width: 32),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primaryColor.withOpacity(0.15),
                    foregroundColor: AppColors.primaryColor,
                  ),
                  onPressed: onConfigure,
                  child: const Text('Configure'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
