import 'package:final_project/widgets/thread_chat_item.dart';
import 'package:flutter/material.dart';

class HistoryThreadChatPage extends StatefulWidget {
  const HistoryThreadChatPage({super.key});

  @override
  State<HistoryThreadChatPage> createState() => _HistoryThreadChatPageState();
}

class _HistoryThreadChatPageState extends State<HistoryThreadChatPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 48,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Conversation History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          // todo: refactor this row
          Row(
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Enter text',
                    suffixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.star_border_outlined,
                      size: 28,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete_outline_outlined,
                      size: 28,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: const [
                ThreadChatItem(),
                ThreadChatItem(),
                ThreadChatItem(),
                ThreadChatItem(),
                ThreadChatItem(),
                ThreadChatItem(),
                ThreadChatItem(),
                ThreadChatItem(),
                ThreadChatItem(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
