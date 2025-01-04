import 'package:final_project/services/authen_service.dart';
import 'package:final_project/widgets/material_button_custom_widget.dart';
import 'package:final_project/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:final_project/consts/app_color.dart';
import 'package:final_project/consts/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  String? emailError;
  String? passwordError;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const Text(
                  'Welcome to LoopyBot!',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: usernameCtrl,
                          hintText: 'Username',
                          prefixIcon: Icons.person,
                          focusNode: usernameFocusNode,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: emailCtrl,
                          hintText: 'Email',
                          prefixIcon: Icons.email,
                          focusNode: emailFocusNode,
                          errorText: emailError,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: passwordCtrl,
                          hintText: 'Password',
                          prefixIcon: Icons.lock,
                          obscureText: true,
                          focusNode: passwordFocusNode,
                          errorText: passwordError,
                        ),
                        const SizedBox(height: 48),
                        MaterialButtonCustomWidget(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          onPressed: isLoading
                              ? () {}
                              : () async {
                                  _validateUserInfo();

                                  if (emailError == null &&
                                      passwordError == null) {
                                    signUp(
                                      context: context,
                                      username: usernameCtrl.text.trim(),
                                      email: emailCtrl.text.trim(),
                                      password: passwordCtrl.text.trim(),
                                    );
                                  }
                                },
                          content: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      color: AppColors.inverseTextColor),
                                )
                              : const Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.inverseTextColor,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 48),
                        const Text('Or login with existing account:'),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: MaterialButtonCustomWidget(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(AppRoutes.loginGmail),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icon/google_icon.png',
                                      height: 24.0,
                                      width: 24.0,
                                    ),
                                    const SizedBox(width: 16),
                                    const Text(
                                      'Google',
                                      style: TextStyle(
                                        color: AppColors.inverseTextColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: MaterialButtonCustomWidget(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                onPressed: () => Navigator.of(context)
                                    .pushReplacementNamed(AppRoutes.loginPage),
                                content: const Text(
                                  'Loopy Bot',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.inverseTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text('By continuing, you agree to our Privacy Policy'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    return email.contains('@');
  }

  bool isValidPassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;

    return true;
  }

  void _validateUserInfo() {
    usernameFocusNode.unfocus();
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();

    setState(() {
      emailError =
          !isValidEmail(emailCtrl.text) ? 'Email phải chứa ký tự @' : null;

      passwordError = !isValidPassword(passwordCtrl.text)
          ? 'Mật khẩu phải có ít nhất 8 ký tự, chứa chữ hoa và ký tự đặc biệt'
          : null;
    });
  }

  Future<void> signUp({
    required BuildContext context,
    required String email,
    required String username,
    required String password,
  }) async {
    setState(() => isLoading = true);

    final result = await AuthenticationService.signUp(
      context: context,
      username: username,
      email: email,
      password: password,
    );

    if (result != null) {
      if (context.mounted) {
        setState(() => isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result ? 'Create LoopyBot Account successfully!' : 'Create LoopyBot Account failed',
            ),
            backgroundColor: result ? Colors.green : Colors.red,
          ),
        );

        Navigator.of(context).pushReplacementNamed(AppRoutes.loginPage);
      }
    }
  }
}
