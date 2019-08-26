import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:either_option/either_option.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:otr_lib/screens/widgets/common.dart';

import 'package:otr_lib/models/states.dart';
import 'package:otr_lib/models/corpus.dart';
import 'package:otr_lib/models/current_page.dart';
import 'package:otr_lib/services/corpus.dart';

import 'package:provider/provider.dart';

final unescape = HtmlUnescape();
final RegExp deleteHtmlTagsnew = RegExp(r"<[^>]*>");

final Either<OTRState, Corpus> _initialDataProvider = Left(OTRState.loading());
final Either<OTRState, Corpus> _errorProvider = Left(OTRState.serverError());

class OTRCorpusCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureProvider.value(
      value: fetchCorpusSlider(),
      catchError: (_, error) {
        // Log the error
        print(error.toString());

        return _errorProvider;
      },
      child: _CorpusCarousel(),
      initialData: _initialDataProvider,
    );
  }
}

const _textShadow = <Shadow>[
  Shadow(
    offset: Offset(2.0, 2.0),
    blurRadius: 6.0,
    color: Color.fromARGB(255, 0, 0, 0),
  ),
];

class _CorpusCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _carouselCorpus = Provider.of<Either<OTRState, Corpus>>(context);
    // loading
    if (_carouselCorpus.isLeft &&
        _carouselCorpus.left.value.networkState == NetworkState.loading) {
      return SizedBox(
          height: 200.0,
          child: Center(
            child: CircularProgressIndicator(),
          ));
    }

    if (_carouselCorpus.isLeft &&
        _carouselCorpus.left.value.networkState == NetworkState.serverError) {
      OTRUtils.errorFlushBar(
        message: "Error de chargement des articles",
        context: context,
      );

      return Container();
    }

    var _medias = _carouselCorpus.right.value.medias;

    if (_medias.length == 0) {
      if (_carouselCorpus.isLeft &&
          _carouselCorpus.left.value.networkState == NetworkState.serverError) {
        OTRUtils.errorFlushBar(
          message: "Pas d'articles trouvés",
          context: context,
        );

        return Container();
      }
    }

    // media loaded
    return SizedBox(
      height: 200.0,
      child: Swiper(
        outer: false,
        pagination: SwiperPagination(margin: EdgeInsets.all(8.0)),
        itemCount: _medias.length,
        onTap: (i) {
          var _currentPage = Provider.of<MainPagePosition>(context);

          // Open arctile
          Navigator.of(context).pushNamed(
            '/article',
            arguments: _medias[i],
          );
        },
        itemBuilder: (context, i) {
          return Hero(
              tag: "carousel_corpus_" + _medias[i].id,
              transitionOnUserGestures: true,
              child: Container(
                  // UNDER: image background
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            _medias[i].thumbnailUrl,
                          ))),
                  // TOP: LinearGradient & text
                  child: Container(
                      padding: EdgeInsets.only(
                          bottom: 30.0, left: 14.0, right: 14.0),
                      // gradient
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter * 0.7,
                          stops: [0.0, 10.0],
                          colors: [
                            Colors.black87.withOpacity(0.9),
                            Colors.black87.withOpacity(0.0)
                          ],
                        ),
                      ),
                      // Text
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Material(
                              type: MaterialType.transparency,
                              child: Text(
                                _medias[i].name,
                                // title style
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  shadows: _textShadow,
                                ),
                              ),
                            ),
                            Material(
                              type: MaterialType.transparency,
                              child: Text(
                                unescape
                                    .convert(_medias[i].description)
                                    .replaceAll(deleteHtmlTagsnew, ""),
                                // description style
                                style: TextStyle(
                                  fontSize: 18.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: _textShadow,
                                ),
                              ),
                            ),
                          ]))));
        },
      ),
    );
  }
}
