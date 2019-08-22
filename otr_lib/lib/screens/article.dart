import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:otr_lib/models/corpus.dart';
import 'package:otr_lib/screens/widgets/article_content.dart';
import 'package:otr_lib/screens/widgets/common.dart';

class OTRArticle extends StatelessWidget {
  final Media media;
  OTRArticle({
    @required this.media,
  });
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Media>.value(value: media),
      ],
      child: Scaffold(
        appBar: OTRAppBar(),
        body: OTRArticleContent(),
      ),
    );
  }
}
