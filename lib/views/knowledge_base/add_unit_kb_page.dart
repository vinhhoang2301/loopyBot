import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:final_project/consts/api.dart';
import 'package:final_project/views/knowledge_base/add_confluence_unit.dart';
import 'package:final_project/views/knowledge_base/add_slack_unit.dart';
import 'package:final_project/views/knowledge_base/add_website_unit.dart';
import 'package:flutter/material.dart';

import '../../utils/global_methods.dart';
import 'package:http/http.dart' as http;

class AddUnitKBPage extends StatefulWidget {
  const AddUnitKBPage({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<AddUnitKBPage> createState() => _AddUnitKBPageState();
}

class _AddUnitKBPageState extends State<AddUnitKBPage> {
  String? _selectedValue;
  late final String _kbId;

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
                'Add Unit',
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
          Flexible(
            flex: 10,
            child: ListView(
              // shrinkWrap: true,
              children: [
                _buildOption(
                    context, 'assets/icon/document.png', 'Local files'),
                _buildOption(context, 'assets/icon/web.png', 'Website'),
                _buildOption(
                    context, 'assets/icon/github.png', 'Github repositories'),
                _buildOption(
                    context, 'assets/icon/gitlab.png', 'Gitlab repositories'),
                _buildOption(
                    context, 'assets/icon/google-drive.png', 'Google drive'),
                _buildOption(context, 'assets/icon/slack.png', 'Slack'),
                _buildOption(
                    context, 'assets/icon/confluence.png', 'Confluence'),
                _buildOption(context, 'assets/icon/jira.png', 'Jira'),
                _buildOption(context, 'assets/icon/hubspot.png', 'Hubspot'),
                _buildOption(context, 'assets/icon/linear.png', 'Linear'),
                _buildOption(context, 'assets/icon/notion.png', 'Notion'),
              ],
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
                    if (_selectedValue == 'Local files') {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

                      if (result != null) {
                        File file = File(result.files.single.path!);
                        var headers = {
                          'x-jarvis-guid': '',
                          'Authorization': 'Bearer {{kb_token}}'
                        };
                        var request = http.Request(
                            'GET',
                            Uri.parse(
                                '$kbAPIUrl/kb-core/v1/knowledge?q&order=DESC&order_field=createdAt&offset&limit=20'));

                        request.headers.addAll(headers);

                        http.StreamedResponse response = await request.send();

                        if (response.statusCode == 200) {
                          print(await response.stream.bytesToString());
                        } else {
                          print(response.reasonPhrase);
                        }
                      } else {
                        // User canceled the picker
                      }
                    }

                    if (_selectedValue == 'Website') {
                      log('Knowledge base ID: $_kbId');
                      Utils.showBottomSheet(
                        context,
                        sheet: AddWebsiteUnit(
                          id: _kbId,
                        ),
                        showFullScreen: true,
                      );
                    }

                    if (_selectedValue == 'Slack') {
                      Utils.showBottomSheet(
                        context,
                        sheet: AddSlackUnit(
                          id: _kbId,
                        ),
                        showFullScreen: true,
                      );
                    }

                    if (_selectedValue == 'Confluence') {
                      Utils.showBottomSheet(
                        context,
                        sheet: AddConfluenceUnit(
                          id: _kbId,
                        ),
                        showFullScreen: true,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String iconPath,
    String title,
  ) {
    bool isSelected = _selectedValue == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedValue = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        ),
        child: RadioListTile(
          value: title,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value.toString();
            });
          },
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text('Connect $title to get data'),
          secondary: Image.asset(
            iconPath,
            width: 32,
            height: 32,
          ),
          selected: isSelected,
          activeColor: Colors.blue,
        ),
      ),
    );
  }
}
