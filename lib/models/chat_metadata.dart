import 'package:final_project/models/ai_agent_model.dart';

class ChatMetaData {
  String? role;
  String? content;
  AiAgentModel? assistant;
  bool? isErrored;

  ChatMetaData({
    this.role,
    this.content,
    this.assistant,
    this.isErrored = false,
  });

  // ChatMetaData.fromJson(Map<String, dynamic> json) {
  //   role = json['role'];
  //   content = json['content'];
  //   assistant = json['assistant'] != null
  //       ? new Assistant.fromJson(json['assistant'])
  //       : null;
  //   isErrored = json['isErrored'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['role'] = role;
    data['content'] = content;
    if (assistant != null) {
      data['assistant'] = assistant!.toJson();
    }
    data['isErrored'] = isErrored;

    return data;
  }
}
