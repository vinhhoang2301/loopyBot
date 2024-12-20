import 'package:flutter/material.dart';
import 'package:final_project/consts/app_color.dart';
import 'package:final_project/widgets/material_button_custom_widget.dart';
import 'package:final_project/services/subscription_service.dart';
import 'dart:developer';
class UpdateAccount extends StatelessWidget {
  const UpdateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LoopyBot Premium'),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.inverseTextColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const _ContentWidget(content: 'Unlimited queries per month'),
              const _ContentWidget(
                content: 'AI Chat Models',
                subContent: 'GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra',
              ),
              const _ContentWidget(content: 'Jira Copilot Assistant'),
              const _ContentWidget(
                  content: 'No request limits during high-traffic'),
              const _ContentWidget(content: '2X faster response speed'),
              const _ContentWidget(content: 'Priority email support'),
              const SizedBox(height: 16),
              const Text(
                'Auto-renews for 500.000 đ/month until canceled',
              ),
              const SizedBox(height: 16),
              MaterialButtonCustomWidget(
                  onPressed: () async {
                  log('Subscribe button pressed');
                  final subscriptionService = SubscriptionService();
                  await subscriptionService.subscribeToService(context);
                },
                title: 'Subscribe',
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              const SizedBox(height: 16),
              MaterialButtonCustomWidget(
                onPressed: () async { 
  
                },
                title: 'Restore Subscription',
                isApproved: false,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentWidget extends StatelessWidget {
  const _ContentWidget({required this.content, this.subContent});

  final String content;
  final String? subContent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.check_circle,
        color: AppColors.primaryColor,
      ),
      title: Text(content),
      subtitle: subContent != null ? Text(subContent ?? '') : null,
    );
  }
}
