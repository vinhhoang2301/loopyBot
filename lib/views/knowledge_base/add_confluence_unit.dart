import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../consts/app_routes.dart';
import '../../services/kb_unit_service.dart';

class AddConfluenceUnit extends StatefulWidget {
  const AddConfluenceUnit({
    super.key,
    required this.id,
  });
  final String id;

  @override
  State<AddConfluenceUnit> createState() => _AddConfluenceUnitState();
}

class _AddConfluenceUnitState extends State<AddConfluenceUnit> {
  late final String _kbId;

  final unitNameCtrl = TextEditingController();
  final wikiPageUrlCtrl = TextEditingController();
  final confluenceUsernameCtrl = TextEditingController();
  final confluenceAccessTokenCtrl = TextEditingController();
  final connectConfluenceUrl =
      'https://jarvis.cx/help/knowledge-base/connectors/confluence';

  bool isLoading = false;

  void createConfluenceUnit() async {
    if (isLoading) return;

    try {
      setState(() {
        isLoading = true;
      });

      var result = await KbUnitService.createConfluenceUnit(
        context: context,
        unitName: unitNameCtrl.text.trim(),
        wikiPageUrl: wikiPageUrlCtrl.text.trim(),
        confluenceUsername: confluenceUsernameCtrl.text.trim(),
        confluenceAccessToken: confluenceAccessTokenCtrl.text.trim(),
        id: _kbId,
      );

      unitNameCtrl.clear();
      wikiPageUrlCtrl.clear();
      confluenceUsernameCtrl.clear();
      confluenceAccessTokenCtrl.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result != null
                  ? 'Confluence unit created successfully!'
                  : 'Confluence unit created failed',
            ),
            backgroundColor: result != null ? Colors.green : Colors.red,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (err) {
      log('Error when adding Confluence unit: ${err.toString()}');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
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
        // bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add Confluence Unit',
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
              labelText: 'confluence-unit-name',
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
                  text: 'Wiki Page URL',
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
            controller: wikiPageUrlCtrl,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: 'wiki-page-url',
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
                  text: 'Confluence Username',
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
            controller: confluenceUsernameCtrl,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: 'confluence-username',
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
                  text: 'Confluence Access Token',
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
            controller: confluenceAccessTokenCtrl,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: 'confluence-access-token',
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
                  onPressed: isLoading ? null : createConfluenceUnit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('OK'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse(connectConfluenceUrl))) {
                  await launchUrl(Uri.parse(connectConfluenceUrl));
                } else {
                  throw 'Could not launch $connectConfluenceUrl';
                }
              },
              child: const Text('How to connect to Confluence?'),
            ),
          ),
        ],
      ),
    );
  }
}
