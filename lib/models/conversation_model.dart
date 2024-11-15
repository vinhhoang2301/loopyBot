class ConversationModel {
  String? title;
  String? id;
  int? createdAt;

  ConversationModel({
    this.title,
    this.id,
    this.createdAt,
  });

  ConversationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['id'] = id;
    data['createdAt'] = createdAt;

    return data;
  }
}
