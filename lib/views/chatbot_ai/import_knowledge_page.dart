import 'dart:developer';

import 'package:final_project/consts/app_color.dart';
import 'package:final_project/models/kb_model.dart';
import 'package:final_project/services/ai_assistant_service.dart';
import 'package:final_project/services/kb_service.dart';
import 'package:final_project/views/empty_page.dart';
import 'package:final_project/views/error_page.dart';
import 'package:final_project/widgets/kb_item.dart';
import 'package:flutter/material.dart';

class ImportKnowledgePage extends StatefulWidget {
  const ImportKnowledgePage({
    super.key,
    required this.assistantName,
    required this.assistantId,
  });

  final String assistantName;
  final String assistantId;

  @override
  State<ImportKnowledgePage> createState() => _ImportKnowledgePageState();
}

class _ImportKnowledgePageState extends State<ImportKnowledgePage> {
  final kbNameCtrl = TextEditingController();
  final kbDescCtrl = TextEditingController();

  bool isLoading = false;
  Map<String, bool> loadingState = {};
  List<KbModel>? knowledgeBases = [];

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  void createKnowledgeBase() async {
    var result = await KbService.createKnowledgeBase(
      context: context,
      kbName: kbNameCtrl.text.trim(),
      kbDesc: kbDescCtrl.text.trim(),
    );

    kbNameCtrl.clear();
    kbDescCtrl.clear();

    if (result != null) {
      log('Success');
    } else {
      log('Failed');
    }
  }

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
              Text(
                'Add New Knowledge Base to ${widget.assistantName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.clip,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(context).pop,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Current Knowledge Base',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: _buildContent(),
          ),
        ],
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

    if (knowledgeBases!.isEmpty) {
      return const Center(
        child: EmptyPage(content: 'No Knowledge Base. Let Create It'),
      );
    }

    if (knowledgeBases == null) {
      return const Center(
        child: ErrorPage(content: 'Something went wrong. Please try again'),
      );
    }

    return ListView.builder(
      itemCount: knowledgeBases!.length,
      itemBuilder: (context, index) {
        final kbItem = knowledgeBases![index];

        DateTime createdAt = DateTime.parse(kbItem.createdAt.toString());
        return kbItem.kbId != null
            ? KBItem(
                createdAt: createdAt,
                kbName: kbItem.knowledgeName!,
                id: kbItem.kbId!,
                firstAction: IconButton(
                  onPressed: () => importKnowledgeToAssistant(
                    assistantId: widget.assistantId,
                    knowledgeId: kbItem.kbId!,
                  ),
                  icon: loadingState[kbItem.kbId] == true
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.add),
                ),
                delete: () {
                  // todo: need handle here
                },
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

  Future<void> fetchAllKnowledge() async {
    final allKnowledgeBase = await KbService.getAllKnowledge(context: context);
    knowledgeBases = allKnowledgeBase;
  }

  Future<void> _initializeData() async {
    try {
      setState(() => isLoading = true);

      await fetchAllKnowledge();
    } catch (err) {
      log('Error when Initialize Data in KB');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> importKnowledgeToAssistant({
    required String assistantId,
    required String knowledgeId,
  }) async {
    final shouldImport = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Import'),
        content:
            const Text('Are you sure you want to import this knowledge base?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
            ),
            child: const Text('Import'),
          ),
        ],
      ),
    );

    if (shouldImport != true) return;
    setState(() => loadingState[knowledgeId] = true);

    if (!mounted) return;

    try {
      final result = await AiAssistantService.importKnowledgeToAssistant(
        context: context,
        assistantId: assistantId,
        knowledgeId: knowledgeId,
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              result ? 'Success' : 'Failed',
              style: TextStyle(
                color: result ? AppColors.primaryColor : Colors.red,
              ),
            ),
            content: Text(
              result
                  ? 'Knowledge base has been imported successfully'
                  : 'Failed to import knowledge base. Please try again.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error', style: TextStyle(color: Colors.red)),
            content: const Text(
                'An error occurred while importing. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } finally {
      setState(() => loadingState[knowledgeId] = false);
    }
  }
}
