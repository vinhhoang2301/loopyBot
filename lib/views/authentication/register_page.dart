
import 'package:flutter/material.dart';
import 'package:final_project/consts/app_color.dart';
import 'package:final_project/consts/app_routes.dart';

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
                    const SizedBox(height: 20), 
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(AppRoutes.homeChat);
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
                            Navigator.of(context).pushReplacementNamed(AppRoutes.loginGmail);
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
                          Navigator.of(context).pushReplacementNamed(AppRoutes.homeChat);
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