import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:otr_lib/common/projects.dart';
import 'package:otr_lib/screens/widgets/common.dart';
import 'package:otr_lib/screens/widgets/corpus_carousel.dart';
import 'package:otr_lib/screens/widgets/stat_match_current.dart';
import 'package:otr_lib/screens/match_calendar.dart';
import 'package:otr_lib/screens/players.dart';
import 'package:otr_lib/models/current_page.dart';
import 'package:otr_lib/screens/widgets/block_links.dart';

class OTRAccueil extends StatelessWidget {
// Outside the build method
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    final _currentPage = Provider.of<MainPagePosition>(context);

    return Scaffold(
      appBar: OTRAppBar(),
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        itemBuilder: (context, position) {
          _currentPage.setAppBarActions([]);
          // HOME Atricle / Match info / links..
          if (_currentPage.navigationItem == OTRNavigation.home) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  OTRCorpusCarousel(),
                  const SizedBox(height: 1.0),
                  OTRStatMatchCurrent(),
                  const SizedBox(height: 1.0),
                  OTRBlockLinks(),
                ],
              ),
            );
          }
          // calendar / results
          if (_currentPage.navigationItem == OTRNavigation.calendar) {
            return ChangeNotifierProvider(
              builder: (_) => SeasonYear(
                  Provider.of<OTRProjects>(context).currentSeasonYear),
              child: OTRMatchCalendar(),
            );
          }

          if (_currentPage.navigationItem == OTRNavigation.players) {
            return OTRPlayersList(
                teamID: Provider.of<OTRProjects>(context).idPeopleTeamID);
          }

          // Display error (page not found)!
          return Text("OOps page '${_currentPage.getText()}' non disponible!",
              textAlign: TextAlign.center);
        },
      ),
      bottomNavigationBar: OTRBottomNavigationBar(),
    );
  }
}
