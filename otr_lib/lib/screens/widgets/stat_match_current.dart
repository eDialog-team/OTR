import 'package:flutter/material.dart';

import 'package:either_option/either_option.dart';

import 'package:otr_lib/models/stats.dart';
import 'package:otr_lib/services/stats.dart';
import 'package:otr_lib/models/states.dart';
import 'package:otr_lib/common/projects.dart';
import 'package:otr_lib/screens/widgets/common.dart';
import 'package:otr_lib/screens/widgets/score_card.dart';

import 'package:provider/provider.dart';

final Either<OTRState, League> _initialDataProvider = Left(OTRState.loading());
final Either<OTRState, League> _errorProvider = Left(OTRState.serverError());

class OTRStatMatchCurrent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _project = Provider.of<OTRProjects>(context);
    return FutureProvider.value(
      value: fetchStats(year: 2019, useCache: _project.useCache),
      catchError: (context, error) {
        // Log the error
        print(error.toString());

        return _errorProvider;
      },
      child: _MatchInfoRecap(),
      initialData: _initialDataProvider,
    );
  }
}

class _MatchInfoRecap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _league = Provider.of<Either<OTRState, League>>(context);

    // Error Case
    if (_league.isLeft &&
        _league.left.value.networkState == NetworkState.serverError) {
      if (!_league.left.value.errorDisplayed) {
        OTRUtils.errorFlushBar(
          message: "Error de chargement du dernier match",
          context: context,
        );
        _league.left.value.errorProcessed();
      }

      return Container();
    }
    if (_league.isLeft &&
        _league.left.value.networkState == NetworkState.loading) {
      return Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 25,
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Chargement",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.display4.color),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final _project = Provider.of<OTRProjects>(context);
    final _event = _league.right.value.season.eventType[0].events;

    var events = StatsUtils.filterEventsForTeamID(_event, _project.teamID);

    var event = StatsUtils.closestEvent(events);

    // disable cache when the event is active (refresh result)
    //  When this widget will get redrawn, cache is ignored.
    if (event.eventStatus.isActive) {
      _project.disableCache();
    } else {
      _project.enableCache();
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 25,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // A venir / En cours / Dernier match
                  Text(
                    StatsUtils.introduceMessage(event),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.display4.color),
                  ),
                  // Date
                  Text(
                    StatsUtils.eventStartDatePretty(event),
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).textTheme.display4.color),
                  ),
                ],
              ),
            ),
          ),
          OTRStatMatchScoreCard(
              event: event, leagueName: _league.right.value.name),
        ],
      ),
    );
  }
}
