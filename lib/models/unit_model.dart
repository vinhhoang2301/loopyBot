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
  int? size;
  String? type;

  UnitModel({
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.id,
    this.name,
    this.status,
    this.userId,
    this.knowledgeId,
    this.size,
    this.type,
  });

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
    size = json['size'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['userId'] = userId;
    data['knowledgeId'] = knowledgeId;
    data['size'] = size;
    data['type'] = type;
    return data;
  }
}
