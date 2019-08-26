import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:either_option/either_option.dart';
import 'package:otr_lib/models/states.dart';
import 'package:otr_lib/models/ranking.dart';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import 'package:otr_lib/app.dart';

final _requestUrl =
    "webservice/_proxy_stats.asp?uri=v1%2Fstats%2Fsoccer%2Ffran%2Fstandings%2F&accept=json&languageId=6";

class _Response {
  // TODO: if status != OK throw an exception
  static Either<OTRState, List<Teams>> parse(String responseBody) {
    dynamic parsed = jsonDecode(responseBody);
    if (parsed.runtimeType == String) {
      // required, when using cache, need to parse twice
      parsed = jsonDecode(parsed);
    }

    if (responseBody.length == 0) {
      return Left(OTRState.serverError());
    }

    var teamNode = parsed['apiResults'][0]["league"]["season"]["eventType"][0]
        ["conferences"][0]["divisions"][0]["teams"];

    var teams = List<Teams>();
    teamNode.forEach((v) {
      teams.add(Teams.fromJson(v));
    });
    return Right(teams);
  }
}

Future<Either<OTRState, List<Teams>>> fetchRanking() async {
  Response<String> response = await dio.get(
    _requestUrl,
    queryParameters: {
      "timestamp": (DateTime.now().millisecondsSinceEpoch / 1000).truncate(),
    },
    // use cache
    options: buildCacheOptions(
      Duration(hours: 4), // cache directly
      maxStale: Duration(days: 3), // network first / if error fallback to cache
      primaryKey: "stats-ranking-dot-com-request-key",
      subKey: "",
    ),
  );
  debugPrint(response.request.uri.toString());
  return compute(_Response.parse, response.data);
}
