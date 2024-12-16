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
import '../../widgets/material_button_custom_widget.dart';

class KBPage extends StatefulWidget {
  const KBPage({super.key});

  @override
  State<KBPage> createState() => _KBPage();
}

class _KBPage extends State<KBPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  Map<String, bool> deleteLoadingStates = {};
  List<KbModel>? allKnowledge = [];
  List<KbModel>? filteredKnowledge = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();

    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
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
                style: const TextStyle(
                  color: Colors.black,
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
        return kbItem.kbId != null
            ? KBItem(
                createdAt: createdAt,
                kbName: kbItem.knowledgeName!,
                id: kbItem.kbId!,
                delete: () => deleteKnowledge(context, id: kbItem.kbId!),
                isDeleteLoading: deleteLoadingStates[kbItem.kbId!] ?? false,
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

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        filteredKnowledge = allKnowledge;
      } else {
        filteredKnowledge = allKnowledge?.where((knowledge) {
          final name = knowledge.knowledgeName?.toLowerCase() ?? '';
          return name.contains(query);
        }).toList();
      }
    });
  }

  Future<void> deleteKnowledge(BuildContext context,
      {required String id}) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text(
              'Are you sure you want to delete this Knowledge Base?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !context.mounted) return;

    setState(() => deleteLoadingStates[id] = true);

    final result = await KbService.deleteKnowledge(
      context: context,
      id: id,
    );

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(result ? 'Success' : 'Failed'),
          content: Text(result
              ? 'Knowledge Base deleted successfully'
              : 'Failed to delete Knowledge Base. Please try again.'),
          actions: [
            MaterialButtonCustomWidget(
              padding: const EdgeInsets.symmetric(vertical: 6),
              onPressed: () async {
                Navigator.of(context).pop();
                if (result) {
                  setState(() => isLoading = true);
                  await fetchAllKnowledge();
                  setState(() => isLoading = false);
                }
              },
              title: 'Close',
            )
          ],
        );
      },
    );

    setState(() => deleteLoadingStates[id] = false);
  }
}
