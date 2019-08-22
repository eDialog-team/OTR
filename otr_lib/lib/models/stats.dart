class ApiResults {
  int sportId;
  String name;
  League league;

  ApiResults({this.sportId, this.name, this.league});

  ApiResults.fromJson(Map<String, dynamic> json) {
    sportId = json['sportId'];
    name = json['name'];
    league =
        json['league'] != null ? new League.fromJson(json['league']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sportId'] = this.sportId;
    data['name'] = this.name;
    if (this.league != null) {
      data['league'] = this.league.toJson();
    }
    return data;
  }
}

class League {
  int leagueId;
  String name;
  String abbreviation;
  String displayName;
  Season season;

  League(
      {this.leagueId,
      this.name,
      this.abbreviation,
      this.displayName,
      this.season});

  League.fromJson(Map<String, dynamic> json) {
    leagueId = json['leagueId'];
    name = json['name'];
    abbreviation = json['abbreviation'];
    displayName = json['displayName'];
    season =
        json['season'] != null ? new Season.fromJson(json['season']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leagueId'] = this.leagueId;
    data['name'] = this.name;
    data['abbreviation'] = this.abbreviation;
    data['displayName'] = this.displayName;
    if (this.season != null) {
      data['season'] = this.season.toJson();
    }
    return data;
  }
}

class Season {
  int season;
  String name;
  bool isActive;
  List<EventType> eventType;

  Season({this.season, this.name, this.isActive, this.eventType});

  Season.fromJson(Map<String, dynamic> json) {
    season = json['season'];
    name = json['name'];
    isActive = json['isActive'];
    if (json['eventType'] != null) {
      eventType = new List<EventType>();
      json['eventType'].forEach((v) {
        eventType.add(new EventType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['season'] = this.season;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    if (this.eventType != null) {
      data['eventType'] = this.eventType.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventType {
  int eventTypeId;
  String name;
  List<Events> events;

  EventType({this.eventTypeId, this.name, this.events});

  EventType.fromJson(Map<String, dynamic> json) {
    eventTypeId = json['eventTypeId'];
    name = json['name'];
    if (json['events'] != null) {
      events = new List<Events>();
      json['events'].forEach((v) {
        events.add(new Events.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventTypeId'] = this.eventTypeId;
    data['name'] = this.name;
    if (this.events != null) {
      data['events'] = this.events.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Events {
  int eventId;
  List<StartDate> startDate;
  bool isTba;
  IsDataConfirmed isDataConfirmed;
  EventStatus eventStatus;
  Venue venue;
  List<Teams> teams;
  bool replay;
  int originalWeek;
  int week;
  CoverageLevel coverageLevel;
  List<DefendingXZeroTeam> defendingXZeroTeam;

  Events(
      {this.eventId,
      this.startDate,
      this.isTba,
      this.isDataConfirmed,
      this.eventStatus,
      this.venue,
      this.teams,
      this.replay,
      this.originalWeek,
      this.week,
      this.coverageLevel,
      this.defendingXZeroTeam});

  Events.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    if (json['startDate'] != null) {
      startDate = new List<StartDate>();
      json['startDate'].forEach((v) {
        startDate.add(new StartDate.fromJson(v));
      });
    }
    isTba = json['isTba'];
    isDataConfirmed = json['isDataConfirmed'] != null
        ? new IsDataConfirmed.fromJson(json['isDataConfirmed'])
        : null;
    eventStatus = json['eventStatus'] != null
        ? new EventStatus.fromJson(json['eventStatus'])
        : null;
    venue = json['venue'] != null ? new Venue.fromJson(json['venue']) : null;
    if (json['teams'] != null) {
      teams = new List<Teams>();
      json['teams'].forEach((v) {
        teams.add(new Teams.fromJson(v));
      });
    }
    replay = json['replay'];
    originalWeek = json['originalWeek'];
    week = json['week'];
    coverageLevel = json['coverageLevel'] != null
        ? new CoverageLevel.fromJson(json['coverageLevel'])
        : null;
    if (json['defendingXZeroTeam'] != null) {
      defendingXZeroTeam = new List<DefendingXZeroTeam>();
      json['defendingXZeroTeam'].forEach((v) {
        defendingXZeroTeam.add(new DefendingXZeroTeam.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventId'] = this.eventId;
    if (this.startDate != null) {
      data['startDate'] = this.startDate.map((v) => v.toJson()).toList();
    }
    data['isTba'] = this.isTba;
    if (this.isDataConfirmed != null) {
      data['isDataConfirmed'] = this.isDataConfirmed.toJson();
    }
    if (this.eventStatus != null) {
      data['eventStatus'] = this.eventStatus.toJson();
    }
    if (this.venue != null) {
      data['venue'] = this.venue.toJson();
    }
    if (this.teams != null) {
      data['teams'] = this.teams.map((v) => v.toJson()).toList();
    }
    data['replay'] = this.replay;
    data['originalWeek'] = this.originalWeek;
    data['week'] = this.week;
    if (this.coverageLevel != null) {
      data['coverageLevel'] = this.coverageLevel.toJson();
    }
    if (this.defendingXZeroTeam != null) {
      data['defendingXZeroTeam'] =
          this.defendingXZeroTeam.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StartDate {
  int year;
  int month;
  int date;
  int hour;
  int minute;
  String full;
  String dateType;

  StartDate(
      {this.year,
      this.month,
      this.date,
      this.hour,
      this.minute,
      this.full,
      this.dateType});

  StartDate.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
    date = json['date'];
    hour = json['hour'];
    minute = json['minute'];
    full = json['full'];
    dateType = json['dateType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['month'] = this.month;
    data['date'] = this.date;
    data['hour'] = this.hour;
    data['minute'] = this.minute;
    data['full'] = this.full;
    data['dateType'] = this.dateType;
    return data;
  }
}

class IsDataConfirmed {
  bool score;

  IsDataConfirmed({this.score});

  IsDataConfirmed.fromJson(Map<String, dynamic> json) {
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    return data;
  }
}

class EventStatus {
  int eventStatusId;
  int period;
  Time time;
  bool isActive;
  Null defendingXZeroTeamId;
  int announcedInjuryTime;
  bool underReview;
  String name;

  EventStatus(
      {this.eventStatusId,
      this.period,
      this.time,
      this.isActive,
      this.defendingXZeroTeamId,
      this.announcedInjuryTime,
      this.underReview,
      this.name});

  EventStatus.fromJson(Map<String, dynamic> json) {
    eventStatusId = json['eventStatusId'];
    period = json['period'];
    time = json['time'] != null ? new Time.fromJson(json['time']) : null;
    isActive = json['isActive'];
    defendingXZeroTeamId = json['defendingXZeroTeamId'];
    announcedInjuryTime = json['announcedInjuryTime'];
    underReview = json['underReview'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventStatusId'] = this.eventStatusId;
    data['period'] = this.period;
    if (this.time != null) {
      data['time'] = this.time.toJson();
    }
    data['isActive'] = this.isActive;
    data['defendingXZeroTeamId'] = this.defendingXZeroTeamId;
    data['announcedInjuryTime'] = this.announcedInjuryTime;
    data['underReview'] = this.underReview;
    data['name'] = this.name;
    return data;
  }
}

class Time {
  int minutes;
  int seconds;
  int additionalMinutes;

  Time({this.minutes, this.seconds, this.additionalMinutes});

  Time.fromJson(Map<String, dynamic> json) {
    minutes = json['minutes'];
    seconds = json['seconds'];
    additionalMinutes = json['additionalMinutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minutes'] = this.minutes;
    data['seconds'] = this.seconds;
    data['additionalMinutes'] = this.additionalMinutes;
    return data;
  }
}

class Venue {
  int venueId;
  String name;
  String city;
  Country country;

  Venue({this.venueId, this.name, this.city, this.country});

  Venue.fromJson(Map<String, dynamic> json) {
    venueId = json['venueId'];
    name = json['name'];
    city = json['city'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['venueId'] = this.venueId;
    data['name'] = this.name;
    data['city'] = this.city;
    if (this.country != null) {
      data['country'] = this.country.toJson();
    }
    return data;
  }
}

class Country {
  int countryId;
  String name;
  String abbreviation;

  Country({this.countryId, this.name, this.abbreviation});

  Country.fromJson(Map<String, dynamic> json) {
    countryId = json['countryId'];
    name = json['name'];
    abbreviation = json['abbreviation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryId'] = this.countryId;
    data['name'] = this.name;
    data['abbreviation'] = this.abbreviation;
    return data;
  }
}

class Teams {
  String displayName;
  TeamColors teamColors;
  String formation;
  int teamId;
  String location;
  int shots;
  int shootoutGoals;
  String abbreviation;
  TeamLocationType teamLocationType;
  Record record;
  int score;
  bool isWinner;
  Coach coach;

  Teams(
      {this.displayName,
      this.teamColors,
      this.formation,
      this.teamId,
      this.location,
      this.shots,
      this.shootoutGoals,
      this.abbreviation,
      this.teamLocationType,
      this.record,
      this.score,
      this.isWinner,
      this.coach});

  Teams.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    teamColors = json['teamColors'] != null
        ? new TeamColors.fromJson(json['teamColors'])
        : null;
    formation = json['formation'];
    teamId = json['teamId'];
    location = json['location'];
    shots = json['shots'];
    shootoutGoals = json['shootoutGoals'];
    abbreviation = json['abbreviation'];
    teamLocationType = json['teamLocationType'] != null
        ? new TeamLocationType.fromJson(json['teamLocationType'])
        : null;
    record =
        json['record'] != null ? new Record.fromJson(json['record']) : null;
    score = json['score'];
    isWinner = json['isWinner'];
    coach = json['coach'] != null ? new Coach.fromJson(json['coach']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    if (this.teamColors != null) {
      data['teamColors'] = this.teamColors.toJson();
    }
    data['formation'] = this.formation;
    data['teamId'] = this.teamId;
    data['location'] = this.location;
    data['shots'] = this.shots;
    data['shootoutGoals'] = this.shootoutGoals;
    data['abbreviation'] = this.abbreviation;
    if (this.teamLocationType != null) {
      data['teamLocationType'] = this.teamLocationType.toJson();
    }
    if (this.record != null) {
      data['record'] = this.record.toJson();
    }
    data['score'] = this.score;
    data['isWinner'] = this.isWinner;
    if (this.coach != null) {
      data['coach'] = this.coach.toJson();
    }
    return data;
  }
}

class TeamColors {
  String primary;
  String shorts;

  TeamColors({this.primary, this.shorts});

  TeamColors.fromJson(Map<String, dynamic> json) {
    primary = json['primary'];
    shorts = json['shorts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['primary'] = this.primary;
    data['shorts'] = this.shorts;
    return data;
  }
}

class TeamLocationType {
  int teamLocationTypeId;
  String name;

  TeamLocationType({this.teamLocationTypeId, this.name});

  TeamLocationType.fromJson(Map<String, dynamic> json) {
    teamLocationTypeId = json['teamLocationTypeId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamLocationTypeId'] = this.teamLocationTypeId;
    data['name'] = this.name;
    return data;
  }
}

class Record {
  int wins;
  int losses;
  int ties;
  String percentage;
  int points;

  Record({this.wins, this.losses, this.ties, this.percentage, this.points});

  Record.fromJson(Map<String, dynamic> json) {
    wins = json['wins'];
    losses = json['losses'];
    ties = json['ties'];
    percentage = json['percentage'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wins'] = this.wins;
    data['losses'] = this.losses;
    data['ties'] = this.ties;
    data['percentage'] = this.percentage;
    data['points'] = this.points;
    return data;
  }
}

class Coach {
  int coachId;
  String firstName;
  String lastName;

  Coach({this.coachId, this.firstName, this.lastName});

  Coach.fromJson(Map<String, dynamic> json) {
    coachId = json['coachId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coachId'] = this.coachId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }
}

class CoverageLevel {
  int coverageLevelId;
  String name;

  CoverageLevel({this.coverageLevelId, this.name});

  CoverageLevel.fromJson(Map<String, dynamic> json) {
    coverageLevelId = json['coverageLevelId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coverageLevelId'] = this.coverageLevelId;
    data['name'] = this.name;
    return data;
  }
}

class DefendingXZeroTeam {
  int period;
  int teamId;

  DefendingXZeroTeam({this.period, this.teamId});

  DefendingXZeroTeam.fromJson(Map<String, dynamic> json) {
    period = json['period'];
    teamId = json['teamId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['period'] = this.period;
    data['teamId'] = this.teamId;
    return data;
  }
}
