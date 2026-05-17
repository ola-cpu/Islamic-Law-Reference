class Law {
  final int? id;
  final int topicId;
  final String title;
  final String content;
  final String? contentAr;
  final String? scholarComments;
  final int schoolId;

  Law({
    this.id,
    required this.topicId,
    required this.title,
    required this.content,
    this.contentAr,
    this.scholarComments,
    required this.schoolId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic_id': topicId,
      'title': title,
      'content': content,
      'content_ar': contentAr,
      'scholar_comments': scholarComments,
      'school_id': schoolId,
    };
  }

  factory Law.fromMap(Map<String, dynamic> map) {
    return Law(
      id: map['id'],
      topicId: map['topic_id'],
      title: map['title'],
      content: map['content'],
      contentAr: map['content_ar'],
      scholarComments: map['scholar_comments'],
      schoolId: map['school_id'],
    );
  }
}
