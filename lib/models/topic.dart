class Topic {
  final int? id;
  final int categoryId;
  final String title;
  final String? titleEn;
  final String? titleAr;
  final String? titleRu;
  final String? titleZh;
  final String description;
  final String? descriptionEn;
  final String? descriptionAr;
  final String? descriptionRu;
  final String? descriptionZh;

  Topic({
    this.id,
    required this.categoryId,
    required this.title,
    this.titleEn,
    this.titleAr,
    this.titleRu,
    this.titleZh,
    required this.description,
    this.descriptionEn,
    this.descriptionAr,
    this.descriptionRu,
    this.descriptionZh,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'title_en': titleEn,
      'title_ar': titleAr,
      'title_ru': titleRu,
      'title_zh': titleZh,
      'description': description,
      'description_en': descriptionEn,
      'description_ar': descriptionAr,
      'description_ru': descriptionRu,
      'description_zh': descriptionZh,
    };
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'],
      categoryId: map['category_id'],
      title: map['title'],
      titleEn: map['title_en'],
      titleAr: map['title_ar'],
      titleRu: map['title_ru'],
      titleZh: map['title_zh'],
      description: map['description'],
      descriptionEn: map['description_en'],
      descriptionAr: map['description_ar'],
      descriptionRu: map['description_ru'],
      descriptionZh: map['description_zh'],
    );
  }
}
