class AiResponseModel {
  String? conversationId;
  String? message;
  int? remainingUsage;

  AiResponseModel({this.conversationId, this.message, this.remainingUsage});

  AiResponseModel.fromJson(Map<String, dynamic> json) {
    conversationId = json['conversationId'];
    message = json['message'];
    remainingUsage = json['remainingUsage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['conversationId'] = conversationId;
    data['message'] = message;
    data['remainingUsage'] = remainingUsage;
    return data;
  }
}