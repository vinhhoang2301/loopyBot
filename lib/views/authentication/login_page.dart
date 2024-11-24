import 'dart:convert';
import 'dart:developer';
import 'package:final_project/consts/api.dart';
import 'package:final_project/consts/app_color.dart';
import 'package:final_project/consts/key.dart';
import 'package:final_project/providers/auth_provider.dart';
import 'package:final_project/widgets/material_button_custom_widget.dart';
import 'package:final_project/widgets/textfield_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../consts/app_routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    // _initRefreshToken();
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 50.0),
                  Image.asset(
                    'assets/icon/app_icon.png',
                    height: 100,
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'LoopyBot',
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFieldItem(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20.0),
                  TextFieldItem(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.resetPassword),
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25.0),
                  MaterialButtonCustomWidget(
                    onPressed: () => signIn(
                      context,
                      emailController.text,
                      passwordController.text,
                    ),
                    title: 'Sign In',
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  MaterialButtonCustomWidget(
                    onPressed: signInWithGoogle,
                    content: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/icon/google.png'),
                          height: 30,
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Join With Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not a member?'),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.register),
                        child: Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue[500],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Sign In Method
  Future<void> signIn(
      BuildContext context, String username, String password) async {
    var headers = {'x-jarvis-guid': '', 'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('$devServer/api/v1/auth/sign-in'));
    request.body = json.encode({"email": username, "password": password});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      // log(await response.stream.bytesToString());
      final result = jsonDecode(await response.stream.bytesToString());
      final refreshToken = result['token']['refreshToken'];
      await secureStorage.write(key: 'refreshToken', value: refreshToken);
      log(refreshToken ?? 'null');

      if (!context.mounted) return;

      await context.read<AuthProvider>().setTokens(
            accessToken: '',
            refreshToken: refreshToken,
          );

      log('is authen: ${context.read<AuthProvider>().isAuthenticated}');

      Navigator.of(context).pushReplacementNamed(AppRoutes.homeChat);
    } else {
      int statusCode = response.statusCode;
      switch (statusCode) {
        case 400:
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Try again'),
                ),
              ],
              title: const Text('Failed'),
              content: const Text('Email must be an email'),
              contentPadding: const EdgeInsets.all(20.0),
            ),
          );
          break;

        case 422:
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Try again'),
                ),
              ],
              title: const Text('Failed'),
              content: const Text('Email or password is invalid'),
              contentPadding: const EdgeInsets.all(20.0),
            ),
          );
          break;

        default:
          break;
      }
      log(response.reasonPhrase.toString());
    }
  }

  void signInWithGoogle() {}

  void _initRefreshToken() async {
    String? refreshToken = await getRefreshToken();
    log('Refresh Token: ${refreshToken.toString()}');

    if (refreshToken != null && refreshToken.isNotEmpty) {
      var headers = {'x-jarvis-guid': ''};
      var request = http.Request(
          'GET',
          Uri.parse(
              '$devServer/api/v1/auth/refresh?refreshToken=$refreshToken'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(await response.stream.bytesToString());
        final accessToken = result[TOKEN][ACCESS_TOKEN];

        log('access token: $accessToken');

        context.read<AuthProvider>().setTokens(
              accessToken: accessToken,
              refreshToken: '',
            );
      } else {
        log(response.reasonPhrase.toString());
      }

      Navigator.of(context).pushReplacementNamed(AppRoutes.homeChat);
    }
  }

  Future<String?> getRefreshToken() async {
    final res = await secureStorage.read(key: 'refreshToken');
    return res;
  }
}
