import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:either_option/either_option.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:otr_lib/common/projects.dart';
import 'package:otr_lib/models/states.dart';
import 'package:otr_lib/services/ranking.dart';
import 'package:otr_lib/models/ranking.dart';
// import 'package:otr_lib/common/projects.dart';
import 'package:otr_lib/screens/widgets/common.dart';

final Either<OTRState, List<Teams>> _initialDataProvider =
    Left(OTRState.loading());
final Either<OTRState, List<Teams>> _errorProvider =
    Left(OTRState.serverError());

class OTRTeamRankingContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final _currentSeasonYear =
    // Provider.of<OTRProjects>(context).currentSeasonYear;
    return FutureProvider.value(
      value: fetchRanking(),
      catchError: (context, error) {
        // Log the error
        print(error.toString());

        return _errorProvider;
      },
      child: _RankingList(),
      initialData: _initialDataProvider,
    );
  }
}

class _RankingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ranking = Provider.of<Either<OTRState, List<Teams>>>(context);

    // Error Case
    if (_ranking.isLeft &&
        _ranking.left.value.networkState == NetworkState.serverError) {
      if (!_ranking.left.value.errorDisplayed) {
        OTRUtils.errorFlushBar(
          message: "Error de chargement du classement",
          context: context,
        );
      }

      return Container(
        child: Center(child: Text("Error de chargement du classement")),
      );
    }

    // Loading Case
    if (_ranking.isLeft &&
        _ranking.left.value.networkState == NetworkState.loading) {
      return Column(
        children: <Widget>[
          SizedBox(height: 40),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
    }

    final _teams = _ranking.right.value;
    final _teamId = Provider.of<OTRProjects>(context).teamID;

    return SingleChildScrollView(
      child: FittedBox(
        child: DataTable(
          columnSpacing: 2.0,
          horizontalMargin: 17.0,
          columns: <DataColumn>[
            DataColumn(label: Container()),
            DataColumn(label: const Text('Clubs')),
            DataColumn(
                label: const Text('MJ'),
                numeric: true,
                tooltip: "Matches joué"),
            DataColumn(
                label: const Text('G'), numeric: true, tooltip: "Gagnés"),
            DataColumn(label: const Text('N'), numeric: true, tooltip: "Nuls"),
            DataColumn(
                label: const Text('P'), numeric: true, tooltip: "Perdus"),
            DataColumn(
                label: const Text('Pts',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                numeric: true)
          ],
          rows: [
            for (var team in _teams)
              DataRow(
                cells: <DataCell>[
                  DataCell(Text("${team.league.rank.toString().padLeft(2)}",
                      style: team.teamId == _teamId
                          ? TextStyle(color: Theme.of(context).primaryColor)
                          : TextStyle())),
                  DataCell(
                    Row(children: [
                      CachedNetworkImage(
                        height: 24,
                        imageUrl: Provider.of<OTRProjects>(context).httpRoot +
                            "img/ligue1/${team.abbreviation}.png",
                      ),
                      SizedBox(width: 13),
                      Container(
                        width: 110,
                        child: AutoSizeText(team.displayName.trimLeft(),
                            maxLines: 2,
                            minFontSize: 9,
                            style: team.teamId == _teamId
                                ? TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w700)
                                : TextStyle()),
                      ),
                    ]),
                  ),
                  DataCell(Text("${team.record.gamesPlayed}")),
                  DataCell(Text("${team.record.wins}",
                      style: TextStyle(fontWeight: FontWeight.w600))),
                  DataCell(Text("${team.record.ties}")),
                  DataCell(Text("${team.record.losses}")),
                  DataCell(Text("${team.teamPoints}",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark))),
                ],
              )
          ],
        ),
      ),
    );
  }
}
