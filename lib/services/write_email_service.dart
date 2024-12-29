import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:final_project/consts/api.dart';
import 'package:final_project/services/authen_service.dart';

class WriteEmailService {
  final String baseUrl = devServer;

  Future<String?> sendEmail({
    required BuildContext context,
    required String mainIdea,
    required String action,
    required String email,
    required String subject,
    required String sender,
    required String receiver,
    required String length,
    required String formality,
    required String tone,
    required String language,
  }) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('$baseUrl/api/v1/ai-email'));
    request.body = json.encode({
      "mainIdea": mainIdea,
      "action": action,
      "email": email,
      "metadata": {
        "context": [],
        "subject": subject,
        "sender": sender,
        "receiver": receiver,
        "style": {
          "length": length,
          "formality": formality,
          "tone": tone
        },
        "language": language
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);
      return jsonResponse['email'];
    } else {
      String responseBody = await response.stream.bytesToString();
      log('Failed to send email: ${response.statusCode} - ${response.reasonPhrase}');
      log('Response body: $responseBody');
      return null;
    }
  }

  Future<List<String>?> getIdeas({
    required BuildContext context,
    required String action,
    required String email,
    required String subject,
    required String sender,
    required String receiver,
    required String language,
  }) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('$baseUrl/api/v1/ai-email/reply-ideas'));
    request.body = json.encode({
      "action": "Suggest $action for this email",
      "email": email,
      "metadata": {
        "context": [],
        "subject": subject,
        "sender": sender,
        "receiver": receiver,
        "language": language
      }
    });
    request.headers.addAll(headers);

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      return List<String>.from(jsonResponse['ideas']);
    } else {
      String responseBody = await response.stream.bytesToString();
      log('Failed to get ideas: ${response.statusCode} - ${response.reasonPhrase}');
      log('Response body: $responseBody');
      return null;
    }
  }
}