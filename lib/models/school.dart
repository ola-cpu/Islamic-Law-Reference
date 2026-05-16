class School {
  final int? id;
  final String name;
  final String description;

  School({this.id, required this.name, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory School.fromMap(Map<String, dynamic> map) {
    return School(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }
}
