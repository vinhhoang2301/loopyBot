import 'package:final_project/consts/app_color.dart';
import 'package:final_project/consts/app_routes.dart';
import 'package:final_project/widgets/material_button_custom_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showAuthButtons = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icon/app_icon.png',
                  height: 200,
                ),
                const SizedBox(height: 16),
                const Text(
                  'LoopyBot',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 64),
                if (!_showAuthButtons)
                  MaterialButtonCustomWidget(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    onPressed: () => setState(() => _showAuthButtons = true),
                    content: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Start',
                          style: TextStyle(
                            color: AppColors.inverseTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(width: 48),
                        Icon(
                          Icons.chevron_right_sharp,
                          color: AppColors.inverseTextColor,
                          size: 24,
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButtonCustomWidget(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 12.0,
                        ),
                        onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.register),
                        content: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColors.inverseTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 16),
                            Icon(
                              Icons.app_registration,
                              color: AppColors.inverseTextColor,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                      MaterialButtonCustomWidget(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 12.0,
                        ),
                        onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.loginPage),
                        content: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Sign In',
                              style: TextStyle(
                                color: AppColors.inverseTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 16),
                            Icon(
                              Icons.login,
                              color: AppColors.inverseTextColor,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
