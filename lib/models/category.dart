class Category {
  final int? id;
  final int? parentId;
  final String name;
  final String icon;
  final String? imageUrl;

  Category({this.id, this.parentId, required this.name, required this.icon, this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parent_id': parentId,
      'name': name,
      'icon': icon,
      'image_url': imageUrl,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      parentId: map['parent_id'],
      name: map['name'],
      icon: map['icon'],
      imageUrl: map['image_url'],
    );
  }
}
