import 'dart:developer';

import 'package:final_project/consts/app_color.dart';
import 'package:final_project/widgets/new_prompt_dialog.dart';
import 'package:final_project/widgets/update_prompt_dialog.dart';
import 'package:flutter/material.dart';
import 'package:final_project/services/prompt_service.dart';
import 'package:final_project/models/prompt_model.dart';

class PromptLibrary extends StatefulWidget {
  const PromptLibrary({super.key});

  @override
  _PromptLibraryState createState() => _PromptLibraryState();
}

class _PromptLibraryState extends State<PromptLibrary>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<PromptModel> publicPrompts = [];
  List<PromptModel> filteredPrompts = [];
  List<PromptModel> myPrompts = [];
  List<PromptModel> filteredMyPrompts = [];
  bool isLoading = true;
  bool isFavorite = false;
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

  Future<void> fetchPrompts({
    PromptCategory category = PromptCategory.all,
    String searchQuery = '',
    bool isFavorite = false,
  }) async {
    setState(() {
      isLoading = true;
    });

    try {
      List<PromptModel> prompts = await PromptService().fetchPrompts(
        context,
        category: category,
        searchQuery: searchQuery,
        isFavorite: isFavorite,
        isPublic: true,
      );

      setState(() {
        publicPrompts = prompts;
        filteredPrompts = prompts;
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchPrivatePrompts({
    PromptCategory category = PromptCategory.all,
    String searchQuery = '',
    bool isFavorite = false,
  }) async {
    setState(() {
      isLoading = true;
    });

    try {
      List<PromptModel> prompts = await PromptService().fetchPrompts(
        context,
        category: category,
        searchQuery: searchQuery,
        isFavorite: isFavorite,
        isPublic: false,
      );

      setState(() {
        myPrompts = prompts;
        filteredMyPrompts = prompts;
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  void filterPrompts() {
    fetchPrompts(
      category: selectedCategory,
      searchQuery: searchQuery,
      isFavorite: isFavorite,
    );

    fetchPrivatePrompts(
      category: selectedCategory,
      searchQuery: searchQuery,
      isFavorite: isFavorite,
    );
  }

  void addPrompt() {
    showDialog(
      context: context,
      builder: (context) => NewPromptDialog(),
    ).then((value) {
      if (value == true) {
        fetchPrivatePrompts();
      }
    });
  }

  void deletePrompt(String promptId) {
    PromptService().deletePrivatePrompt(context, promptId).then(
          (_) => fetchPrivatePrompts(),
        );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search...',
          hintStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: const TextStyle(color: Colors.black),
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
                selectedColor: AppColors.secondaryColor,
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

  Widget buildFavoriteCheckbox() {
    return ListTile(
      title: const Text('Favorites'),
      trailing: Icon(
        isFavorite ? Icons.star : Icons.star_border,
        color: isFavorite ? Colors.yellow : null,
      ),
      onTap: () {
        setState(() {
          isFavorite = !isFavorite;
          filterPrompts();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Library'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.inverseTextColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: addPrompt,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.inverseTextColor,
          indicatorColor: AppColors.inverseTextColor,
          tabs: const [
            Tab(text: 'My Prompts'),
            Tab(text: 'Public Prompts'),
          ],
        ),
      ),
      body: Column(
        children: [
          buildSearchBar(),
          buildCategorySelection(),
          buildFavoriteCheckbox(),

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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: filteredMyPrompts.length,
      itemBuilder: (context, index) {
        PromptModel prompt = filteredMyPrompts[index];
        return ListTile(
          title: Text(
            prompt.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(prompt.description),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  prompt.isFavorite ? Icons.star : Icons.star_border,
                  color: prompt.isFavorite ? Colors.yellow : null,
                ),
                onPressed: () async {
                  setState(() {
                    prompt.isFavorite = !prompt.isFavorite;
                  });
                  if (prompt.isFavorite) {
                    await PromptService().addFavoritePrompt(context, prompt.id);
                  } else {
                    await PromptService()
                        .removeFavoritePrompt(context, prompt.id);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  bool? result = await showDialog(
                    context: context,
                    builder: (context) {
                      return EditPromptDialog(prompt: prompt);
                    },
                  );
                  if (result == true) {
                    fetchPrivatePrompts();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  deletePrompt(prompt.id);
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.of(context).pop(prompt.content);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildPublicPromptsList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: filteredPrompts.length,
      itemBuilder: (context, index) {
        PromptModel prompt = filteredPrompts[index];
        
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.grey,
            ),
          ),
          child: ListTile(
            title: Text(
              prompt.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(prompt.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    prompt.isFavorite ? Icons.star : Icons.star_border,
                    color: prompt.isFavorite ? Colors.yellow : null,
                  ),
                  onPressed: () async {
                    setState(() {
                      prompt.isFavorite = !prompt.isFavorite;
                    });
                    if (prompt.isFavorite) {
                      await PromptService().addFavoritePrompt(context, prompt.id);
                    } else {
                      await PromptService()
                          .removeFavoritePrompt(context, prompt.id);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.of(context).pop(prompt.content);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
