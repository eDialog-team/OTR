class Teams {
  int teamPoints;
  String teamPointsPerGame;
  int penaltyPoints;
  String displayName;
  int teamId;
  String location;
  String abbreviation;
  League league;
  Record record;

  Teams(
      {this.teamPoints,
      this.teamPointsPerGame,
      this.penaltyPoints,
      this.displayName,
      this.teamId,
      this.location,
      this.abbreviation,
      this.league,
      this.record});

  Teams.fromJson(Map<String, dynamic> json) {
    teamPoints = json['teamPoints'];
    teamPointsPerGame = json['teamPointsPerGame'];
    penaltyPoints = json['penaltyPoints'];
    displayName = json['displayName'];
    teamId = json['teamId'];
    location = json['location'];
    abbreviation = json['abbreviation'];
    league =
        json['league'] != null ?  League.fromJson(json['league']) : null;
    record =
        json['record'] != null ?  Record.fromJson(json['record']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['teamPoints'] = this.teamPoints;
    data['teamPointsPerGame'] = this.teamPointsPerGame;
    data['penaltyPoints'] = this.penaltyPoints;
    data['displayName'] = this.displayName;
    data['teamId'] = this.teamId;
    data['location'] = this.location;
    data['abbreviation'] = this.abbreviation;
    if (this.league != null) {
      data['league'] = this.league.toJson();
    }
    if (this.record != null) {
      data['record'] = this.record.toJson();
    }
    return data;
  }
}

class League {
  int rank;
  int seed;

  League({this.rank, this.seed});

  League.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    seed = json['seed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['rank'] = this.rank;
    data['seed'] = this.seed;
    return data;
  }
}

class Record {
  int wins;
  int losses;
  int ties;
  String percentage;
  int gamesPlayed;

  Record(
      {this.wins, this.losses, this.ties, this.percentage, this.gamesPlayed});

  Record.fromJson(Map<String, dynamic> json) {
    wins = json['wins'];
    losses = json['losses'];
    ties = json['ties'];
    percentage = json['percentage'];
    gamesPlayed = json['gamesPlayed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['wins'] = this.wins;
    data['losses'] = this.losses;
    data['ties'] = this.ties;
    data['percentage'] = this.percentage;
    data['gamesPlayed'] = this.gamesPlayed;
    return data;
  }
}
