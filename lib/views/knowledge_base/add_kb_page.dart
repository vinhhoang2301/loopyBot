import 'dart:convert';
import 'dart:developer';

import 'package:final_project/consts/api.dart';
import 'package:final_project/services/kb_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../services/authen_service.dart';
import '../../services/kb_authen_service.dart';
import '../../widgets/material_button_custom_widget.dart';

class AddKBPage extends StatefulWidget {
  const AddKBPage({super.key});

  @override
  State<AddKBPage> createState() => _AddKBPageState();
}

class _AddKBPageState extends State<AddKBPage> {
  final kbNameCtrl = TextEditingController();
  final kbDescCtrl = TextEditingController();

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
              const Text(
                'Create New Knowledge Base',
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
                  text: 'Knowledge Base Name',
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
            controller: kbNameCtrl,
            decoration: InputDecoration(
              labelText: 'Ex: Knowledge 001',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Knowledge Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: kbDescCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description',
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
                    createKnowledgeBase();
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
        ],
      ),
    );
  }
}
