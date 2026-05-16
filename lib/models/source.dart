enum SourceType { quran, hadith, fiqhBook }

class Source {
  final int? id;
  final int lawId;
  final SourceType type;
  final String reference; // e.g., "Sourate 2, Verset 183" or "Sahih Bukhari, Hadith 1"
  final String text;

  Source({
    this.id,
    required this.lawId,
    required this.type,
    required this.reference,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'law_id': lawId,
      'type': type.index,
      'reference': reference,
      'text': text,
    };
  }

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      id: map['id'],
      lawId: map['law_id'],
      type: SourceType.values[map['type']],
      reference: map['reference'],
      text: map['text'],
    );
  }
}
