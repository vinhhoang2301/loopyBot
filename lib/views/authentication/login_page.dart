import 'package:final_project/consts/app_color.dart';
import 'package:final_project/consts/app_routes.dart';
import 'package:final_project/services/authen_service.dart';
import 'package:final_project/widgets/material_button_custom_widget.dart';
import 'package:final_project/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final secureStorage = const FlutterSecureStorage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  String? emailError;
  String? passwordError;

  bool isLoading = false;

  @override
  void initState() {
    emailFocus.addListener(() => setState(() {}));
    passwordFocus.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor1,
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
                  CustomTextField(
                    controller: emailController,
                    hintText: 'Email',
                    focusNode: emailFocus,
                    errorText: emailError,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    focusNode: passwordFocus,
                    obscureText: true,
                    errorText: passwordError,
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
                    onPressed: isLoading
                        ? () {}
                        : () async {
                            _validateUserInfo();

                            if (emailError == null && passwordError == null) {
                              signIn(
                                context,
                                emailController.text,
                                passwordController.text,
                              );
                            }
                          },
                    content: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.inverseTextColor,
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(color: AppColors.inverseTextColor),
                          ),
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
                        onTap: () => Navigator.pushReplacementNamed(
                            context, AppRoutes.register),
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
    emailFocus.unfocus();
    passwordFocus.unfocus();

    setState(() {
      emailError = !isValidEmail(emailController.text)
          ? 'Email phải chứa ký tự @'
          : null;

      passwordError = !isValidPassword(passwordController.text)
          ? 'Mật khẩu phải có ít nhất 8 ký tự, chứa chữ hoa và ký tự đặc biệt'
          : null;
    });
  }

  Future<void> signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    setState(() => isLoading = true);

    final result = await AuthenticationService.signIn(
      context: context,
      email: email,
      password: password,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.isEmpty ? 'Sign In Successfully!' : result,
          ),
          backgroundColor: result.isEmpty ? Colors.green : Colors.red,
        ),
      );

      if(result.isEmpty) Navigator.of(context).pushReplacementNamed(AppRoutes.homeChat);
    }

    setState(() => isLoading = false);
  }

  void signInWithGoogle() async {
    await AuthenticationService.loginViaGoogle(context: context);
  }

  // void _initRefreshToken() async {
  //   String? refreshToken = await getRefreshToken();
  //   log('Refresh Token: ${refreshToken.toString()}');
  //
  //   if (refreshToken != null && refreshToken.isNotEmpty) {
  //     var headers = {'x-jarvis-guid': ''};
  //     var request = http.Request(
  //         'GET',
  //         Uri.parse(
  //             '$devServer/api/v1/auth/refresh?refreshToken=$refreshToken'));
  //     request.headers.addAll(headers);
  //     http.StreamedResponse response = await request.send();
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final result = jsonDecode(await response.stream.bytesToString());
  //       final accessToken = result[TOKEN][ACCESS_TOKEN];
  //
  //       log('access token: $accessToken');
  //
  //       context.read<AuthenticationProvider>().setTokens(
  //             accessToken: accessToken,
  //             refreshToken: '',
  //           );
  //     } else {
  //       log(response.reasonPhrase.toString());
  //     }
  //
  //     Navigator.of(context).pushReplacementNamed(AppRoutes.homeChat);
  //   }
  // }

  Future<String?> getRefreshToken() async {
    final res = await secureStorage.read(key: 'refreshToken');
    return res;
  }
}
