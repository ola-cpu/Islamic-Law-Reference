class Law {
  final int? id;
  final int categoryId;
  final String title;
  final String content;
  final String? scholarComments;
  final String school; // Hanafi, Maliki, Shafi'i, Hanbali, etc.

  Law({
    this.id,
    required this.categoryId,
    required this.title,
    required this.content,
    this.scholarComments,
    required this.school,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'content': content,
      'scholar_comments': scholarComments,
      'school': school,
    };
  }

  factory Law.fromMap(Map<String, dynamic> map) {
    return Law(
      id: map['id'],
      categoryId: map['category_id'],
      title: map['title'],
      content: map['content'],
      scholarComments: map['scholar_comments'],
      school: map['school'],
    );
  }
}
