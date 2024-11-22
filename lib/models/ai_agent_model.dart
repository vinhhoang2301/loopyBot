import 'package:final_project/consts/key.dart';

class AiAgentModel {
  final String id;
  final String name;
  final String thumbnail;

  const AiAgentModel({
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['model'] = DIFY;
    data['name'] = name;
    
    return data;
  }
}
