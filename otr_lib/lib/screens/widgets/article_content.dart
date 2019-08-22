import 'package:flutter/material.dart';

import 'package:either_option/either_option.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:otr_lib/screens/widgets/common.dart';
import 'package:otr_lib/common/states.dart';

import 'package:otr_lib/models/corpus.dart';
import 'package:otr_lib/models/article.dart';

import 'package:otr_lib/services/articles.dart';

import 'package:provider/provider.dart';

import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';

final unescape = HtmlUnescape();

final Either<OTRState, Article> _initialDataProvider = Left(OTRState.loading());
final Either<OTRState, Article> _errorProvider = Left(OTRState.serverError());

class OTRArticleContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureProvider.value(
      initialData: _initialDataProvider,
      value: fetchArticle(
        articleId: Provider.of<Media>(context).articleId,
      ),
      catchError: (_, error) {
        // Log the error
        print(error.toString());

        return _errorProvider;
      },
      child: _ArticleContent(),
    );
  }
}

class _ArticleContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _article = Provider.of<Either<OTRState, Article>>(context);
    final _media = Provider.of<Media>(context);

    // Error Case
    if (_article.isLeft &&
        _article.left.value.networkState == NetworkState.serverError) {
      OTRUtils.errorFlushBar(
        message: "Error de chargement de l'article",
        context: context,
        pop: true,
      );
    }

    const _dateSize = 30.0;
    const _imageSize = 115.0 + _dateSize;

    var _mediaDate = DateFormat("dd/MM/yyyy hh:mm:ss").parse(_media.creation);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // Scroll view
      child: SingleChildScrollView(
        //
        // When the column is inside a view that is scroll able, the column is trying
        // to shrink wrap its content but since you used Expanded as a child of the
        // column it is working opposite to the column trying to shrink wrap its
        // children. This is causing this error because these two directives are
        // completely opposite to each other.
        //
        child: ConstrainedBox(
          // Limmit the Column height size
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - _imageSize),
          child: IntrinsicHeight(
            // The article content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    // Image
                    SizedBox(
                      height: _imageSize,
                      child: Hero(
                        tag: "carousel_corpus_" + _media.id,
                        transitionOnUserGestures: true,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: _dateSize),
                          child: Container(
                            // UNDER: image background
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      _media.thumbnailUrl,
                                    ))),
                          ),
                        ),
                      ),
                    ),
                    // article creation bubble
                    Positioned(
                      top: _imageSize - (_dateSize * 2),
                      left: .0,
                      right: .0,
                      child: Align(
                        alignment: Alignment(0.90, 0),
                        child: CircleAvatar(
                          radius: 30,
                          child: Column(children: <Widget>[
                            Spacer(flex: 1),
                            Text(
                              DateFormat('d', "fr_FR").format(_mediaDate),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.5,
                              ),
                            ),
                            Text(
                              toBeginningOfSentenceCase(
                                  // uppercase first letter
                                  DateFormat('MMM', "fr_FR")
                                      .format(_mediaDate)),
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Spacer(flex: 2),
                          ]),
                        ),
                      ),
                    ),

                    // Created by
                    Positioned(
                      top: _imageSize - (_dateSize / 1.5),
                      left: 10.0,
                      right: .0,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          children: <Widget>[
                            // When loaded
                            if (_article.isRight) ...[
                              Icon(Icons.person, size: 18),
                              Text("Créer par "),
                              Text(_article.right.value.producer.alias,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  )),
                            ],
                            // When loading
                            if (_article.isLeft) ...[
                              Text("Chargement..",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  )),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // space
                Divider(height: 7.0),

                // loading
                if (_article.isLeft) // error or loading...
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // article content
                if (_article.isRight) ...[
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: Column(children: <Widget>[
                      //title
                      Text(
                        unescape.convert(_article.right.value.name),
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      // space
                      Divider(height: 7.0),

                      // content
                      // TODO: some image have relative url. Waiting for flutter_html v1.0.0
                      // https://github.com/Sub6Resources/flutter_html/wiki/Roadmap
                      // One v1.0.0 hits, the Html renderer will be customizable (customRender)
                      Html(
                        // clean-up the html
                        data:
                            unescape.convert(_article.right.value.description),
                        // detect color sytle of the node (returned by service)
                        // and apply it to the html node.
                        customTextStyle: _customTextStyle,
                        // open url in browser
                        onLinkTap: (url) async {
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            OTRUtils.errorFlushBar(
                              message: "Impossible d'ouvrir $url",
                              context: context,
                              postFrame: false,
                            );
                          }
                        },
                      ),
                      // btn open in browser
                      FlatButton(
                        color: Theme.of(context).primaryColorLight,
                        onPressed: () async {
                          await launch(_media.link);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Spacer(flex: 6),
                            Icon(Icons.launch, size: 18),
                            Spacer(flex: 1),
                            Text(
                              'Lire sur le site web',
                            ),
                            Spacer(flex: 6),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // parse a html node style and try to read a color attribute.
  // If a valid color attribute is found, return a modified TextStyle with the
  // color attribute found in the html node.
  TextStyle _customTextStyle(dom.Node node, TextStyle baseStyle) {
    // attribute
    var _customColor = node.attributes['style']
        ?.replaceAllMapped(RegExp(r'color.(#[\w]+);'), (Match m) => "${m[1]}");
    if (_customColor != null &&
        _customColor.contains(RegExp(r'^#[0-9a-fA-F]+$')) &&
        node is dom.Element) {
      return baseStyle.merge(TextStyle(
        color: HexColor(_customColor), // Change text color of that Elem
      ));
    }
    return baseStyle;
  }
}
