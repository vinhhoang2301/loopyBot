import 'dart:convert';
import 'dart:developer';

import 'package:final_project/consts/api.dart';
import 'package:final_project/consts/key.dart';
import 'package:final_project/models/ai_agent_model.dart';
import 'package:final_project/models/ai_response_model.dart';
import 'package:final_project/models/chat_metadata.dart';
import 'package:final_project/models/conversation_model.dart';
import 'package:final_project/services/authen_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AiChatServices {
  static Future<AiResponseModel?> sendMessages(
    BuildContext context, {
    required String content,
    required AiAgentModel aiAgent,
    List<ChatMetaData>? metaDataMessages,
    String? id,
  }) async {
    final accessToken = await AuthenticationService.getAccessToken(context);
    AiResponseModel aiResponse;

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('$devServer/api/v1/ai-chat/messages'));

    Map<String, dynamic> body = {
      "content": content,
      "assistant": {"id": aiAgent.id, "model": DIFY, "name": aiAgent.name},
    };

    if (id != null) {
      Map<String, dynamic> metaData = {
        "conversation": {
          "id": id,
          "messages": metaDataMessages?.map((msg) => msg.toJson()).toList(),
        }
      };

      body['metadata'] = metaData;
    }

    request.body = jsonEncode(body);

    log('body: ${request.body}');
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = await response.stream.bytesToString();

      log(result);
      aiResponse = AiResponseModel.fromJson(jsonDecode(result));
      return aiResponse;
    }

    log(response.reasonPhrase.toString());
    return null;
  }

  static Future<List<ConversationModel>> getConversations(
    BuildContext context, {
    required String assistantId,
  }) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request('GET', Uri.parse('$devServer/api/v1/ai-chat/conversations?assistantId=$assistantId&assistantModel=$DIFY'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = jsonDecode(await response.stream.bytesToString());

      return (result['items'] as List<dynamic>)
          .map((item) => ConversationModel.fromJson(item))
          .toList();
    }

    log(response.reasonPhrase.toString());
    return [];
  }

  static Future<List<ChatMetaData>> getConversationHistory(BuildContext context, {required String conversationId, required String assistantId}) async {
    final accessToken = await AuthenticationService.getAccessToken(context);
    List<ChatMetaData> chatMetaData = [];

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request('GET', Uri.parse('$devServer/api/v1/ai-chat/conversations/$conversationId/messages?assistantId=$assistantId&assistantModel=$DIFY'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = jsonDecode(await response.stream.bytesToString());
      final items = result['items'];

      for (final item in items) {
        final userMsg = ChatMetaData(
          role: 'user',
          content: item['query'],
        );

        final modelAns = ChatMetaData(
          role: 'model',
          content: item['answer'],
        );

        // todo: support file

        chatMetaData.add(userMsg);
        chatMetaData.add(modelAns);
      }

      chatMetaData = chatMetaData.reversed.toList();
      return chatMetaData;
    } else {
      log(response.reasonPhrase.toString());
      return [];
    }
  }
}
