import 'dart:developer';

import 'package:final_project/consts/app_color.dart';
import 'package:final_project/models/kb_model.dart';
import 'package:final_project/services/kb_service.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/empty_page.dart';
import 'package:final_project/views/knowledge_base/add_kb_page.dart';
import 'package:final_project/widgets/kb_item.dart';
import 'package:final_project/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';

import '../../services/authen_service.dart';
import '../../services/kb_authen_service.dart';

class KBPage extends StatefulWidget {
  const KBPage({super.key});

  @override
  State<KBPage> createState() => _KBPage();
}

class _KBPage extends State<KBPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<KbModel>? allKnowledge = [];
  List<KbModel>? filteredKnowledge = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();

    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.unfocus();
    super.dispose();
  }

  Future<void> signIn() async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    if (mounted) {
      await KBAuthService.signInFromExternalClient(context,
          accessToken: accessToken);
    }
  }

  Future<void> fetchAllKnowledge() async {
    final allKnowledgeBase = await KbService.getAllKnowledge(context: context);

    allKnowledge = allKnowledgeBase;
    filteredKnowledge = allKnowledgeBase;
  }

  Future<void> _initializeData() async {
    try {
      setState(() => isLoading = true);

      await signIn();
      await fetchAllKnowledge();
    } catch (err) {
      log('Error when Initialize Data in KB');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Knowledge Base'),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.inverseTextColor,
        ),
        drawer: const TabBarWidget(),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Search your Knowledge Base',
                  suffixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Utils.showBottomSheet(
              context,
              sheet: const AddKBPage(),
              showFullScreen: true,
            );
          },
          tooltip: 'Add Knowledge Base',
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.inverseTextColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.defaultTextColor,
        ),
      );
    }

    if (filteredKnowledge == null || filteredKnowledge!.isEmpty) {
      return const EmptyPage(content: 'No Knowledge Base. Let Create It');
    }

    return ListView.builder(
      itemCount: filteredKnowledge!.length,
      itemBuilder: (context, index) {
        final kbItem = filteredKnowledge![index];

        DateTime createdAt = DateTime.parse(kbItem.createdAt.toString());
        return kbItem.userId != null
            ? KBItem(
                userId: kbItem.userId!,
                createdAt: createdAt,
                kbName: kbItem.knowledgeName!,
                delete: () {},
              )
            : const SizedBox(
                height: 40,
                child: Text(
                  'Failed to get KB',
                  style: TextStyle(color: Colors.red),
                ),
              );
      },
    );
  }
}
