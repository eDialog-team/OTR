import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:otr_lib/common/projects.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class OTRBlockLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 5.0),
        SizedBox(
          height: 95.0,
          width: MediaQuery.of(context).size.width / 2,
          child: Card(
            child: InkWell(
              onTap: () async {
                await launch(Provider.of<OTRProjects>(context).billeterieUrl);
              },
              child: Container(
                // UNDER: image background
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            Provider.of<OTRProjects>(context).httpRoot +
                                "img/ticketing.jpg"))),
                // TOP: LinearGradient & text
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0, bottom: 6.0),
                      child: Text(
                        "Billetterie",
                        // title style
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 5.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 95.0,
          width: MediaQuery.of(context).size.width / 2 - 10,
          child: Card(
            child: InkWell(
              onTap: () {
                // Open arctile
                Navigator.of(context).pushNamed(
                  '/classement',
                );
              },
              child: Container(
                // UNDER: image background
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            Provider.of<OTRProjects>(context).httpRoot +
                                "img/ranking.jpg"))),
                // TOP: LinearGradient & text
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0, bottom: 6.0),
                      child: Text(
                        "Classement",
                        // title style
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 5.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
