import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CurrentPage with ChangeNotifier {
  OTRNavigation _pageNavitaionValue = OTRNavigation.home;

  OTRNavigation get navigationItem => _pageNavitaionValue;

  void setNavigationItem(OTRNavigation value) {
    _pageNavitaionValue = value;
    notifyListeners();
  }
}

enum OTRNavigation { home, people, calendar, shopping, param, article }

class OTRNavigationHelper {
  static Map<String, Object> getDisplay(OTRNavigation value) {
    switch (value) {
      case OTRNavigation.home:
        return {"icon": Icons.home, "text": "Accueil"};
      case OTRNavigation.people:
        return {"icon": Icons.people, "text": 'Effectif'};
      case OTRNavigation.calendar:
        return {"icon": Icons.calendar_today, "text": 'Calendrier'};
      case OTRNavigation.shopping:
        return {"icon": Icons.shopping_cart, "text": 'Boutique'};
      case OTRNavigation.param:
        return {"icon": Icons.tune, "text": 'Params'};
      case OTRNavigation.article:
        return {"icon": Icons.block, "text": 'Article'};

      default:
        return {"icon": Icons.home, "text": "Accueil"};
    }
  }
}
