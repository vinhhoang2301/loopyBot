import 'dart:developer';

import 'package:final_project/utils/ad_helper.dart';
import 'package:final_project/consts/api.dart';
import 'package:flutter/material.dart';
import 'package:final_project/consts/app_color.dart';
import 'package:final_project/widgets/material_button_custom_widget.dart';
import 'package:final_project/services/subscription_service.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class UpdateAccount extends StatefulWidget {
  const UpdateAccount({super.key});

  @override
  State<UpdateAccount> createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  BannerAd? bannerAd;

  @override
  void initState() {
    super.initState();

    createBannerAd();
  }

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
                subContent:
                    'GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra',
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
                onPressed: () => Utils.launchUrlString(
                  urlString: '$prodServer/pricing/overview',
                ),
                title: 'Upgrade to Premium',
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              const SizedBox(height: 8),
              MaterialButtonCustomWidget(
                onPressed: () async {
                  SubscriptionService subscriptionService =
                      SubscriptionService();
                  var subscriptionData =
                      await subscriptionService.getSubscriptionUsage(context);

                  if (subscriptionData != null) {
                    log('Subscription data: $subscriptionData');
                  } else {
                    log('Failed to restore subscription');
                  }
                },
                title: 'Restore Subscription',
                isApproved: false,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              if (bannerAd != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    width: bannerAd!.size.width.toDouble(),
                    height: bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: bannerAd!),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void createBannerAd() {
    AdHelper.createBannerAd(
      onAdLoaded: (ad) {
        setState(() => bannerAd = ad);
      },
      onAdFailedToLoad: (error) {
        log('Failed to load a banner ad in Update Account: $error');
      },
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
