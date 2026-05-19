class School {
  final int? id;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final String? nameRu;
  final String? nameZh;
  final String description;
  final String? descriptionEn;
  final String? descriptionAr;
  final String? descriptionRu;
  final String? descriptionZh;

  School({
    this.id,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.nameRu,
    this.nameZh,
    required this.description,
    this.descriptionEn,
    this.descriptionAr,
    this.descriptionRu,
    this.descriptionZh,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'name_ar': nameAr,
      'name_ru': nameRu,
      'name_zh': nameZh,
      'description': description,
      'description_en': descriptionEn,
      'description_ar': descriptionAr,
      'description_ru': descriptionRu,
      'description_zh': descriptionZh,
    };
  }

  factory School.fromMap(Map<String, dynamic> map) {
    return School(
      id: map['id'],
      name: map['name'],
      nameEn: map['name_en'],
      nameAr: map['name_ar'],
      nameRu: map['name_ru'],
      nameZh: map['name_zh'],
      description: map['description'],
      descriptionEn: map['description_en'],
      descriptionAr: map['description_ar'],
      descriptionRu: map['description_ru'],
      descriptionZh: map['description_zh'],
    );
  }
}
