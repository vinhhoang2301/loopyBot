import 'dart:developer';

import 'package:final_project/consts/app_color.dart';
import 'package:final_project/models/unit_model.dart';
import 'package:final_project/services/kb_service.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/knowledge_base/add_unit_kb_page.dart';
import 'package:final_project/widgets/kb_details_item.dart';
import 'package:flutter/material.dart';

import '../empty_page.dart';

class KbDetailsPage extends StatefulWidget {
  const KbDetailsPage({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<KbDetailsPage> createState() => _KbDetailsPageState();
}

class _KbDetailsPageState extends State<KbDetailsPage> {
  late final String _kbId;
  List<UnitModel>? allUnit = [];
  bool isLoading = false;

  @override
  void initState() {
    _kbId = widget.id;
    super.initState();
    _initializeData();
  }

  Future<void> fetchAllUnit() async {
    final allUnitFetched = await KbService.getAllUnit(
      context: context,
      id: _kbId,
    );

    allUnit = allUnitFetched;
  }

  Future<void> _initializeData() async {
    try {
      setState(() => isLoading = true);

      await fetchAllUnit();
    } catch (err) {
      log('Error when Initialize Data in KB');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.defaultTextColor,
        ),
      );
    }

    if (allUnit == null) {
      return const EmptyPage(content: 'No Unit. Let Create It');
    }

    return ListView.builder(
      itemCount: allUnit!.length,
      itemBuilder: (context, index) {
        final unitItem = allUnit![index];

        return unitItem.id != null
            ? KbDetailsItem(
                id: unitItem.id!,
                updatedAt: unitItem.updatedAt!,
                unitName: unitItem.name!,
                status: unitItem.status!,
                size: unitItem.size!,
                type: unitItem.type!,
              )
            : const SizedBox(
                height: 40,
                child: Text(
                  'Failed to get Unit',
                  style: TextStyle(color: Colors.red),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KB Details Name',
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.inverseTextColor,
      ),
      body: _buildContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Utils.showBottomSheet(
            context,
            sheet: AddUnitKBPage(
              id: _kbId,
            ),
            showFullScreen: true,
          );
        },
        tooltip: 'Add Unit',
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.inverseTextColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
