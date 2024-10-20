import 'package:final_project/consts/app_color.dart';
import 'package:flutter/material.dart';

class CreateNewPassword extends StatelessWidget {
  CreateNewPassword({super.key});

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void resetPassword() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_back),
                          SizedBox(width: 10.0),
                          Text('Back'),
                        ],
                      ),
                      Icon(Icons.info_outline),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  const Text(
                    'Create new password',
                    style: TextStyle(
                      fontSize: 32.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your new password must be different from previous used passwords.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'New password',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: false,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: 'Confirm your password',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Confirm password',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: false,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: 'Confirm your new password',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: resetPassword,
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      margin: const EdgeInsets.symmetric(horizontal: 25.0),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Center(
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
