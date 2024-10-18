import 'package:final_project/consts/app_routes.dart';
import 'package:flutter/material.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({super.key});

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Jarvis',
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
            ),
          ),
          Column(
            children: [
              _TabBarItem(
                onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.homeChat),
                itemName: 'Chat',
                iconPath: 'assets/icon/chat.png',
              ),
              _TabBarItem(
                onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.chatBotAI),
                itemName: 'Chatbot AI',
                iconPath: 'assets/icon/chatbot.png',
              ),
              _TabBarItem(
                onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.knowledgeBase),
                itemName: 'Knowledge Base',
                iconPath: 'assets/icon/kb.png',
              ),
            ],
          ),
          const Spacer(),
          const Divider(),
          Column(
            children: [
              _TabBarItem(
                onTap: () {},
                itemName: 'Profile',
                iconPath: 'assets/icon/profile.png',
              ),
              _TabBarItem(
                onTap: () {},
                itemName: 'Upgrade Account',
                iconPath: 'assets/icon/upgrade.png',
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _TabBarItem extends StatelessWidget {
  const _TabBarItem({
    required this.onTap,
    required this.itemName,
    required this.iconPath,
  });

  final Function() onTap;
  final String itemName;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        width: 28,
        height: 28,
      ),
      title: Text(
        itemName,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
