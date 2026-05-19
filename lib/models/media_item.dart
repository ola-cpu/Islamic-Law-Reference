enum MediaType {
  image,
  audio,
  video,
  infographic,
}

class MediaItem {
  final int? id;
  final int topicId;
  final MediaType type;
  final String url;
  final String? title;
  final String? description;

  MediaItem({
    this.id,
    required this.topicId,
    required this.type,
    required this.url,
    this.title,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic_id': topicId,
      'type': type.index,
      'url': url,
      'title': title,
      'description': description,
    };
  }

  factory MediaItem.fromMap(Map<String, dynamic> map) {
    return MediaItem(
      id: map['id'],
      topicId: map['topic_id'],
      type: MediaType.values[map['type']],
      url: map['url'],
      title: map['title'],
      description: map['description'],
    );
  }
}
