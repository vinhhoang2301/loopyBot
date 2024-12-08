import 'dart:convert';
import 'dart:developer';
import 'package:final_project/consts/api.dart';
import 'package:final_project/consts/key.dart';
import 'package:final_project/models/ai_assistant_model.dart';
import 'package:final_project/services/kb_authen_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AiAssistantService {
  static Future<List<AiAssistantModel>?> getAllAssistants({
    required BuildContext context,
    Order order = Order.DESC,
    bool? isFavorite,
    bool? isPublish,
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken'
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              '$kbAPIUrl/kb-core/v1/ai-assistant?q&order=DESC&order_field=createdAt&offset&limit=20&is_favorite&is_published'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(await response.stream.bytesToString());

        return (result['data'] as List<dynamic>)
            .map((item) => AiAssistantModel.fromJson(item))
            .toList();
      } else {
        log('error: ${response.statusCode}');
        return null;
      }
    } catch (err) {
      log('Error in Create Assistant: ${err.toString()}');
      return null;
    }
  }

  static Future<AiAssistantModel?> createAssistant({
    required BuildContext context,
    required String assistantName,
    String instructions = '',
    String description = '',
  }) async {
    if (assistantName.isEmpty) {
      return null;
    }

    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var request =
          http.Request('POST', Uri.parse('$kbAPIUrl/kb-core/v1/ai-assistant'));
      request.body = json.encode({
        "assistantName": assistantName,
        "instructions": instructions,
        "description": description
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = await response.stream.bytesToString();

        log('result of creating chatbot ai: $result');
        return AiAssistantModel.fromJson(jsonDecode(result));
      } else {
        return null;
      }
    } catch (err) {
      log('Error in Create Assistant: ${err.toString()}');
      return null;
    }
  }

  static Future<bool> deleteAssistant({
    required BuildContext context,
    required String id,
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken'
      };
      var request = http.Request(
          'DELETE', Uri.parse('$kbAPIUrl/kb-core/v1/ai-assistant/$id'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('result of deleting chatbot ai: true');
        return true;
      } else {
        return false;
      }
    } catch (err) {
      log('Error when Deleting Assistant: ${err.toString()}');
      return false;
    }
  }

  static Future<AiAssistantModel?> getAssistant({
    required BuildContext context,
    required String id,
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken'
      };
      var request = http.Request(
          'GET', Uri.parse('$kbAPIUrl/kb-core/v1/ai-assistant/$id'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Success when Getting Assistant');
        final result = await response.stream.bytesToString();

        return AiAssistantModel.fromJson(jsonDecode(result));
      } else {
        return null;
      }
    } catch (err) {
      log('Error when Deleting Assistant: ${err.toString()}');
      return null;
    }
  }
}
