class Media {
  final String creation;
  final String description;
  final String link;
  final String name;
  final String id;
  final String thumbnailUrl;

  String get articleId => link.split("/").last;

  Media({
    this.creation,
    this.description,
    this.link,
    this.name,
    this.id,
    this.thumbnailUrl,
  });

  @override
  String toString() {
    return 'Media{creation: $creation, description: $description, id: $id, link: $link, name: $name, thumbnailUrl: $thumbnailUrl}';
  }

  factory Media.fromJson(Map<String, dynamic> json) {
    return  Media(
      creation: json['creation'] as String,
      description: json['description'] as String,
      link: json['link'] as String,
      name: json['name'] as String,
      id: json['id'] as String,
      thumbnailUrl: json['url'] as String,
    );
  }
}

class Corpus {
  final String description;
  final String id;
  final List<Media> medias;
  final String name;

  Corpus({this.description, this.id, this.medias, this.name});

  factory Corpus.fromJson(dynamic json) {
    return  Corpus(
      description: json['description'] as String,
      id: json['id'] as String,
      medias: json['medias']
          .map<Media>((json) =>  Media.fromJson(json))
          .toList(),
      name: json['name'] as String,
    );
  }
}
