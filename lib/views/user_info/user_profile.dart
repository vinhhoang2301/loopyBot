import 'package:final_project/consts/api.dart';
import 'package:final_project/consts/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchTokenUsage();
    _fetchSubscriptionData();
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50], // Background color of the container
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Token Usage',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Today'),
                          Text('Total'),
                        ],
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: totalTokens > 0 ? availableTokens / totalTokens : 0,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 4),
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
                SizedBox(height: 20),
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
                    Text('Your subscription:',
                      style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                      if (subscriptionData != null) ...[
                        Text('Name: ${subscriptionData!['name']}'),
                        Text('Daily Tokens: ${subscriptionData!['dailyTokens']}'),
                        Text('Monthly Tokens: ${subscriptionData!['monthlyTokens']}'),
                        Text('Annually Tokens: ${subscriptionData!['annuallyTokens']}'),
                      ] else ...[
                        Text('Loading subscription data...'),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
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
                            borderRadius: BorderRadius.circular(8)),
                        child: const ListTile(
                          leading: Icon(Icons.person, color: Colors.blue),
                          title: Text('Username'),
                          subtitle: Text('username01'),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: const ListTile(
                          leading: Icon(Icons.person, color: Colors.blue),
                          title: Text('Email'),
                          subtitle: Text('user.jarvis@gmail.com'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton.icon(
                    onPressed: () async {
                      //
                      FlutterSecureStorage secureStorage =
                          FlutterSecureStorage();
                      String? refreshToken =
                          await secureStorage.read(key: 'refreshToken');
                      var headers = {
                        'x-jarvis-guid': '',
                        'Authorization': 'Bearer $refreshToken'
                      };
                      var request = http.Request(
                          'GET', Uri.parse('$devServer/api/v1/auth/sign-out'));

                      request.headers.addAll(headers);

                      http.StreamedResponse response = await request.send();

                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        print(await response.stream.bytesToString());
                        await secureStorage.delete(key: 'refreshToken');
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.loginPage);
                      } else {
                        print(response.reasonPhrase);
                      }
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      'Log out',
                      style: TextStyle(color: Colors.red),
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
}
