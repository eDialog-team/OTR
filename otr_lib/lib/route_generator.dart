import 'package:flutter/material.dart';
import 'package:otr_lib/screens/main.dart';
import 'package:otr_lib/screens/article.dart';
import 'package:otr_lib/screens/team_ranking.dart';

import 'package:otr_lib/models/corpus.dart';
import 'package:otr_lib/models/stats.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => OTRAccueil());

      case '/article':
        // Validation of correct data type
        if (args is Media) {
          return MaterialPageRoute(
            builder: (_) => OTRArticle(
              media: args,
            ),
          );
        }
        return _errorRoute(settings.name);

      case '/classement':
        return MaterialPageRoute(
          builder: (_) => OTRTeamRanking(),
        );

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String routeName) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Erreur'),
        ),
        body: Center(
          child: Text("Erreur: page '" + routeName + "' non trouvé"),
        ),
      );
    });
  }
}
