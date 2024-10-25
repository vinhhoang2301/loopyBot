import 'package:flutter/material.dart';

class NewPromptDialog extends StatefulWidget {
  @override
  _NewPromptDialogState createState() => _NewPromptDialogState();
}

class _NewPromptDialogState extends State<NewPromptDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
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
            Padding(
              padding: EdgeInsets.all(6.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: Text(
                        'Private',
                      ),
                      leading: Radio(
                        value: true,
                        groupValue: _isPrivate,
                        onChanged: (bool? value) {
                          setState(() {
                            _isPrivate = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        'Public',
                      ),
                      leading: Radio(
                        value: false,
                        groupValue: _isPrivate,
                        onChanged: (bool? value) {
                          setState(() {
                            _isPrivate = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Prompt'),
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              print('Name: $_name');
              print('Prompt: $_prompt');
              print('Is Private: $_isPrivate');

              Navigator.of(context).pop();
            }
          },
          child: Text('Create'),
        ),
      ],
    );
  }
}
