import 'dart:convert';
import 'dart:developer';

import 'package:final_project/services/kb_unit_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../consts/app_routes.dart';

class AddWebsiteUnit extends StatefulWidget {
  const AddWebsiteUnit({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<AddWebsiteUnit> createState() => _AddWebsiteUnitState();
}

class _AddWebsiteUnitState extends State<AddWebsiteUnit> {
  final unitNameCtrl = TextEditingController();
  final webUrlCtrl = TextEditingController();
  late final String kbId;

  @override
  void initState() {
    kbId = widget.id;
    super.initState();
  }

  void createWebsiteUnit() async {
    var result = await KbUnitService.createWebsiteUnit(
      context: context,
      unitName: unitNameCtrl.text.trim(),
      webUrl: webUrlCtrl.text.trim(),
      id: kbId,
    );

    unitNameCtrl.clear();
    webUrlCtrl.clear();

    if (result != null) {
      log('Success');
      Navigator.of(context).pushReplacementNamed(AppRoutes.kbDetails);
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
                'Add Website Unit',
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
              labelText: 'Ex: Jarvis Website',
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
                  text: 'Web URL',
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
            controller: webUrlCtrl,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: 'https://jarvis.cx/',
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
                    createWebsiteUnit();
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
