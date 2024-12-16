import 'package:final_project/consts/app_color.dart';
import 'package:final_project/utils/global_methods.dart';
import 'package:flutter/material.dart';

class PublishResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final String assistantName;

  const PublishResultsPage({
    super.key,
    required this.results,
    required this.assistantName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publish Results for $assistantName'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.inverseTextColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryColor,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icon/congratulations.png',
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Publication submitted!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              itemCount: results.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final result = results[index];
                final String platform =
                    result['platform'].toString().capitalize();
                final bool isSuccess = result['success'];
        
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _PublishResultItem(
                    name: platform,
                    isSuccess: isSuccess,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.inverseTextColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Done'),
        ),
      ),
    );
  }
}

class _PublishResultItem extends StatelessWidget {
  const _PublishResultItem({
    required this.name,
    required this.isSuccess,
  });

  final String name;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    String asset;

    switch (name) {
      case 'Slack':
        asset = 'assets/icon/slack.png';
        break;
      case 'Telegram':
        asset = 'assets/icon/telegram.png';
        break;
      case 'Messenger':
        asset = 'assets/icon/messenger.png';
        break;
      default:
        asset = 'assets/icon/error.png';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.backgroundColor2,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(
                asset,
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isSuccess ? 'Success' : 'Fail',
              style: TextStyle(
                color: isSuccess ? Colors.green : Colors.red,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
