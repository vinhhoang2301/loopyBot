
import 'dart:convert';
import 'dart:developer';

import 'package:final_project/consts/api.dart';
import 'package:final_project/consts/key.dart';
import 'package:final_project/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AuthenticationService {
  static Future<String> getAccessToken(BuildContext context) async {
    final refreshToken = Provider.of<AuthProvider>(context, listen: false).refreshToken;
    String accessToken = '';

    var headers = {
      'x-jarvis-guid': ''
    };
    var request = http.Request('GET', Uri.parse('$devServer/api/v1/auth/refresh?refreshToken=$refreshToken'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final statusCode = response.statusCode;
    if (statusCode == 200 || statusCode == 201) {
      final result = jsonDecode(await response.stream.bytesToString());

      accessToken = result[TOKEN][ACCESS_TOKEN];
      log('access token=$accessToken');
    }

    return accessToken;
  }
}