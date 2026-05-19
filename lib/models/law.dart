class Law {
  final int? id;
  final int topicId;
  final String title;
  final String? titleEn;
  final String? titleAr;
  final String? titleRu;
  final String? titleZh;
  final String content;
  final String? contentEn;
  final String? contentAr;
  final String? contentRu;
  final String? contentZh;
  final String? scholarComments;
  final String? scholarCommentsEn;
  final String? scholarCommentsAr;
  final String? scholarCommentsRu;
  final String? scholarCommentsZh;
  final int schoolId;

  Law({
    this.id,
    required this.topicId,
    required this.title,
    this.titleEn,
    this.titleAr,
    this.titleRu,
    this.titleZh,
    required this.content,
    this.contentEn,
    this.contentAr,
    this.contentRu,
    this.contentZh,
    this.scholarComments,
    this.scholarCommentsEn,
    this.scholarCommentsAr,
    this.scholarCommentsRu,
    this.scholarCommentsZh,
    required this.schoolId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic_id': topicId,
      'title': title,
      'title_en': titleEn,
      'title_ar': titleAr,
      'title_ru': titleRu,
      'title_zh': titleZh,
      'content': content,
      'content_en': contentEn,
      'content_ar': contentAr,
      'content_ru': contentRu,
      'content_zh': contentZh,
      'scholar_comments': scholarComments,
      'scholar_comments_en': scholarCommentsEn,
      'scholar_comments_ar': scholarCommentsAr,
      'scholar_comments_ru': scholarCommentsRu,
      'scholar_comments_zh': scholarCommentsZh,
      'school_id': schoolId,
    };
  }

  factory Law.fromMap(Map<String, dynamic> map) {
    return Law(
      id: map['id'],
      topicId: map['topic_id'],
      title: map['title'],
      titleEn: map['title_en'],
      titleAr: map['title_ar'],
      titleRu: map['title_ru'],
      titleZh: map['title_zh'],
      content: map['content'],
      contentEn: map['content_en'],
      contentAr: map['content_ar'],
      contentRu: map['content_ru'],
      contentZh: map['content_zh'],
      scholarComments: map['scholar_comments'],
      scholarCommentsEn: map['scholar_comments_en'],
      scholarCommentsAr: map['scholar_comments_ar'],
      scholarCommentsRu: map['scholar_comments_ru'],
      scholarCommentsZh: map['scholar_comments_zh'],
      schoolId: map['school_id'],
    );
  }
}
