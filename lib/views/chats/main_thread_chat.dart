import 'package:final_project/consts/app_color.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/chats/history_thread_chats.dart';
import 'package:final_project/views/knowledge_base/add_unit_kb_page.dart';
import 'package:final_project/widgets/dropdown_model_ai.dart';
import 'package:final_project/widgets/tab_bar_widget.dart';
import 'package:final_project/widgets/input_image_item.dart';
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
        title: const Text(
          'Main Chat',
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.inverseTextColor,
      ),
      // drawer: const Drawer(),
      drawer: const TabBarWidget(),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department_rounded),
                          const SizedBox(width: 4),
                          Text(
                            '30',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'History',
                          onPressed: () {
                            Utils.showBottomSheet(
                              context,
                              sheet: const HistoryThreadChatPage(),
                              showFullScreen: true,
                            );
                          },
                          icon: const Icon(
                            Icons.access_time_outlined,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        IconButton(
                          tooltip: 'New Conversation',
                          onPressed: () {
                            Utils.showBottomSheet(
                              context,
                              sheet: const AddUnitKBPage(),
                              showFullScreen: true,
                            );
                          },
                          icon: const Icon(
                            Icons.add_comment,
                            color: AppColors.primaryColor,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.backgroundColor2,
                      width: 2.0,
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
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.image,
                                  color: AppColors.primaryColor,
                                ),
                                onPressed: () {
                                  Utils.showBottomSheet(
                                  context,
                                  sheet: const InputImage(),
                                  showFullScreen: true,
                                );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: AppColors.primaryColor,
                                ),
                                onPressed: () {},
                              ),
                            ],
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
