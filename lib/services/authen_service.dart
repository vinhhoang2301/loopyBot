import 'dart:convert';
import 'dart:developer';

import 'package:final_project/consts/api.dart';
import 'package:final_project/consts/key.dart';
import 'package:final_project/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AuthenticationService {
  static String? _cachedAccessToken;
  static DateTime? _tokenExpiryTime;

  static Future<String> getAccessToken(BuildContext context) async {
    if (_cachedAccessToken != null && _tokenExpiryTime != null) {
      if (DateTime.now().isBefore(_tokenExpiryTime!)) {
        return _cachedAccessToken!;
      }
    }

    final refreshToken =
        Provider.of<AuthProvider>(context, listen: false).refreshToken;

    var headers = {'x-jarvis-guid': ''};
    var request = http.Request('GET',
        Uri.parse('$devServer/api/v1/auth/refresh?refreshToken=$refreshToken'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    final statusCode = response.statusCode;

    if (statusCode == 200 || statusCode == 201) {
      final result = jsonDecode(await response.stream.bytesToString());

      _cachedAccessToken = result[TOKEN][ACCESS_TOKEN];
      _tokenExpiryTime = DateTime.now().add(
        const Duration(minutes: 1),
      );
      
      log('access token=$_cachedAccessToken');
    }

    return _cachedAccessToken ?? '';
  }

  static void clearToken() {
    _cachedAccessToken = null;
    _tokenExpiryTime = null;
  }
}
