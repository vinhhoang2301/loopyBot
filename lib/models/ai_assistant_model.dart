class AiAssistantModel {
  String? openAiAssistantId;
  String? userId;
  String? assistantName;
  String? instructions;
  String? description;
  String? openAiThreadIdPlay;
  String? openAiVectorStoreId;
  bool? isDefault;
  dynamic createdBy;
  dynamic updatedBy;
  bool? isFavorite;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? id;

  AiAssistantModel({
    this.openAiAssistantId,
    this.userId,
    this.assistantName,
    this.instructions,
    this.description,
    this.openAiThreadIdPlay,
    this.openAiVectorStoreId,
    this.isDefault,
    this.createdBy,
    this.updatedBy,
    this.isFavorite,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.id,
  });

  AiAssistantModel.fromJson(Map<String, dynamic> json) {
    openAiAssistantId = json['openAiAssistantId'];
    userId = json['userId'];
    assistantName = json['assistantName'];
    instructions = json['instructions'];
    description = json['description'];
    openAiThreadIdPlay = json['openAiThreadIdPlay'];
    openAiVectorStoreId = json['openAiVectorStoreId'];
    isDefault = json['isDefault'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    isFavorite = json['isFavorite'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['openAiAssistantId'] = openAiAssistantId;
    data['userId'] = userId;
    data['assistantName'] = assistantName;
    data['instructions'] = instructions;
    data['description'] = description;
    data['openAiThreadIdPlay'] = openAiThreadIdPlay;
    data['openAiVectorStoreId'] = openAiVectorStoreId;
    data['isDefault'] = isDefault;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['isFavorite'] = isFavorite;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['id'] = id;

    return data;
  }
}
