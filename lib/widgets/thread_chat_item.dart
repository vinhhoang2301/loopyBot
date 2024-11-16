import 'package:final_project/consts/app_color.dart';
import 'package:final_project/views/chats/main_thread_chat.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ThreadChatItem extends StatelessWidget {
  const ThreadChatItem({
    super.key,
    required this.id,
    required this.title,
    required this.createAt,
  });

  final String id;
  final String title;
  final int createAt;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor2,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainThreadChatPage(conversationId: id),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        subtitle: Align(
          alignment: Alignment.centerRight,
          child: Text(
            timeAgo(createAt),
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  String timeAgo(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    timeago.setLocaleMessages('vi', timeago.ViMessages());
    return timeago.format(dateTime, locale: 'us');
  }
}
