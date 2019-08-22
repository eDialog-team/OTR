import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:either_option/either_option.dart';
import 'package:otr_lib/common/states.dart';

import 'package:otr_lib/models/stats.dart';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import 'package:otr_lib/app.dart';

final _requestUrl =
    "webservice/_proxy_stats.asp?uri=v1%2Fstats%2Fsoccer%2Ffran%2Fscores%2F&season=2019&accept=json&timestamp=1566315421&languageId=6&v=";

// Copy root dio http client config
final _statdio = Dio(dio.options)
  // add custom interceptor for this ws
  ..interceptors.add(InterceptorsWrapper(
    // When the response data is empty (ws is kinda funky) it mean should fail
    onResponse: (Response response) {
      if (response.data == "") {
        debugPrint("ERROR: " + response.request.uri.toString());
        return dio.reject("edialog stats.com PROXY error");
      }
      return response;
    },
  ))
// Copy root dio http interceptors (After the one above)
  ..interceptors.addAll(dio.interceptors);

class _Response {
  // TODO: if status != OK throw an exception
  static Either<OTRState, List<Events>> parse(String responseBody) {
    dynamic parsed = jsonDecode(responseBody);
    if (parsed.runtimeType == String) {
      // required, when using cache, need to parse twice
      parsed = jsonDecode(parsed);
    }

    if (responseBody.length == 0) {
      return new Left(OTRState.serverError());
    }

    var apiResults = new List<ApiResults>();
    if (parsed['apiResults'] != null) {
      parsed['apiResults'].forEach((v) {
        apiResults.add(new ApiResults.fromJson(v));
      });
    }
    print(apiResults[0].league.toJson().toString());

    // TODO check of access to eventType is valid.
    return new Right(apiResults[0].league.season.eventType[0].events);
  }
}

Future<Either<OTRState, List<Events>>> fetchStats() async {
  // with dio cache
  Response<String> response = await _statdio.get(
    _requestUrl,
    // use cache
    options: buildCacheOptions(
      Duration(hours: 1), // cache directly
      maxStale: Duration(days: 7), // network first / if error fallback to cache
    ),
  );
  debugPrint(response.request.uri.toString());
  return compute(_Response.parse, response.data);
}

class Stats {
  static List<Events> filterEventsForTeamID(List<Events> events, teamID) {
    return events
        .where((e) => e.teams.map((t) => t.teamId).contains(teamID))
        .toList();
  }

  static Events closestEvent(List<Events> events) {
    var now = new DateTime.now();

    var eventsWithDate = events.map((e) {
      var startDate = e.startDate[0];
      var date = DateTime(startDate.year, startDate.month, startDate.date);
      return [e, date];
    }).toList();

    var event = eventsWithDate.first;
    for (var eve in eventsWithDate) {
      if (now.difference(eve[1]).abs() <= now.difference(event[1]).abs()) {
        event = eve;
      }
    }
    return event[0];
  }

  static String introduceMessage(Events event) {
    var now = new DateTime.now();
    var endDate = event.startDate[0];
    var startDate = event.startDate[1];
    var eventStartDate = DateTime(startDate.year, startDate.month,
        startDate.date, startDate.hour, startDate.minute);
    var eventEndDate = DateTime(endDate.year, endDate.month, endDate.date,
        endDate.hour, endDate.minute);

    if (now.difference(eventStartDate).inHours < 0) {
      return "A venir";
    }
    if (now.difference(eventStartDate).inMinutes > 0 &&
        now.difference(eventEndDate).inMinutes < 0) {
      return "En cours";
    }

    return "Dernier match";
  }

  static String eventStartDatePretty(Events event) {
    var startDate = event.startDate[1];
    var eventStartDate = DateTime(startDate.year, startDate.month,
        startDate.date, startDate.hour, startDate.minute);
    return toBeginningOfSentenceCase(
        DateFormat('EEEE d/MM à HH:mm', "fr_FR").format(eventStartDate));
  }
}
