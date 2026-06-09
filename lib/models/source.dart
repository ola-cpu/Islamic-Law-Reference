class Source {
  final int? id;
  final int lawId;
  final int type; // 0: Quran, 1: Hadith, 2: Fiqh Book
  final String reference;
  final String? referenceEn;
  final String? referenceAr;
  final String? referenceRu;
  final String? referenceZh;
  final String text;
  final String? textEn;
  final String? textAr;
  final String? textRu;
  final String? textZh;
  final Authenticity authenticity;
  final String? citation;
  final String? citationEn;
  final String? citationAr;
  final String? citationRu;
  final String? citationZh;
  final String? isnad;

  Source({
    this.id,
    required this.lawId,
    required this.type,
    required this.reference,
    this.referenceEn,
    this.referenceAr,
    this.referenceRu,
    this.referenceZh,
    required this.text,
    this.textEn,
    this.textAr,
    this.textRu,
    this.textZh,
    required this.authenticity,
    this.citation,
    this.citationEn,
    this.citationAr,
    this.citationRu,
    this.citationZh,
    this.isnad,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'law_id': lawId,
      'type': type,
      'reference': reference,
      'reference_en': referenceEn,
      'reference_ar': referenceAr,
      'reference_ru': referenceRu,
      'reference_zh': referenceZh,
      'text': text,
      'text_en': textEn,
      'text_ar': textAr,
      'text_ru': textRu,
      'text_zh': textZh,
      'authenticity': authenticity.index,
      'citation': citation,
      'citation_en': citationEn,
      'citation_ar': citationAr,
      'citation_ru': citationRu,
      'citation_zh': citationZh,
      'isnad': isnad,
    };
  }

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      id: map['id'],
      lawId: map['law_id'],
      type: map['type'],
      reference: map['reference'],
      referenceEn: map['reference_en'],
      referenceAr: map['reference_ar'],
      referenceRu: map['reference_ru'],
      referenceZh: map['reference_zh'],
      text: map['text'],
      textEn: map['text_en'],
      textAr: map['text_ar'],
      textRu: map['text_ru'],
      textZh: map['text_zh'],
      authenticity: Authenticity.values[map['authenticity'] ?? 4],
      citation: map['citation'],
      citationEn: map['citation_en'],
      citationAr: map['citation_ar'],
      citationRu: map['citation_ru'],
      citationZh: map['citation_zh'],
      isnad: map['isnad'],
    );
  }
}

enum Authenticity { sahih, hasan, daif, mawdu, none }
