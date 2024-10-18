import 'package:final_project/consts/app_color.dart';
import 'package:final_project/consts/app_routes.dart';
import 'package:final_project/views/chatbot_ai/chatbot_ai_page.dart';
import 'package:final_project/views/chats/main_thread_chat.dart';
import 'package:final_project/views/knowledge_base/kb_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
      home: const MainThreadChat(),
      debugShowCheckedModeBanner: false,
      routes: {
        AppRoutes.homeChat: (_) => const MainThreadChat(),
        AppRoutes.chatBotAI : (_) => const ChatbotAIPage(),
        AppRoutes.knowledgeBase : (_) => const KBPage(),
      },
    );
  }
}
