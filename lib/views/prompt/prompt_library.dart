import 'package:final_project/consts/app_color.dart';
import 'package:final_project/widgets/new_prompt_dialog.dart';
import 'package:flutter/material.dart';
import 'package:final_project/services/prompt_service.dart'; 
import 'package:final_project/models/prompt_model.dart'; 

class PromptLibrary extends StatefulWidget {
  const PromptLibrary({super.key});

  @override
  _PromptLibraryState createState() => _PromptLibraryState();
}

class _PromptLibraryState extends State<PromptLibrary> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<PromptModel> publicPrompts = [];
  List<PromptModel> filteredPrompts = [];
  List<PromptModel> myPrompts = [];
  bool isLoading = true;
  bool isFavourite = false;
  String searchQuery = '';
  PromptCategory selectedCategory = PromptCategory.all;
  List<PromptCategory> categories = PromptCategory.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchPrompts();
    fetchPrivatePrompts();
  }

  Future<void> fetchPrompts({PromptCategory category = PromptCategory.all, String searchQuery = '', bool isFavourite = false}) async {
    setState(() {
      isLoading = true;
    });

    try {
      List<PromptModel> prompts = await PromptService().fetchPrompts(context, category: category, searchQuery: searchQuery, isFavourite: isFavourite);
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

  Future<void> fetchPrivatePrompts() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<PromptModel> prompts = await PromptService().fetchPrivatePrompts(context);
      setState(() {
        myPrompts = prompts;
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
    fetchPrompts(category: selectedCategory, searchQuery: searchQuery, isFavourite: isFavourite);
  }

  void addPrompt() {
    showDialog(
      context: context,
      builder: (context) {
        return NewPromptDialog();
      },
    );
  }
  //3 widgets for prompt search 
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

  Widget buildFavouriteCheckbox() {
    return ListTile(
      title: Text('Favourites'),
      trailing: Icon(
        isFavourite ? Icons.star : Icons.star_border,
        color: isFavourite ? Colors.yellow : null,
      ),
      onTap: () {
        setState(() {
          isFavourite = !isFavourite;
          filterPrompts();
        });
      },
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
            onPressed: addPrompt,
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
          buildFavouriteCheckbox(),
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
  //2 widgets for private/public prompt list
  Widget buildMyPromptsList() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: myPrompts.length,
      itemBuilder: (context, index) {
        PromptModel prompt = myPrompts[index];
        return ListTile(
          title: Text(prompt.title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(prompt.description),
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
