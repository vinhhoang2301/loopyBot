class PublishedAssistant {
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? deletedAt;
  String? id;
  String? type;
  String? accessToken;
  Map<String, dynamic>? metadata;
  String? assistantId;

  PublishedAssistant({
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.id,
    this.type,
    this.accessToken,
    this.metadata,
    this.assistantId,
  });

  PublishedAssistant.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    deletedAt = json['deletedAt'];
    id = json['id'];
    type = json['type'];
    accessToken = json['accessToken'];
    metadata = json['metadata'];
    assistantId = json['assistantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['deletedAt'] = deletedAt;
    data['id'] = id;
    data['type'] = type;
    data['accessToken'] = accessToken;
    data['metadata'] = metadata;
    data['assistantId'] = assistantId;
    return data;
  }
}
