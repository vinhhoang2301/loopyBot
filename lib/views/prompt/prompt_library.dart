import 'package:final_project/consts/app_color.dart';
import 'package:final_project/widgets/new_prompt_dialog.dart';
import 'package:flutter/material.dart';
import 'package:final_project/services/prompt_service.dart'; // Import the PromptService
import 'package:final_project/models/prompt_model.dart'; // Import the PromptModel

// Define a list of prompts
List<String> myPrompts = [
  'What is your name?',
  'How old are you?',
  'Where do you live?'
];

class PromptLibrary extends StatefulWidget {
  const PromptLibrary({super.key});

  @override
  _PromptLibraryState createState() => _PromptLibraryState();
}

class _PromptLibraryState extends State<PromptLibrary> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<PromptModel> publicPrompts = [];
  List<PromptModel> filteredPrompts = [];
  bool isLoading = true;
  String searchQuery = '';
  String selectedCategory = '';
  List<String> categories = ['All', 'business', 'coding', 'writing', 'productivity', 'education', 'seo', 'marketing', 'ai_painting', 'career'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchPrompts();
  }

  Future<void> fetchPrompts() async {
    try {
      List<PromptModel> prompts = await PromptService().fetchPrompts(context);
      setState(() {
        publicPrompts = prompts;
        filteredPrompts = prompts;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterPrompts() {
    setState(() {
      if (searchQuery.isEmpty && (selectedCategory == 'All' || selectedCategory.isEmpty)) {
        filteredPrompts = publicPrompts;
      } else {
        filteredPrompts = publicPrompts.where((prompt) {
          final matchesSearchQuery = prompt.title.toLowerCase().contains(searchQuery.toLowerCase()) || prompt.description.toLowerCase().contains(searchQuery.toLowerCase());
          final matchesCategory = selectedCategory == 'All' || prompt.category == selectedCategory;
          return matchesSearchQuery && matchesCategory;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
            child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.black), // Set hint text color to black
              border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: TextStyle(color: Colors.black), // Set typed text color to black
            onChanged: (value) {
              searchQuery = value;
              filterPrompts();
            },
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
                        filterPrompts();
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
            itemCount: filteredPrompts.length,
            itemBuilder: (context, index) {
              PromptModel prompt = filteredPrompts[index];
              return ListTile(
                title: Text(prompt.title, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(prompt.description),
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
