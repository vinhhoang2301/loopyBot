import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:final_project/services/prompt_service.dart';

class NewPromptDialog extends StatefulWidget {
  const NewPromptDialog({super.key});

  @override
  _NewPromptDialogState createState() => _NewPromptDialogState();
}

class _NewPromptDialogState extends State<NewPromptDialog> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  String _title = '';
  String _prompt = '';
  bool _isPrivate = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'New Prompt',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Private'),
                    leading: Radio(
                      value: true,
                      groupValue: _isPrivate,
                      onChanged: (bool? value) {
                        setState(() => _isPrivate = value!);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Public'),
                    leading: Radio(
                      value: false,
                      groupValue: _isPrivate,
                      onChanged: (bool? value) {
                        setState(() => _isPrivate = value!);
                      },
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(labelText: 'Prompt'),
              onChanged: (value) {
                setState(() {
                  _prompt = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a prompt';
                }
                return null;
              },
            ),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              log('Title: $_title');
              log('Prompt: $_prompt');
              log('Description: $_description');

              PromptService()
                  .addPrivatePrompt(context, _title, _prompt, _description)
                  .then((_) {
                Navigator.of(context).pop(true);
              });
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
