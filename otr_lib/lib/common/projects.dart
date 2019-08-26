import 'package:flutter/material.dart';

class OTRProjects {
  MaterialColor _materialColor;
  ThemeData _themeData;
  String _httpRoot;
  String _billetterie;
  String _projectName;
  String _idPeopleTeamID;
  String _starterUrl;
  int _teamID;
  int _currentSeason;
  bool _useCache = true;

  OTRProjects(String projectName) {
    this._projectName = projectName;
    // DFCO
    if (projectName == "DFCO") {
      const _primaryValue = 0xFFd40028;

      _materialColor = MaterialColor(
        _primaryValue,
        const <int, Color>{
          50: const Color(0xFFfae0e5),
          100: const Color(0xFFf2b3bf),
          200: const Color(0xFFea8094),
          300: const Color(0xFFe14d69),
          400: const Color(0xFFda2648),
          500: const Color(_primaryValue),
          600: const Color(0xFFcf0024),
          700: const Color(0xFFc9001e),
          800: const Color(0xFFc30018),
          900: const Color(0xFFb9000f),
        },
      );

      _themeData = ThemeData(
        primarySwatch: _materialColor,
        textTheme: TextTheme(
          display4: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
        ),
      );

      _httpRoot = "https://m.memberz.fr/dfco/";
      _starterUrl = "https://www.dfco.fr/";
      _billetterie = "https://billetterie-dfco.fr/fr/calendar/events/";
      _teamID = 8723;
      _currentSeason = 2019;
      _idPeopleTeamID = "15C181A5-B4A3-4D74-8A4F-B0E04EC8557D";
    }
  }

  MaterialColor get materialColor => _materialColor;
  ThemeData get themeData => _themeData;
  String get httpRoot => _httpRoot;
  String get starterUrl => _starterUrl;
  String get billeterieUrl => _billetterie;
  String get projectName => _projectName;
  int get currentSeasonYear => _currentSeason;
  int get teamID => _teamID;
  String get idPeopleTeamID => _idPeopleTeamID;
  bool get useCache => _useCache;
  void disableCache() => _useCache = false;
  void enableCache() => _useCache = true;
}
