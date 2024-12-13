class KbModel {
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? userId;
  String? knowledgeName;
  String? description;
  String? kbId;

  KbModel(
      {this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.userId,
      this.knowledgeName,
      this.description,
      this.kbId});

  KbModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    userId = json['userId'];
    knowledgeName = json['knowledgeName'];
    description = json['description'];
    kbId = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['userId'] = this.userId;
    data['knowledgeName'] = this.knowledgeName;
    data['description'] = this.description;
    data['id'] = this.kbId;
    return data;
  }
}
