import 'dart:convert';
import 'dart:developer';

import 'package:final_project/consts/api.dart';
import 'package:final_project/consts/key.dart';
import 'package:final_project/models/chat_response_model.dart';
import 'package:final_project/services/authen_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AiChatServices {
  static Future<ChatResponseModel?> doAiChat(BuildContext context, {required String modelId, required String msg}) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    // todo: check if accessToken is empty

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('$devServer/api/v1/ai-chat'));
    request.body = json.encode({
      "assistant": {
        "id": modelId,
        "model": DIFY,
      },
      "content": msg,
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(responseBody);

        return ChatResponseModel(
          message: data['message'] ?? '',
          conversationId: data['conversationId'] ?? '',
          remainingUsage: data['remainingUsage'] ?? -1,
        );
      } else {
        log(response.reasonPhrase.toString());
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}