import 'package:flutter/material.dart';
import 'package:final_project/services/prompt_service.dart';
import 'package:final_project/models/prompt_model.dart';

class EditPromptDialog extends StatefulWidget {
  final PromptModel prompt;

  EditPromptDialog({required this.prompt});

  @override
  _EditPromptDialogState createState() => _EditPromptDialogState();
}

class _EditPromptDialogState extends State<EditPromptDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  late String _description;

  @override
  void initState() {
    super.initState();
    _title = widget.prompt.title;
    _content = widget.prompt.content;
    _description = widget.prompt.description;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Prompt',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              initialValue: _title,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(labelText: 'Title'),
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
              initialValue: _content,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(labelText: 'Content'),
              onChanged: (value) {
                setState(() {
                  _content = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter content';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: _description,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(labelText: 'Description'),
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
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              PromptService().updatePrivatePrompt(context, widget.prompt.id, _title, _content, _description).then((_) {
                Navigator.of(context).pop(true);
              });
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}