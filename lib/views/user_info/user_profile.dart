import 'dart:developer';

import 'package:final_project/consts/api.dart';
import 'package:final_project/consts/app_color.dart';
import 'package:final_project/models/user_model.dart';
import 'package:final_project/services/authen_service.dart';
import 'package:final_project/utils/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:final_project/services/subscription_service.dart';
import '../../consts/app_routes.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int availableTokens = 0;
  int totalTokens = 0;
  Map<String, dynamic>? subscriptionData;
  UserModel? user;
  BannerAd? bannerAd;

  @override
  void initState() {
    super.initState();
    _fetchTokenUsage();
    _fetchSubscriptionData();
    _fetchCurrentUserInfo();
    _createBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.inverseTextColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (bannerAd != null)
                  SizedBox(
                    width: bannerAd!.size.width.toDouble(),
                    height: bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: bannerAd!),
                  ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50], // Background color of the container
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Token Usage',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Today'),
                          Text('Total'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: totalTokens > 0 ? availableTokens / totalTokens : 0,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$availableTokens'),
                          Text('$totalTokens'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                  color: Colors.blue[50], // Background color of the container
                  borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your subscription',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subscriptionData != null) ...[
                        Column(
                          children: [
                            const SizedBox(height: 8),
                            _SubscriptionContent(
                              title: 'Name:',
                              value: subscriptionData!['name'],
                            ),
                            _SubscriptionContent(
                              title: 'Daily Tokens:',
                              value: subscriptionData!['dailyTokens'].toString(),
                            ),
                            _SubscriptionContent(
                              title: 'Monthly Tokens:',
                              value: subscriptionData!['monthlyTokens'].toString(),
                            ),
                            _SubscriptionContent(
                              title: 'Annually Tokens:',
                              value: subscriptionData!['annuallyTokens'].toString(),
                            ),
                          ],
                        ),
                      ] else ...[
                        const Text('Loading subscription data...'),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50], // Background color of the container
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your Account',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 8),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.person, color: Colors.blue),
                          title: const Text('Username'),
                          subtitle: Text(user != null ? user!.username.toString() : 'Failed to load current user info'),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.email, color: Colors.blue),
                          title: const Text('Email'),
                          subtitle: Text(user != null ? user!.email.toString() : 'Failed to load current user info'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton.icon(
                    onPressed: logout,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Log out',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchTokenUsage() async {
    SubscriptionService subscriptionService = SubscriptionService();
    var tokenData = await subscriptionService.getSubscriptionToken(context);
    if (tokenData != null) {
      setState(() {
        availableTokens = tokenData['availableTokens'];
        totalTokens = tokenData['totalTokens'];
      });
    }
  }

  Future<void> _fetchSubscriptionData() async {
    SubscriptionService subscriptionService = SubscriptionService();
    var data = await subscriptionService.getSubscriptionUsage(context);
    if (data != null) {
      setState(() {
        subscriptionData = data;
      });
    }
  }

  Future<void> _fetchCurrentUserInfo() async {
    user = await AuthenticationService.getCurrentUser(context: context);
    setState(() {});
  }

  Future<void> logout() async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    String? refreshToken = await secureStorage.read(key: 'refreshToken');
    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $refreshToken'};
    var request = http.Request('GET', Uri.parse('$devServer/api/v1/auth/sign-out'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      log(await response.stream.bytesToString());
      await secureStorage.delete(key: 'refreshToken');
      Navigator.of(context).pushReplacementNamed(AppRoutes.loginPage);
    } else {
      log(response.reasonPhrase.toString());
    }
  }

  void _createBannerAd() {
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

class _SubscriptionContent extends StatelessWidget {
  const _SubscriptionContent({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 64.0, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
