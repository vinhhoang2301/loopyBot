import 'dart:convert';
import 'dart:developer';

import 'package:final_project/consts/api.dart';
import 'package:final_project/services/authen_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TokenService {
  static Future<int> getTotalToken(BuildContext context) async {
    final accessToken = await AuthenticationService.getAccessToken(context);
    int totalTokens = -1;

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request('GET', Uri.parse('$devServer/api/v1/tokens/usage'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = jsonDecode(await response.stream.bytesToString());
      totalTokens = result['totalTokens'];
    }
    else {
      log('error in getTotalToken: ${response.reasonPhrase.toString()}');
    }

    return totalTokens;
  }

  static Future<int> getAvailableTokens(BuildContext context) async {
    final accessToken = await AuthenticationService.getAccessToken(context);
    int availableTokens = -1;

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request('GET', Uri.parse('$devServer/api/v1/tokens/usage'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = jsonDecode(await response.stream.bytesToString());
      availableTokens = result['availableTokens'];
    }
    else {
      log('error in getAvailableTokens: ${response.reasonPhrase.toString()}');
    }

    return availableTokens;
  }
}