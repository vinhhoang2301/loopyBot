import 'package:final_project/consts/app_color.dart';
import 'package:flutter/material.dart';

class UpdateAccount extends StatelessWidget {
  const UpdateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Jarvis Premium',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Feature list
            const ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Unlimited queries per month'),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('AI Chat Models'),
              subtitle:
                  Text('GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra'),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Jira Copilot Assistant'),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('No request limits during high-traffic'),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('2X faster response speed'),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Priority email support'),
            ),

            const SizedBox(height: 24),

            TextButton(
              onPressed: () {},
              child: const Text(
                'Restore subscription',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Auto-renews for 500.000 đ/month until canceled',
            ),

            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: Text(
                'Subcribe',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 100.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
