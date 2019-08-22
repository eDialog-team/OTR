import 'package:flutter/material.dart';

import 'package:otr_lib/screens/widgets/common.dart';
import 'package:otr_lib/screens/widgets/corpus_carousel.dart';
import 'package:otr_lib/screens/widgets/stat_match_info.dart';

class OTRAccueil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OTRAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          OTRCorpusCarousel(),
          const SizedBox(height: 1.0),
          OTRStatMatchInfo(),
        ],
      ),
      bottomNavigationBar: OTRBottomNavigationBar(),
    );
  }
}
