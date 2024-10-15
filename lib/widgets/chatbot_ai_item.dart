import 'package:flutter/material.dart';

class ChatbotAIItem extends StatelessWidget {
  const ChatbotAIItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          Image.asset(
            'assets/unnamed.jpeg',
            height: 100,
            width: 100,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'chatbot name',
                        style: TextStyle(fontSize: 18),
                      ),
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.access_time_outlined),
                      SizedBox(width: 8),
                      Text('15/11/2024'),
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
