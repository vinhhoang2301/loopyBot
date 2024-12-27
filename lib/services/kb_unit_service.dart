import 'dart:convert';
import 'dart:developer';

import 'package:final_project/consts/api.dart';
import 'package:final_project/models/unit_model.dart';
import 'package:flutter/cupertino.dart';

import 'kb_authen_service.dart';
import 'package:http/http.dart' as http;

class KbUnitService {
  static Future<UnitModel?> createConfluenceUnit({
    required BuildContext context,
    required String unitName,
    required String wikiPageUrl,
    required String confluenceUsername,
    required String confluenceAccessToken,
    required String id,
  }) async {
    if (unitName.isEmpty ||
        wikiPageUrl.isEmpty ||
        confluenceUsername.isEmpty ||
        confluenceAccessToken.isEmpty) {
      return null;
    }

    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST', Uri.parse('/kb-core/v1/knowledge/$id/confluence'));
      request.body = json.encode({
        "unitName": unitName,
        "wikiPageUrl": wikiPageUrl,
        "confluenceUsername": confluenceUsername,
        "confluenceAccessToken": confluenceAccessToken,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = await response.stream.bytesToString();
        log('Result of creating confluence unit: $result');
        return UnitModel.fromJson(jsonDecode(result));
      } else {
        log(response.reasonPhrase.toString());
        return null;
      }
    } catch (err) {
      log('Error in Confluence Unit KB: ${err.toString()}');
      return null;
    }
  }

  static Future<UnitModel?> createSlackUnit({
    required BuildContext context,
    required String unitName,
    required String slackWorkspace,
    required String slackBotToken,
    required String id,
  }) async {
    if (unitName.isEmpty || slackWorkspace.isEmpty || slackWorkspace.isEmpty) {
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
          http.Request('POST', Uri.parse('/kb-core/v1/knowledge/$id/slack'));
      request.body = json.encode({
        "unitName": unitName,
        "slackWorkspace": slackWorkspace,
        "slackBotToken": slackBotToken,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = await response.stream.bytesToString();
        log('Result of creating slack unit: $result');
        return UnitModel.fromJson(jsonDecode(result));
      } else {
        log(response.reasonPhrase.toString());
        return null;
      }
    } catch (err) {
      log('Error in Slack Unit KB: ${err.toString()}');
      return null;
    }
  }

  static Future<UnitModel?> createWebsiteUnit({
    required BuildContext context,
    required String unitName,
    required String webUrl,
    required String id,
  }) async {
    if (unitName.isEmpty || webUrl.isEmpty) {
      return null;
    }
    final accessToken = await KBAuthService.getKbAccessToken(context);

    try {
      var headers = {
        'x-jarvis-guid': '',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST', Uri.parse('$kbAPIUrl/kb-core/v1/knowledge/$id/web'));
      request.body = json.encode({
        "unitName": unitName,
        "webUrl": webUrl,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = await response.stream.bytesToString();
        log('Result of creating website unit: $result');
        return UnitModel.fromJson(jsonDecode(result));
      } else {
        log(response.reasonPhrase.toString());
        return null;
      }
    } catch (err) {
      log('Error in Unit KB: ${err.toString()}');
      return null;
    }
  }
}
