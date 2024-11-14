class ChatResponseModel {
  final String message;
  final String conversationId;
  final int remainingUsage;

  ChatResponseModel({
    required this.message,
    required this.conversationId,
    required this.remainingUsage,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      message: json['message'] ?? '',
      conversationId: json['conversationId'] ?? '',
      remainingUsage: int.parse(json['remainingUsage']) ,
    );
  }
}