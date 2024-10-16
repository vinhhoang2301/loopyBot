import 'package:final_project/widgets/dropdown_model_ai.dart';
import 'package:flutter/material.dart';

class MainThreadChat extends StatefulWidget {
  const MainThreadChat({super.key});

  @override
  State<MainThreadChat> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainThreadChat> {
  final List<String> messages = ['hehe', 'hihi', 'huhu', 'haha'];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jarvis Chat'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const Drawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        messages[messages.length - 1 - index],
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Flexible(child: DropdownModelAI()),
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department_rounded),
                        const SizedBox(width: 4),
                        Text(
                          '30',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.access_time_outlined),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add_comment),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: 4,
                          expands: false,
                          onSubmitted: (value) {},
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Ask me anything',
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.settings_suggest_outlined),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
