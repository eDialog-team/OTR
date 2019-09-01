import 'package:flutter/material.dart';

import 'package:either_option/either_option.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:otr_lib/models/states.dart';
import 'package:otr_lib/models/player.dart';
import 'package:otr_lib/services/player.dart';
import 'package:otr_lib/screens/widgets/common.dart';
import 'package:otr_lib/common/projects.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

final Either<OTRState, List<Players>> _initialDataProvider =
    Left(OTRState.loading());
final Either<OTRState, List<Players>> _errorProvider =
    Left(OTRState.serverError());

class OTRPlayersList extends StatelessWidget {
  final String teamID;
  OTRPlayersList({@required this.teamID});

  @override
  Widget build(BuildContext context) {
    return FutureProvider.value(
      value: fetchPlayers(
        teamID: teamID,
      ),
      catchError: (context, error) {
        // Log the error
        print(error.toString());

        return _errorProvider;
      },
      child: _PlayersList(),
      initialData: _initialDataProvider,
    );
  }
}

class _PlayersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _players = Provider.of<Either<OTRState, List<Players>>>(context);

    // Error Case
    if (_players.isLeft &&
        _players.left.value.networkState == NetworkState.serverError) {
      if (!_players.left.value.errorDisplayed) {
        OTRUtils.errorFlushBar(
          message: "Error de chargement de l'Effectif",
          context: context,
        );
      }

      return Container(
        child: Center(child: Text("Error de chargement de l'Effectif")),
      );
    }

    // Loading Case
    if (_players.isLeft &&
        _players.left.value.networkState == NetworkState.loading) {
      return Column(
        children: <Widget>[
          SizedBox(height: 40),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
    }

    var _orderedByPositionplayers =
        PlayersUtils.orderByPosition(_players.right.value);

    var _indexPositionChanged =
        PlayersUtils.getHeaderIndexPos(_orderedByPositionplayers);

    return new ListView.builder(
      itemCount: _indexPositionChanged.length,
      itemBuilder: (context, index) {
        return StickyHeaderBuilder(
          builder: (BuildContext context, double stuckAmount) {
            // don't display header
            if (!_indexPositionChanged[index]) {
              return Container();
            }
            // header
            return new Container(
              height: 25.0,
              color: Theme.of(context).primaryColor,
              padding: new EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: new Text(
                "${_orderedByPositionplayers[index].position}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
          // each players
          content: new Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 0.2)),
            ),
            child: InkWell(
              onTap: () async {
                // Navigator.of(context).pushNamed(
                // '/profil',
                // arguments: _orderedByPositionplayers[index].people.id,
                // );

                await launch(Provider.of<OTRProjects>(context).starterUrl +
                    "profil/" +
                    _orderedByPositionplayers[index].people.id);
              },
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).buttonColor,
                    backgroundImage: CachedNetworkImageProvider(
                      Provider.of<OTRProjects>(context).httpRoot +
                          "ged/players/${_orderedByPositionplayers[index].id}.png",
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("${_orderedByPositionplayers[index].identifier}",
                          style: TextStyle(fontSize: 21)),
                      Text(
                          "${_orderedByPositionplayers[index].people.surname} ${_orderedByPositionplayers[index].people.name}"),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
