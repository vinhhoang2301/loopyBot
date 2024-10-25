import 'package:final_project/consts/app_color.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:final_project/views/knowledge_base/add_unit_kb_page.dart';
import 'package:final_project/widgets/kb_details_item.dart';
import 'package:flutter/material.dart';

class KbDetailsPage extends StatefulWidget {
  const KbDetailsPage({super.key});

  @override
  State<KbDetailsPage> createState() => _KbDetailsPageState();
}

class _KbDetailsPageState extends State<KbDetailsPage> {
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
      body: ListView(
        children: const [
          KbDetailsItem(),
          KbDetailsItem(),
          KbDetailsItem(),
          KbDetailsItem(),
          KbDetailsItem(),
          KbDetailsItem(),
          KbDetailsItem(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Utils.showBottomSheet(
            context,
            sheet: const AddUnitKBPage(),
            showFullScreen: true,
          );
        },
        tooltip: 'Add Knowledge Base',
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.inverseTextColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
