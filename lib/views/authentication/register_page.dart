//import 'package:final_project/views/gmail_login.dart';
import 'package:final_project/views/chats/main_thread_chat.dart';
import 'package:flutter/material.dart';
import 'package:final_project/consts/app_color.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.inverseTextColor,
        title: const Text('Jarvis Register'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Google Sign-in Button
            Container(
              padding: const EdgeInsets.all(16.0),
              
              child: const Text('Welcome to Jarvis!'),
            ),
            const SizedBox(height: 20), // Spacing between buttons and form
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                // Add form validation logic here
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 20), // Spacing between form fields and button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MainThreadChat()),
                        );
                      },
                      child: const Text('Register'),
                      ),
                    ),                
                    const Text('Or login with existing account:'), // Add a line with "Or"                  
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MainThreadChat()),
                            );
                          },
                          icon: Image.asset(
                          'assets/icon/google_icon.png',
                          height: 24.0, // Adjust the height as needed
                          width: 24.0,  // Adjust the width as needed
                          ),
                          label: const Text('Google'),
                        ),
                        
                      ),
                      const SizedBox(width: 10), // Spacing between buttons
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MainThreadChat()),
                            );
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
            const SizedBox(height: 20), // Spacing between form and footer
            const Center(
              child: Text('By continuing, you agree to our Privacy Policy'),
            ),
          ],
        ),
      ),
    );
  }
}