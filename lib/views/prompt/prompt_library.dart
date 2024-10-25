import 'package:final_project/consts/app_color.dart';
import 'package:final_project/widgets/new_prompt_dialog.dart';
import 'package:flutter/material.dart';

class PromptLibrary extends StatefulWidget {
  const PromptLibrary({super.key});

  @override
  _PromptLibraryState createState() => _PromptLibraryState();
}

class _PromptLibraryState extends State<PromptLibrary>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> myPrompts = ['11AA11', 'ABCD', 'LTP'];
  final List<String> publicPrompts = [
    'Grammar corrector',
    'Learn Code FAST!',
    'Story generator',
    'Essay improver'
  ];
  final List<String> publicPromptDescriptions = [
    'Improve your spelling and grammar by correcting errors in your writing.',
    'Teach you the code with the most understandable knowledge.',
    'Write your own beautiful story.',
    'Improve your content\'s effectiveness with ease.'
  ];

  final List<String> categories = ['All', 'Marketing', 'Business', 'SEO'];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'Prompt Library',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return NewPromptDialog();
                },
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'My Prompts'),
            Tab(text: 'Public Prompts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildMyPromptsList(),
          buildPublicPromptsList(),
        ],
      ),
    );
  }

  Widget buildMyPromptsList() {
    return ListView.builder(
      itemCount: myPrompts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(myPrompts[index]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildPublicPromptsList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: publicPrompts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(publicPrompts[index],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(publicPromptDescriptions[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.star_border),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
