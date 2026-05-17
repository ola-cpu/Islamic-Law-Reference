enum SourceType { quran, hadith, fiqhBook }

enum Authenticity { sahih, hasan, daif, mawdu, none }

class Source {
  final int? id;
  final int lawId;
  final SourceType type;
  final String reference;
  final String text;
  final String? textAr;
  final Authenticity authenticity;
  final String? citation;

  Source({
    this.id,
    required this.lawId,
    required this.type,
    required this.reference,
    required this.text,
    this.textAr,
    this.authenticity = Authenticity.none,
    this.citation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'law_id': lawId,
      'type': type.index,
      'reference': reference,
      'text': text,
      'text_ar': textAr,
      'authenticity': authenticity.index,
      'citation': citation,
    };
  }

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      id: map['id'],
      lawId: map['law_id'],
      type: SourceType.values[map['type']],
      reference: map['reference'],
      text: map['text'],
      textAr: map['text_ar'],
      authenticity: Authenticity.values[map['authenticity'] ?? Authenticity.none.index],
      citation: map['citation'],
    );
  }
}
