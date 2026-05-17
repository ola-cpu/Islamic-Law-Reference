class Topic {
  final int? id;
  final int categoryId;
  final String title;
  final String description;

  Topic({
    this.id,
    required this.categoryId,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'description': description,
    };
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'],
      categoryId: map['category_id'],
      title: map['title'],
      description: map['description'],
    );
  }
}
