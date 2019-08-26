import 'package:flutter/material.dart';

import 'package:otr_lib/models/stats.dart';
import 'package:otr_lib/services/stats.dart';
import 'package:otr_lib/common/projects.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

final stopWords = ["France"];

class OTRStatMatchScoreCard extends StatelessWidget {
  final Events event;
  final String leagueName;
  final bool displayDate;
  OTRStatMatchScoreCard(
      {this.event, this.leagueName, this.displayDate = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await launch(Provider.of<OTRProjects>(context).starterUrl +
            "matches/${event.eventId}/dashboard");
      },
      child: Container(
        height: 90.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Team 1
              Column(
                children: <Widget>[
                  ...teamLogoName(context, event.teams[0]),
                ],
              ),
              Column(
                children: <Widget>[
                  // add date
                  if (displayDate) ...[
                    Text(
                      StatsUtils.eventStartDatePretty(event, showHour: false),
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                  // Text ligue name
                  Container(
                    width: 70.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Wrap when team name too long
                        Flexible(
                          child: Text(
                            leagueName
                                    .split(" ")
                                    .where((e) => !stopWords.contains(e))
                                    .join(" ") +
                                " - J" +
                                event.week.toString().padLeft(2, "0"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 9.0,
                  ),
                  // Score
                  Container(
                    height: 25,
                    color: Colors.black12,
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          StatsUtils.eventScoreDispay(event),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Team 2
              Column(
                children: <Widget>[
                  ...teamLogoName(context, event.teams[1]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  teamLogoName(BuildContext context, Teams team) {
    return [
      // Logo team
      CachedNetworkImage(
        imageUrl: Provider.of<OTRProjects>(context).httpRoot +
            "img/ligue1/${team.abbreviation}.png",
        width: 45,
        height: 45,
        fit: BoxFit.cover,
      ),
      // Text
      Expanded(
        child: Container(
          width: 70.0,
          child: Center(
            child: AutoSizeText(
              team.displayName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
              minFontSize: 8,
              maxLines: 2,
            ),
          ),
        ),
      ),
      SizedBox(
        height: 2.0,
      ),
    ];
  }
}
