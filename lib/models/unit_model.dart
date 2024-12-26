class UnitModel {
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? id;
  String? name;
  bool? status;
  String? userId;
  String? knowledgeId;

  UnitModel(
      {this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.id,
      this.name,
      this.status,
      this.userId,
      this.knowledgeId});

  UnitModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    id = json['id'];
    name = json['name'];
    status = json['status'];
    userId = json['userId'];
    knowledgeId = json['knowledgeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['userId'] = this.userId;
    data['knowledgeId'] = this.knowledgeId;
    return data;
  }
}
