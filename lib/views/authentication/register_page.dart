import 'dart:convert';
import 'dart:developer';

import 'package:final_project/consts/api.dart';
import 'package:flutter/material.dart';
import 'package:final_project/consts/app_color.dart';
import 'package:final_project/consts/app_routes.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  void signUp(BuildContext context, String email, String username,
      String password) async {
    var headers = {'x-jarvis-guid': '', 'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('$devServer/api/v1/auth/sign-up'));
    request.body = json
        .encode({"email": email, "password": password, "username": username});
    request.headers.addAll(headers);
    log(request.body.toString());
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(AppRoutes.loginPage);
              },
              child: const Text('Continue'),
            ),
          ],
          title: const Text('Success'),
          content: const Text('Account registration successful'),
          contentPadding: const EdgeInsets.all(20.0),
        ),
      );
      log(await response.stream.bytesToString());
    } else {
      int statusCode = response.statusCode;
      switch (statusCode) {
        case 400:
          log('Invalid email or password');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
              title: const Text('Failed'),
              content: const Text('Invalid email or password'),
              contentPadding: const EdgeInsets.all(20.0),
            ),
          );
          log(response.reasonPhrase.toString());
          break;
        case 422:
          log('Email is already exist');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
              title: const Text('Failed'),
              content: const Text('Your email is already exist'),
              contentPadding: const EdgeInsets.all(20.0),
            ),
          );
          log(response.reasonPhrase.toString());

          break;
        default:
          log(response.reasonPhrase.toString());
          log(response.statusCode.toString());
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameCtrl = TextEditingController();
    final TextEditingController emailCtrl = TextEditingController();
    final TextEditingController passwordCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.inverseTextColor,
        title: const Text('Jarvis Register'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text('Welcome to Jarvis!'),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: usernameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextFormField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          signUp(
                            context,
                            emailCtrl.text,
                            usernameCtrl.text,
                            passwordCtrl.text,
                          );
                        },
                        child: const Text('Register'),
                      ),
                    ),
                    const Text('Or login with existing account:'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.loginGmail);
                            },
                            icon: Image.asset(
                              'assets/icon/google_icon.png',
                              height: 24.0,
                              width: 24.0,
                            ),
                            label: const Text('Google'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.homeChat);
                            },
                            label: const Text('Jarvis'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text('By continuing, you agree to our Privacy Policy'),
            ),
          ],
        ),
      ),
    );
  }
}
