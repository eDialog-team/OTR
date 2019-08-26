class Players {
  String id;
  String position;
  String identifier;
  String hand;
  String foot;
  String creation;
  People people;

  Players(
      {this.id,
      this.position,
      this.identifier,
      this.hand,
      this.foot,
      this.creation,
      this.people});

  Players.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    position = json['position'];
    identifier = json['identifier'];
    hand = json['hand'];
    foot = json['foot'];
    creation = json['creation'];
    people = json['people'] != null ? People.fromJson(json['people']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['position'] = this.position;
    data['identifier'] = this.identifier;
    data['hand'] = this.hand;
    data['foot'] = this.foot;
    data['creation'] = this.creation;
    if (this.people != null) {
      data['people'] = this.people.toJson();
    }
    return data;
  }
}

class People {
  String id;
  String name;
  String surname;

  People({this.id, this.name, this.surname});

  People.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['surname'] = this.surname;
    return data;
  }
}
