class PromptModel {
  String category;
  String content;
  String description;
  bool isPublic;
  String language;
  String title;
  Map<String, dynamic> additionalProperties;

  PromptModel({
    required this.category,
    required this.content,
    required this.description,
    required this.isPublic,
    required this.language,
    required this.title,
    this.additionalProperties = const {},
  });

  factory PromptModel.fromJson(Map<String, dynamic> json) {
    return PromptModel(
      category: json['category'] ?? '',
      content: json['content'] ?? '',
      description: json['description'] ?? '',
      isPublic: json['isPublic'] ?? false,
      language: json['language'] ?? '',
      title: json['title'] ?? '',
      additionalProperties: Map<String, dynamic>.from(json)..removeWhere((key, value) => ['category', 'content', 'description', 'isPublic', 'language', 'title'].contains(key)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'content': content,
      'description': description,
      'isPublic': isPublic,
      'language': language,
      'title': title,
      ...additionalProperties,
    };
  }

  @override
  String toString() {
    return 'PromptModel{category: $category, content: $content, description: $description, isPublic: $isPublic, language: $language, title: $title, additionalProperties: $additionalProperties}';
  }
}