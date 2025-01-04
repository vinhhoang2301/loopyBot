import 'dart:convert';
import 'dart:developer';

import 'package:final_project/consts/api.dart';
import 'package:final_project/consts/key.dart';
import 'package:final_project/providers/kb_auth_provider.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class KBAuthService {
  static String? _cachedAccessToken;
  static DateTime? _tokenExpiryTime;

  static Future<void> signInFromExternalClient(
    BuildContext context, {
    required String accessToken,
  }) async {
    var headers = {'x-jarvis-guid': '', 'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('$kbAPIUrl/kb-core/v1/auth/external-sign-in'));

    request.body = json.encode({"token": accessToken});
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      final statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        final result = jsonDecode(await response.stream.bytesToString());

        final String kbAccessToken = result[TOKEN][ACCESS_TOKEN];
        final String kbRefreshToken = result[TOKEN][REFRESH_TOKEN];

        _cachedAccessToken = kbAccessToken;

        await Provider.of<KBAuthProvider>(context, listen: false).setTokens(
          refreshToken: kbRefreshToken,
        );

        log('Sign In KB From External Client Successfully');
        log('Refresh Token of KB: $kbRefreshToken');
        log('Access Token of KB: $accessToken');
      } else {
        log('Sign In KB From External Client Failed: $statusCode');
      }
    } catch (err) {
      log('Error when Sign In KB From External Client: ${err.toString()}');
    }
  }

  static Future<String?> getKbAccessToken(BuildContext context) async {
    return await Utils.withConnection(
      context,
      () async {
        if (_cachedAccessToken != null && _tokenExpiryTime != null) {
          if (DateTime.now().isBefore(_tokenExpiryTime!)) {
            return _cachedAccessToken!;
          }
        }

        final refreshToken = Provider.of<KBAuthProvider>(context, listen: false).refreshToken;

        var headers = {'x-jarvis-guid': '', 'Content-Type': 'application/json'};
        var request = http.Request('GET', Uri.parse('$kbAPIUrl/kb-core/v1/auth/refresh?refreshToken=$refreshToken'));
        request.body = json.encode({});
        request.headers.addAll(headers);

        try {
          http.StreamedResponse response = await request.send();

          final statusCode = response.statusCode;
          log('KB Refresh Token: $refreshToken');

          if (statusCode == 200 || statusCode == 201) {
            final result = jsonDecode(await response.stream.bytesToString());

            _cachedAccessToken = result[TOKEN][ACCESS_TOKEN];
            _tokenExpiryTime = DateTime.now().add(
              const Duration(minutes: 1),
            );

            log('Get KB Access Token Successfully');
          } else {
            log('Get KB Access Token Failed: $statusCode');
          }
        } catch (err) {
          log('Error when getting KB Access Token: ${err.toString()}');
        }

        return _cachedAccessToken ?? '';
      },
    );
  }
}
