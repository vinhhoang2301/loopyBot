import 'dart:convert';
import 'dart:developer';

import 'package:final_project/consts/api.dart';
import 'package:final_project/consts/key.dart';
import 'package:final_project/models/user_model.dart';
import 'package:final_project/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AuthenticationService {
  static const _secureStorage = FlutterSecureStorage();
  static String? _cachedAccessToken;
  static DateTime? _tokenExpiryTime;

  static Future<String> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    String errorMsg = 'An error occurred';

    var headers = {'x-jarvis-guid': '', 'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('$devServer/api/v1/auth/sign-in'));
    request.body = json.encode({"email": email, "password": password});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = jsonDecode(await response.stream.bytesToString());
      final refreshToken = result['token']['refreshToken'];
      await _secureStorage.write(key: 'refreshToken', value: refreshToken);

      await context.read<AuthenticationProvider>().setTokens(
            accessToken: '',
            refreshToken: refreshToken,
          );

      return '';
    } else {
      if (context.mounted) {
        errorMsg = _handleSignInError(context, response.statusCode);
      }
    }
    return errorMsg;
  }

  static String _handleSignInError(BuildContext context, int statusCode) {
    String message;
    switch (statusCode) {
      case 400:
        message = 'Email must be an email';
        break;
      case 422:
        message = 'Email or password is invalid';
        break;
      default:
        message = 'An error occurred';
    }
    return message;
  }

  static Future<bool> signUp({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      var headers = {'x-jarvis-guid': '', 'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse('$devServer/api/v1/auth/sign-up'));
      request.body = json
          .encode({"email": email, "password": password, "username": username});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      log('Failed when Creating New LoopyBot Account: ${err.toString()}');
      return false;
    }
  }

  static Future<bool> loginViaGoogle({required BuildContext context}) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      log('Đã đăng nhập với Google: ${userCredential.credential?.token}');

      // var headers = {
      //   'Content-Type': 'application/json'
      // };
      // var request = http.Request('POST', Uri.parse('$devServer/api/v1/auth/google-sign-in'));
      // request.body = json.encode({
      //   "token": "string"
      // });
      // request.headers.addAll(headers);
      //
      // http.StreamedResponse response = await request.send();
      //
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return true;
      // }
      // else {
      //   return false;
      // }
      return true;
    } catch (err) {
      log('Lỗi khi đăng nhập với Google: $err');
      return false;
    }
  }

  static Future<String> getAccessToken(BuildContext context) async {
    if (_cachedAccessToken != null && _tokenExpiryTime != null) {
      if (DateTime.now().isBefore(_tokenExpiryTime!)) {
        return _cachedAccessToken!;
      }
    }

    final refreshToken =
        Provider.of<AuthenticationProvider>(context, listen: false)
            .refreshToken;

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

  static Future<UserModel?> getCurrentUser({required BuildContext context}) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $accessToken'};
    var request = http.MultipartRequest('GET', Uri.parse('$devServer/api/v1/auth/me'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = await response.stream.bytesToString();

      log('result user info: $result');

      return UserModel.fromJson(jsonDecode(result));
    } else {
      log('Error when getting current user: ${response.reasonPhrase}');
      return null;
    }
  }

  static void clearToken() {
    _cachedAccessToken = null;
    _tokenExpiryTime = null;
  }
}
