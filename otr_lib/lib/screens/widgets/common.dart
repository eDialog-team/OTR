import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flushbar/flushbar.dart';
import 'package:provider/provider.dart';

import 'package:otr_lib/models/current_page.dart';

/// Contains multiples WIDGET that are often used (appbar/navbar..)

class OTRAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var _item = Provider.of<MainPagePosition>(context);

    return AppBar(
      title: Text(_item.getText()),
      actions: _item.appBarActions,
    );
  }
}

class OTRBottomNavigationBar extends StatelessWidget {
  final bottomItems = [
    OTRNavigation.home,
    OTRNavigation.people,
    OTRNavigation.calendar,
    // OTRNavigation.shopping,
    // OTRNavigation.param
  ];

  @override
  Widget build(BuildContext context) {
    final _currentPage = Provider.of<MainPagePosition>(context);
    var _index = OTRNavigation.values.indexOf(_currentPage.navigationItem);
    if (_index >= bottomItems.length) {
      _index = 0;
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _index,
      onTap: (int i) {
        _currentPage.setNavigationItem(OTRNavigation.values[i]);
      },
      items: [
        ...(bottomItems.map((item) {
          var display = OTRNavigationHelper.getDisplay(item);
          return BottomNavigationBarItem(
              icon: Icon(display["icon"]), title: Text(display["text"]));
        }))
      ],
    );
  }
}

class OTRUtils {
  static void errorFlushBar({
    @required String message,
    @required BuildContext context,
    bool pop = false,
    bool postFrame = true,
    VoidCallback after,
  }) {
    showSnackBar() => Flushbar(
          message: message,
          icon: Icon(
            Icons.warning,
            size: 28.0,
            color: Colors.red[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.red[300],
        )
          ..onStatusChanged = (FlushbarStatus status) {
            if (status == FlushbarStatus.IS_HIDING && pop)
              Navigator.of(context).maybePop();
          }
          ..show(context);

    if (postFrame) {
      // after the repaint is complete, display a snackBar info
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showSnackBar();
        if (after != null) {
          after();
        }
      });
    } else {
      showSnackBar();
    }
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
