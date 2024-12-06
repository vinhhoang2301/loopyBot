import 'package:final_project/consts/app_color.dart';
import 'package:flutter/material.dart';

class ChatbotAIItem extends StatelessWidget {
  const ChatbotAIItem({
    super.key,
    required this.chatbotName,
    required this.createdAt,
  });

  final String chatbotName;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondaryColor.withOpacity(0.7),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/unnamed.jpeg',
              height: 64,
              width: 64,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          chatbotName,
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const Icon(Icons.access_time_outlined),
                      const SizedBox(width: 8),
                      Text('${createdAt.month}/${createdAt.day}/${createdAt.year}'),
                      const Spacer(),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.star_border_outlined),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
