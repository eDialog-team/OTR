import 'package:flutter/material.dart';

import 'package:otr_lib/screens/widgets/team_ranking_content.dart';

// When returning a Scaffold, I like to extract the widgets from the `screens`
// directory to the `widgets` dir.
// (OTRTeamRankingContent in this case)

class OTRTeamRanking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Classement"),
      ),
      body: OTRTeamRankingContent(),
    );
  }
}
