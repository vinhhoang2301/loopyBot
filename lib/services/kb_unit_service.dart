import 'dart:convert';
import 'dart:developer';

import 'package:final_project/consts/api.dart';
import 'package:final_project/models/unit_model.dart';
import 'package:flutter/cupertino.dart';

import 'kb_authen_service.dart';
import 'package:http/http.dart' as http;

class KbUnitService {
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
