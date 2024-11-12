import 'dart:convert';
import 'dart:developer';

import 'package:final_project/consts/api.dart';
import 'package:flutter/material.dart';
import 'package:final_project/consts/app_color.dart';
import 'package:final_project/consts/app_routes.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                          // TODO: create function & check validate
                          var headers = {
                            'x-jarvis-guid': '',
                            'Content-Type': 'application/json'
                          };
                          var request = http.Request('POST',
                              Uri.parse('$devServer/api/v1/auth/sign-up'));
                          request.body = json.encode({
                            "email": emailCtrl.text.toString(),
                            "password": passwordCtrl.text.toString(),
                            "username": usernameCtrl.text.toString()
                          });
                          request.headers.addAll(headers);
                          log(request.body.toString());
                          http.StreamedResponse response = await request.send();

                          if (response.statusCode == 200 ||
                              response.statusCode == 201) {
                            // TODO: Show success dialog and require login to continue
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.loginPage);
                            log(await response.stream.bytesToString());
                          } else {
                            // TODO: Create error dialog
                            log(response.reasonPhrase.toString());
                            log(response.statusCode.toString());
                          }
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
