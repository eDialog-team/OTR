import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:either_option/either_option.dart';
import 'package:otr_lib/models/states.dart';
import 'package:otr_lib/models/player.dart';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import 'package:otr_lib/app.dart';

final _requestUrl = "webservice/players/_search.asp?xsl=players.json.xsl";

class _Response {
  // TODO: if status != OK throw an exception
  static Either<OTRState, List<Players>> parse(String responseBody) {
    dynamic parsed = jsonDecode(responseBody);
    if (parsed.runtimeType == String) {
      // required, when using cache, need to parse twice
      parsed = jsonDecode(parsed);
    }

    if (responseBody.length == 0) {
      return Left(OTRState.serverError());
    }

    var teams = List<Players>();
    parsed["players"].forEach((v) {
      teams.add(Players.fromJson(v));
    });
    return Right(teams);
  }
}

Future<Either<OTRState, List<Players>>> fetchPlayers(
    {@required String teamID}) async {
  Response<String> response = await dio.get(
    _requestUrl,
    queryParameters: {
      "idTeam": teamID,
    },
    // use cache
    options: buildCacheOptions(
      Duration(hours: 4), // cache directly
      maxStale: Duration(days: 3), // network first / if error fallback to cache
    ),
  );
  debugPrint(response.request.uri.toString());
  return compute(_Response.parse, response.data);
}

class PlayersUtils {
  static List<Players> orderByPosition(List<Players> list) {
    List<Players> clone = []..addAll(list);
    clone.sort((Players a, Players b) => a.position.compareTo(b.position));
    return clone;
  }

  static List<bool> getHeaderIndexPos(List<Players> list) {
    List<bool> _indexPositionChanged = [];
    var _lastPosition = "NotAPosition";
    for (var player in list) {
      _indexPositionChanged.add(_lastPosition != player.position);
      _lastPosition = player.position;
    }
    return _indexPositionChanged;
  }
}
