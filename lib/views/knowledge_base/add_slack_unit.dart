import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../consts/app_routes.dart';
import '../../services/kb_unit_service.dart';

class AddSlackUnit extends StatefulWidget {
  const AddSlackUnit({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<AddSlackUnit> createState() => _AddSlackUnitState();
}

class _AddSlackUnitState extends State<AddSlackUnit> {
  final unitNameCtrl = TextEditingController();
  final slackWorkspaceCtrl = TextEditingController();
  final slackBotTokenCtrl = TextEditingController();
  late final String _kbId;
  final connectSlackUrl =
      'https://jarvis.cx/help/knowledge-base/connectors/slack/';

  void createSlackUnit() async {
    var result = await KbUnitService.createSlackUnit(
      context: context,
      unitName: unitNameCtrl.text.trim(),
      slackWorkspace: slackWorkspaceCtrl.text.trim(),
      slackBotToken: slackBotTokenCtrl.text.trim(),
      id: _kbId,
    );

    unitNameCtrl.clear();
    slackWorkspaceCtrl.clear();
    slackBotTokenCtrl.clear();

    if (result != null) {
      log('Success');
      Navigator.of(context).pushReplacementNamed(AppRoutes.kbDetails);
    } else {
      log('Failed');
    }
  }

  @override
  void initState() {
    _kbId = widget.id;
    super.initState();
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
              const Text(
                'Add Slack Unit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          RichText(
            text: const TextSpan(
              text: '* ',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'Unit Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: unitNameCtrl,
            decoration: InputDecoration(
              labelText: 'slack-unit-name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            text: const TextSpan(
              text: '* ',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'Slack Workspace',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: slackWorkspaceCtrl,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: 'slack-workspace',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            text: const TextSpan(
              text: '* ',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'Slack Bot Token',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: slackBotTokenCtrl,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: 'slack-bot-token',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    createSlackUnit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (await canLaunchUrl(Uri.parse(connectSlackUrl))) {
                await launchUrl(Uri.parse(connectSlackUrl));
              } else {
                throw 'Could not launch $connectSlackUrl';
              }
            },
            child: const Text('How to connect to Slack?'),
          ),
        ],
      ),
    );
  }
}
