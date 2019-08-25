import 'package:flutter/material.dart';
import 'package:otr_lib/screens/main.dart';
import 'package:otr_lib/screens/article.dart';

import 'package:otr_lib/models/corpus.dart';

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
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings.name);
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
          child: Text("Erreur: '" + routeName + "' non trouvé"),
        ),
      );
    });
  }
}
