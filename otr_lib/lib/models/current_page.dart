import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MainPagePosition with ChangeNotifier {
  OTRNavigation _pageNavitaionValue = OTRNavigation.home;
  Map<String, Widget> _appBarActions = Map<String, Widget>();

  OTRNavigation get navigationItem => _pageNavitaionValue;

  void setNavigationItem(OTRNavigation value) {
    _pageNavitaionValue = value;
    notifyListeners();
  }

  void setAppBarActions(Map<String, Widget> widgets) {
    if (listEquals<String>(
        widgets.keys.toList(), _appBarActions.keys.toList())) {
      return;
    }
    _appBarActions = widgets;
  }

  List<Widget> get appBarActions => _appBarActions.values.toList();

  IconData getIcon() {
    return OTRNavigationHelper.getDisplay(this._pageNavitaionValue)["icon"];
  }

  String getText() {
    return OTRNavigationHelper.getDisplay(this._pageNavitaionValue)["text"];
  }
}

enum OTRNavigation { home, people, calendar, shopping, param }

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

      default:
        return {"icon": Icons.home, "text": "Accueil"};
    }
  }
}
