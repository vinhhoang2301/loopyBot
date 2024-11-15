import 'package:final_project/consts/app_color.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ThreadChatItem extends StatelessWidget {
  const ThreadChatItem({
    super.key,
    required this.title,
    required this.createAt,
  });

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
        title: Text(title, style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),),
        subtitle: Text(
          timeAgo(createAt),
          style: TextStyle(
            color: Colors.grey[600],
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
