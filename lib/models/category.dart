class Category {
  final int? id;
  final int? parentId;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final String? nameRu;
  final String? nameZh;
  final String icon;
  final String? imageUrl;

  Category({
    this.id,
    this.parentId,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.nameRu,
    this.nameZh,
    required this.icon,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parent_id': parentId,
      'name': name,
      'name_en': nameEn,
      'name_ar': nameAr,
      'name_ru': nameRu,
      'name_zh': nameZh,
      'icon': icon,
      'image_url': imageUrl,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      parentId: map['parent_id'],
      name: map['name'],
      nameEn: map['name_en'],
      nameAr: map['name_ar'],
      nameRu: map['name_ru'],
      nameZh: map['name_zh'],
      icon: map['icon'],
      imageUrl: map['image_url'],
    );
  }
}
