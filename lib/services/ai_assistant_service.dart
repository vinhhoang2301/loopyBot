import 'dart:convert';
import 'dart:developer';
import 'package:final_project/consts/api.dart';
import 'package:final_project/consts/key.dart';
import 'package:final_project/models/ai_assistant_model.dart';
import 'package:final_project/models/kb_model.dart';
import 'package:final_project/models/published_assistant_model.dart';
import 'package:final_project/services/kb_authen_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AiAssistantService {
  static Future<bool> disconnectBotIntegration({
    required BuildContext context,
    required String assistantId,
    required String botType,
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken'
      };
      var request = http.Request(
          'DELETE',
          Uri.parse(
              '$kbAPIUrl/kb-core/v1/bot-integration/$assistantId/$botType'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        log('Error in Disconnect Bot Integration: ${response.statusCode}');
        return false;
      }
    } catch (err) {
      log('Error in Disconnect Bot Integration: ${err.toString()}');
      return false;
    }
  }

  static Future<List<PublishedAssistant>?> getConfigurations({
    required BuildContext context,
    required String assistantId,
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
              '$kbAPIUrl/kb-core/v1/bot-integration/$assistantId/configurations'));

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(await response.stream.bytesToString());

        return (result as List<dynamic>)
            .map((item) => PublishedAssistant.fromJson(item))
            .toList();
      } else {
        log('Error in Get Configurations Bot: ${response.statusCode}');
        return null;
      }
    } catch (err) {
      log('Error in Get Configurations Bot: ${err.toString()}');
      return null;
    }
  }

  static Future<String?> publishMessengerBot({
    required BuildContext context,
    required String assistantId,
    required String botToken,
    required String pageId,
    required String appSecret,
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              '$kbAPIUrl/kb-core/v1/bot-integration/messenger/publish/$assistantId'));

      request.body = json.encode(
          {"botToken": botToken, "pageId": pageId, "appSecret": appSecret});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(await response.stream.bytesToString());
        return result['redirect'];
      } else {
        log('Error in Publish Messenger Bot: ${response.statusCode}');
        return null;
      }
    } catch (err) {
      log('Error in Publish Messenger Bot: ${err.toString()}');
      return null;
    }
  }

  static Future<String?> publishSlackBot({
    required BuildContext context,
    required String assistantId,
    required String botToken,
    required String clientId,
    required String clientSecret,
    required String signingSecret,
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              '$kbAPIUrl/kb-core/v1/bot-integration/slack/publish/$assistantId'));

      request.body = json.encode({
        "botToken": botToken,
        "clientId": clientId,
        "clientSecret": clientSecret,
        "signingSecret": signingSecret
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(await response.stream.bytesToString());
        return result['redirect'];
      } else {
        log('Error in Publish Slack Bot: ${response.statusCode}');
        return null;
      }
    } catch (err) {
      log('Error in Publish Slack Bot: ${err.toString()}');
      return null;
    }
  }

  static Future<String?> publishTelegramBot({
    required BuildContext context,
    required String assistantId,
    required String botToken,
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              '$kbAPIUrl/kb-core/v1/bot-integration/telegram/publish/$assistantId'));

      request.body = json.encode({"botToken": botToken});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(await response.stream.bytesToString());
        return result['redirect'];
      } else {
        log('Error in Publish Telegram Bot: ${response.statusCode}');
        return null;
      }
    } catch (err) {
      log('Error in Publish Telegram Bot: ${err.toString()}');
      return null;
    }
  }

  static Future<bool> verifyMessengerBotConfigure({
    required BuildContext context,
    required String botToken,
    required String pageId,
    required String appSecret,
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              '$kbAPIUrl/kb-core/v1/bot-integration/messenger/validation'));

      request.body = json.encode(
          {"botToken": botToken, "pageId": pageId, "appSecret": appSecret});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        log('Error in Verify Messenger Bot Configure: ${response.statusCode}');
        return false;
      }
    } catch (err) {
      log('Error in Verify Messenger Bot Configure: ${err.toString()}');
      return false;
    }
  }

  static Future<bool> verifySlackBotConfigure({
    required BuildContext context,
    required String botToken,
    required String clientId,
    required String clientSecret,
    required String signingSecret,
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      var request = http.Request('POST',
          Uri.parse('$kbAPIUrl/kb-core/v1/bot-integration/slack/validation'));

      request.body = json.encode({
        "botToken": botToken,
        "clientId": clientId,
        "clientSecret": clientSecret,
        "signingSecret": signingSecret
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        log('Error in Verify Slack Bot Configures: ${response.statusCode}');
        return false;
      }
    } catch (err) {
      log('Error in Verify Slack Bot Configure: ${err.toString()}');
      return false;
    }
  }

  static Future<bool> verifyTelegramBotConfigure({
    required BuildContext context,
    required String botToken,
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              '$kbAPIUrl/kb-core/v1/bot-integration/telegram/validation'));

      request.body = json.encode({"botToken": botToken});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      log('bot token: $botToken');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        log('Error in Verify Telegram Bot Configure: ${response.statusCode}');
        return false;
      }
    } catch (err) {
      log('Error in Verify Telegram Bot Configure: ${err.toString()}');
      return false;
    }
  }

  static Future<bool> removeKnowledgeFromAssistant({
    required BuildContext context,
    required String assistantId,
    required String knowledgeId,
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken'
      };
      var request = http.Request(
          'DELETE',
          Uri.parse(
              '$kbAPIUrl/kb-core/v1/ai-assistant/$assistantId/knowledges/$knowledgeId'));

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        log('Error in Remove Knowledge from Assistant: ${response.statusCode}');
        return false;
      }
    } catch (err) {
      log('Error in Remove Knowledge from Assistant: ${err.toString()}');
      return false;
    }
  }

  static Future<bool> importKnowledgeToAssistant({
    required BuildContext context,
    required String assistantId,
    required String knowledgeId,
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              '$kbAPIUrl/kb-core/v1/ai-assistant/$assistantId/knowledges/$knowledgeId'));

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        log('Error in Import Knowledge to Assistant: ${response.statusCode}');
        return false;
      }
    } catch (err) {
      log('Error in Import Knowledge to Assistant: ${err.toString()}');
      return false;
    }
  }

  static Future<List<KbModel>?> getImportedKnowledge({
    required BuildContext context,
    required String assistantId,
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
              '$kbAPIUrl/kb-core/v1/ai-assistant/$assistantId/knowledges?q&order=DESC&order_field=createdAt&offset&limit=20'));

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(await response.stream.bytesToString());

        return (result['data'] as List<dynamic>)
            .map((item) => KbModel.fromJson(item))
            .toList();
      } else {
        log('Error in Get Imported Knowledge of Assistant: ${response.statusCode}');
        return null;
      }
    } catch (err) {
      log('Error in Get Imported Knowledge of Assistant: ${err.toString()}');
      return null;
    }
  }

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
        log('Error in Get All Assistant: ${response.statusCode}');
        return null;
      }
    } catch (err) {
      log('Error in Get All Assistant: ${err.toString()}');
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

  static Future<bool> updateAssistant({
    required BuildContext context,
    required String id,
    required String assistantName,
    String? assistantDes,
    String? assistantIns,
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'PATCH', Uri.parse('$kbAPIUrl/kb-core/v1/ai-assistant/$id'));

      request.body = json.encode({
        "assistantName": assistantName,
        "instructions": assistantIns,
        "description": assistantDes
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      log('Error when Updating Assistant: ${err.toString()}');
      return false;
    }
  }

  static Future<String?> askAssistant({
    required BuildContext context,
    required String assistantId,
    required String msg,
    required String openAiThreadId,
    String additionalIns = '',
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST',
          Uri.parse('$kbAPIUrl/kb-core/v1/ai-assistant/$assistantId/ask'));

      request.body = json.encode({
        "message": msg,
        "openAiThreadId": openAiThreadId,
        "additionalInstruction": additionalIns
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = await response.stream.bytesToString();
        return result;
      } else {
        log('failed');
        return null;
      }
    } catch (err) {
      log('Error when Asking Assistant: ${err.toString()}');
      return null;
    }
  }

  static Future<AiAssistantModel?> updateWithNewThreadPlayGround({
    required BuildContext context,
    required String assistantId,
  }) async {
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST',
          Uri.parse('$kbAPIUrl/kb-core/v1/ai-assistant/thread/playground'));

      request.body =
          json.encode({"assistantId": assistantId, "firstMessage": ""});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = await response.stream.bytesToString();

        return AiAssistantModel.fromJson(jsonDecode(result));
      } else {
        return null;
      }
    } catch (err) {
      log('Error when Updating Assistant with New Thread: ${err.toString()}');
      return null;
    }
  }
}
