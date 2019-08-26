import 'package:flutter/material.dart';

import 'package:either_option/either_option.dart';

import 'package:intl/intl.dart';

import 'package:otr_lib/models/states.dart';
import 'package:otr_lib/models/stats.dart';
import 'package:otr_lib/services/stats.dart';
import 'package:otr_lib/screens/widgets/common.dart';
import 'package:otr_lib/common/projects.dart';
import 'package:otr_lib/screens/widgets/score_card.dart';
import 'package:otr_lib/models/current_page.dart';

import 'package:provider/provider.dart';

final Either<OTRState, League> _initialDataProvider = Left(OTRState.loading());
final Either<OTRState, League> _errorProvider = Left(OTRState.serverError());

class OTRMatchCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _seasonYear = Provider.of<SeasonYear>(context);
    final _currentSeasonYear =
        Provider.of<OTRProjects>(context).currentSeasonYear;

    // decrement year btn
    final _currentPage = Provider.of<MainPagePosition>(context);

    _currentPage.setAppBarActions([
      SizedBox(
        width: 60,
        child: FlatButton(
          textColor: Colors.white,
          onPressed: () {
            _seasonYear.increment();
          },
          child: Icon(Icons.arrow_left),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent)),
        ),
      ),
      SizedBox(
        width: 60,
        child: FlatButton(
          textColor: Colors.white,
          onPressed: () {
            _seasonYear.decrement();
          },
          child: Icon(Icons.arrow_right),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent)),
        ),
      ),
    ]);

    return FutureProvider.value(
      value: fetchStats(
        year: _seasonYear.year,
        cacheForever: _seasonYear.year !=
            _currentSeasonYear, // always cache previous season stats
      ),
      catchError: (context, error) {
        // Log the error
        print(error.toString());

        return _errorProvider;
      },
      child: _MatchList(),
      initialData: _initialDataProvider,
    );
  }
}

class _MatchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _league = Provider.of<Either<OTRState, League>>(context);

    final _seasonYear = Provider.of<SeasonYear>(context);

    // Error Case
    if (_league.isLeft &&
        _league.left.value.networkState == NetworkState.serverError) {
      if (!_league.left.value.errorDisplayed) {
        OTRUtils.errorFlushBar(
          message: "Error de chargement du calendrier de ${_seasonYear.year}",
          context: context,
          after: (() {
            _seasonYear.increment();
            _league.left.value.errorProcessed();
          }),
        );
      }

      return Container(
        child: Center(
            child: Text(
                "Error de chargement du calendrier de ${_seasonYear.year}")),
      );
    }

    // Loading Case
    if (_league.isLeft &&
            _league.left.value.networkState == NetworkState.loading ||
        // Also check if we are on current season year!!
        _seasonYear.year != _league.right.value.season.season) {
      return Column(
        children: <Widget>[
          SizedBox(height: 40),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
    }

    final _project = Provider.of<OTRProjects>(context);
    final _event = _league.right.value.season.eventType[0].events;
    final _events = StatsUtils.filterEventsForTeamID(_event, _project.teamID);

    if (_events.length == 0) {
      OTRUtils.errorFlushBar(
        message:
            "Aucun match n'a été récupéré pour la saison ${_seasonYear.year}",
        context: context,
        after: (() {
          _seasonYear.increment();
        }),
      );
    }

    int _month = -1;

    // has content case
    return ListView.separated(
      itemCount: _events.length,
      // separator (month year)
      itemBuilder: (context, index) {
        var _m = _events[index].startDate[0].month;
        if (_month != _m) {
          _month = _events[index].startDate[0].month;
          var startDate = _events[index].startDate[0];
          return Container(
            color: Colors.black12.withAlpha(8),
            height: 28.0,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(
                    toBeginningOfSentenceCase(DateFormat("MMMM yyyy", "fr_FR")
                        .format(DateTime(startDate.year, startDate.month))),
                    style: TextStyle(fontSize: 19.0, color: Colors.black87))),
          );
        }

        // since I swaped separatorBuilder and itemBuilder (in order to have the separator at the top)
        // I need to display the last item here
        if (index == _events.length - 1) {
          // match card
          return Card(
            margin: const EdgeInsets.only(
                top: 3.0, bottom: 3.0, left: 7.0, right: 7.0),
            child: OTRStatMatchScoreCard(
              event: _events[index],
              leagueName: _league.right.value.name,
              displayDate: true,
            ),
          );
        }

        return Container();
      },
      // match card
      separatorBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(
              top: 3.0, bottom: 3.0, left: 7.0, right: 7.0),
          child: OTRStatMatchScoreCard(
            event: _events[index],
            leagueName: _league.right.value.name,
            displayDate: true,
          ),
        );
      },
    );
  }
}

class SeasonYear with ChangeNotifier {
  int _start = 2019;
  int _year;
  int get year => _year;

  SeasonYear(int year) {
    this._start = year;
    this._year = year;
  }

  void decrement() {
    _year--;
    notifyListeners();
  }

  void increment() {
    if (_start > year) {
      _year++;
      notifyListeners();
    }
  }
}
