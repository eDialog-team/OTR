import 'package:flutter/material.dart';

import 'package:either_option/either_option.dart';

import 'package:otr_lib/models/stats.dart';
import 'package:otr_lib/services/stats.dart';
import 'package:otr_lib/common/states.dart';
import 'package:otr_lib/common/projects.dart';
import 'package:otr_lib/screens/widgets/common.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:otr_lib/app.dart';

import 'package:provider/provider.dart';

final Either<OTRState, List<Events>> _initialDataProvider =
    Left(OTRState.loading());
final Either<OTRState, List<Events>> _errorProvider =
    Left(OTRState.serverError());

class OTRStatMatchInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureProvider.value(
      value: fetchStats(),
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
    final _stats = Provider.of<Either<OTRState, List<Events>>>(context);

    // Error Case
    if (_stats.isLeft &&
        _stats.left.value.networkState == NetworkState.serverError) {
      if (!_stats.left.value.errorDisplayed) {
        OTRUtils.errorFlushBar(
          message: "Error de chargement du dernier match",
          context: context,
        );
        _stats.left.value.errorProcessed();
      }

      return Container();
    }
    if (_stats.isLeft &&
        _stats.left.value.networkState == NetworkState.loading) {
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
    var events =
        Stats.filterEventsForTeamID(_stats.right.value, _project.teamID);

    var event = Stats.closestEvent(events);

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
                    Stats.introduceMessage(event),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.display4.color),
                  ),
                  // Date
                  Text(
                    Stats.eventStartDatePretty(event),
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).textTheme.display4.color),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 90.0,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...teamLogoName(event.teams[0]),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text("Ligue 1 - J03",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 11.0)),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      ...teamLogoName(event.teams[1]),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  teamLogoName(Teams team) {
    return [
      // Logo team
      CachedNetworkImage(
        imageUrl: dio.options.baseUrl + "img/ligue1/${team.abbreviation}.png",
        width: 46.0,
        height: 46.0,
        fit: BoxFit.cover,
      ),
      // Text
      Container(
        width: 90.0,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Wrap when team name too long
            Flexible(
              child: Text(
                team.displayName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: team.displayName.length > 9 ? 10.0 : 13.0,
                ),
              ),
            ),
          ],
        ),
      )
    ];
  }
}
