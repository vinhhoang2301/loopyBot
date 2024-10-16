import 'package:flutter/material.dart';

class ThreadChatItem extends StatelessWidget {
  const ThreadChatItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Title'),
              Text('6 days ago'),
            ],
          ),
          Text('Hello! It looks like your message got cut off. What happened'),
        ],
      ),
    );
  }
}
