import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:final_project/consts/api.dart';
import 'package:final_project/services/authen_service.dart';

class SubscriptionService {
  final String baseUrl = devServer;

  Future<void> subscribeToService(BuildContext context) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
    };
    var request = http.Request('GET', Uri.parse('$baseUrl/api/v1/subscriptions/subscribe'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      log('Subscription successful: $responseBody');
    } else {
      String responseBody = await response.stream.bytesToString();
      log('Failed to subscribe: ${response.statusCode} - ${response.reasonPhrase}');
      log('Response body: $responseBody');
    }
  }
  Future<Map<String, dynamic>?> getSubscriptionUsage(BuildContext context) async {
    final accessToken = await AuthenticationService.getAccessToken(context);
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
    };
    var request = http.Request('GET', Uri.parse('$baseUrl/api/v1/subscriptions/me'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      log(responseBody);

      // Parse the response
      var jsonResponse = jsonDecode(responseBody);
      return jsonResponse;
    } else {
      log(response.reasonPhrase ?? 'Failed to get subscription usage');
      return null;
    }
  }
  Future<Map<String, dynamic>?> getSubscriptionToken(BuildContext context) async {
    final accessToken = await AuthenticationService.getAccessToken(context);
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
    };
    var request = http.Request('GET', Uri.parse('$baseUrl/api/v1/tokens/usage'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);
      return jsonResponse;
    } else {
      print(response.reasonPhrase);
      return null;
    }
  }
}