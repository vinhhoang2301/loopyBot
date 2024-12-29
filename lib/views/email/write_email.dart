import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:final_project/consts/app_color.dart';
import 'package:final_project/services/write_email_service.dart';

class WriteEmailPage extends StatefulWidget {
  const WriteEmailPage({super.key});

  @override
  _WriteEmailPageState createState() => _WriteEmailPageState();
}

class _WriteEmailPageState extends State<WriteEmailPage> {
  final _formKey = GlobalKey<FormState>();
  String? _mainIdea;
  String? _action;
  String? _email;
  String? _subject;
  String? _sender;
  String? _receiver;
  String? _length;
  String? _formality;
  String? _tone;
  String? _language;
  String? _responseEmail;

  Future<void> _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      WriteEmailService emailService = WriteEmailService();
      String? responseEmail = await emailService.sendEmail(
        context: context,
        mainIdea: _mainIdea!,
        action: _action!,
        email: _email!,
        subject: _subject!,
        sender: _sender!,
        receiver: _receiver!,
        length: _length!,
        formality: _formality!,
        tone: _tone!,
        language: _language!,
      );
      setState(() {
        _responseEmail = responseEmail;
      });
    }
  }

  void _copyToClipboard() {
    if (_responseEmail != null) {
      Clipboard.setData(ClipboardData(text: _responseEmail!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Response email copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write respond Email'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.inverseTextColor,
        actions: [
          
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter email you want to respond to',
                        labelStyle: TextStyle(color: AppColors.defaultTextColor),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: AppColors.defaultTextColor),
                      onSaved: (value) => _email = value,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      style: TextStyle(color: AppColors.defaultTextColor),
                      decoration: InputDecoration(labelText: 'Main Idea'),
                      onSaved: (value) => _mainIdea = value,
                    ),
                    TextFormField(
                      style: TextStyle(color: AppColors.defaultTextColor),
                      decoration: InputDecoration(labelText: 'Action'),
                      onSaved: (value) => _action = value,
                    ),
                    TextFormField(
                      style: TextStyle(color: AppColors.defaultTextColor),
                      decoration: InputDecoration(labelText: 'Subject'),
                      onSaved: (value) => _subject = value,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      style: TextStyle(color: AppColors.defaultTextColor),
                      decoration: InputDecoration(labelText: 'Sender'),
                      onSaved: (value) => _sender = value,
                    ),
                    TextFormField(
                      style: TextStyle(color: AppColors.defaultTextColor),
                      decoration: InputDecoration(labelText: 'Receiver'),
                      onSaved: (value) => _receiver = value,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                        labelText: 'Length',
                        labelStyle: TextStyle(color: AppColors.defaultTextColor),
                        border: InputBorder.none,
                        ),
                        items: ['long', 'Medium', 'Long']
                          .map((length) => DropdownMenuItem(
                            value: length,
                            child: Text(length),
                            ))
                          .toList(),
                        onChanged: (value) => _length = value,
                      ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                        labelText: 'Formality',
                        labelStyle: TextStyle(color: AppColors.defaultTextColor),
                        border: InputBorder.none,
                        ),
                        items: ['neutral', 'Informal']
                          .map((formality) => DropdownMenuItem(
                            value: formality,
                            child: Text(formality),
                            ))
                          .toList(),
                        onChanged: (value) => _formality = value,
                      ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                        labelText: 'Tone',
                        labelStyle: TextStyle(color: AppColors.defaultTextColor),
                        border: InputBorder.none,
                        ),
                        items: ['friendly', 'Professional', 'Neutral']
                          .map((tone) => DropdownMenuItem(
                            value: tone,
                            child: Text(tone),
                            ))
                          .toList(),
                        onChanged: (value) => _tone = value,
                      ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                        labelText: 'Language',
                        labelStyle: TextStyle(color: AppColors.defaultTextColor),
                        border: InputBorder.none,
                        ),
                        items: ['vietnamese', 'Spanish', 'French']
                          .map((language) => DropdownMenuItem(
                            value: language,
                            child: Text(language),
                            ))
                          .toList(),
                        onChanged: (value) => _language = value,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16),             
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.mail, color: AppColors.inverseTextColor),
                  onPressed: _sendEmail,
                ),
              ),
              if (_responseEmail != null) ...[
                SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _responseEmail!,
                        style: TextStyle(color: AppColors.defaultTextColor),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _copyToClipboard,
                        child: Text('Copy to Clipboard'),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
