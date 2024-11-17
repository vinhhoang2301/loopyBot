import 'package:final_project/consts/app_color.dart';
import 'package:final_project/widgets/new_prompt_dialog.dart';
import 'package:flutter/material.dart';
import 'package:final_project/services/prompt_service.dart'; // Import the PromptService
import 'package:final_project/models/prompt_model.dart'; // Import the PromptModel
//Private prompts default
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
  PromptCategory selectedCategory = PromptCategory.all;
  List<PromptCategory> categories = PromptCategory.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchPrompts();
  }

  Future<void> fetchPrompts({PromptCategory category = PromptCategory.all, String searchQuery = ''}) async {
    setState(() {
      isLoading = true;
    });

    try {
      List<PromptModel> prompts = await PromptService().fetchPrompts(context, category: category, searchQuery: searchQuery);
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
    fetchPrompts(category: selectedCategory, searchQuery: searchQuery);
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.black), 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: TextStyle(color: Colors.black), 
        onChanged: (value) {
          searchQuery = value;
          filterPrompts();
        },
      ),
    );
  }

  Widget buildCategorySelection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(promptCategoryLabels[category]!),
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
    );
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
      body: Column(
        children: [
          buildSearchBar(),
          buildCategorySelection(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildMyPromptsList(),
                buildPublicPromptsList(),
              ],
            ),
          ),
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

    return ListView.builder(
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
                icon: Icon(
                  prompt.isFavourite ? Icons.star : Icons.star_border,
                  color: prompt.isFavourite ? Colors.yellow : null,
                ),
                onPressed: () async {
                  setState(() {
                    prompt.isFavourite = !prompt.isFavourite;
                  });
                  if (prompt.isFavourite) {
                    await PromptService().addFavouritePrompt(context, prompt.id);
                  } else {
                    // Add logic to remove from favorites if needed
                  }
                },
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
    );
  }
}
