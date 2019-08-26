class Article {
  String id;
  String name;
  String abstract;
  String description;
  Producer producer;
  List<Menus> menus;

  Article(
      {this.id,
      this.name,
      this.abstract,
      this.description,
      this.producer,
      this.menus});

  Article.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    abstract = json['abstract'];
    description = json['description'];
    producer = json['producer'] != null
        ?  Producer.fromJson(json['producer'])
        : null;
    if (json['menus'] != null) {
      menus =  List<Menus>();
      json['menus'].forEach((v) {
        menus.add( Menus.fromJson(v));
      });
    }
  }
}

class Producer {
  String id;
  String alias;

  Producer({this.id, this.alias});

  Producer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alias = json['alias'];
  }
}

class Menus {
  String id;
  String name;

  Menus({this.id, this.name});

  Menus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
