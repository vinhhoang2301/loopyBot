import 'dart:developer';

import 'package:final_project/consts/app_color.dart';
import 'package:final_project/consts/app_routes.dart';
import 'package:final_project/providers/auth_provider.dart';
import 'package:final_project/views/chatbot_ai/chatbot_ai_page.dart';
import 'package:final_project/views/chats/main_thread_chat.dart';
import 'package:final_project/views/knowledge_base/kb_details_page.dart';
import 'package:final_project/views/knowledge_base/kb_page.dart';
import 'package:final_project/views/login/login_page.dart';
import 'package:final_project/views/prompt/prompt_library.dart';
import 'package:final_project/views/user_info/update_account.dart';
import 'package:final_project/views/user_info/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:final_project/views/authentication/register_page.dart';
import 'package:final_project/views/authentication/login_gmail_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor1,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.inverseTextColor),
          bodyMedium: TextStyle(color: AppColors.defaultTextColor),
        ),
      ),
      // Start with the RegisterPage
      initialRoute: AppRoutes.loginPage,
      debugShowCheckedModeBanner: false,
      routes: {
        AppRoutes.homeChat: (_) => const MainThreadChatPage(),
        AppRoutes.chatBotAI: (_) => const ChatbotAIPage(),
        AppRoutes.knowledgeBase: (_) => const KBPage(),
        AppRoutes.register: (_) => const RegisterPage(),
        AppRoutes.loginGmail: (_) => const LoginGmailPage(),
        AppRoutes.userProfile: (_) => const UserProfile(),
        AppRoutes.kbDetails: (_) => const KbDetailsPage(),
        AppRoutes.promptPage: (_) => const PromptLibrary(),
        AppRoutes.updateAccount: (_) => const UpdateAccount(),
        AppRoutes.loginPage: (_) => const LoginPage(),
      },
    );
  }
}
