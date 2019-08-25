import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:either_option/either_option.dart';
import 'package:otr_lib/models/states.dart';
import 'package:otr_lib/models/stats.dart';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import 'package:otr_lib/app.dart';

final _requestUrl =
    "webservice/_proxy_stats.asp?uri=v1%2Fstats%2Fsoccer%2Ffran%2Fscores%2F&accept=json&languageId=6&v=";

// Copy root dio http client config
final _statdio = Dio(dio.options)
  // add custom interceptor for this ws
  ..interceptors.add(InterceptorsWrapper(
    // When the response data is empty (ws is kinda funky) it is a failure.
    onResponse: (Response response) async {
      if (response.data == "") {
        debugPrint("ERROR: " + response.request.uri.toString());
        // don't save the response in cache and serve request from the cache
        Response rejectResponse =
            await dio.reject("edialog stats.com PROXY error");
        return rejectResponse;
      }
      return response;
    },
  ))
// Copy root dio http interceptors (After the one above)
  ..interceptors.addAll(dio.interceptors);

class _Response {
  // TODO: if status != OK throw an exception
  static Either<OTRState, League> parse(String responseBody) {
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
    // TODO check of access to eventType is valid.
    return new Right(apiResults[0].league);
  }
}

Future<Either<OTRState, League>> fetchStats(
    {@required int year, bool useCache = true}) async {
  // with dio cache
  Response<String> response = await _statdio.get(
    _requestUrl,
    queryParameters: {
      "timestamp": (DateTime.now().millisecondsSinceEpoch / 1000).truncate(),
      "season": year,
    },
    // use cache
    options: buildCacheOptions(
      Duration(hours: 2), // cache directly
      maxStale: Duration(days: 3), // network first / if error fallback to cache
      primaryKey: "stats-dot-com-request-key-{$year}",
      subKey: "",
      forceRefresh: !useCache,
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
    // now = now.subtract(Duration(days: 11)); // for testing

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

  static final aVenirStr = "A venir";

  static String introduceMessage(Events event) {
    var now = new DateTime.now();
    var startDate = event.startDate[0];
    var eventStartDate = DateTime(startDate.year, startDate.month,
        startDate.date, startDate.hour ?? 0, startDate.minute ?? 0);

    if (now.difference(eventStartDate).inMinutes < 0) {
      return aVenirStr;
    }
    if (event.eventStatus.isActive) {
      return "En cours";
    }

    return "Dernier match";
  }

  static String eventStartDatePretty(Events event, {bool showHour = true}) {
    var startDate = event.startDate[0];
    var eventStartDate = DateTime(startDate.year, startDate.month,
        startDate.date, startDate.hour ?? 0, startDate.minute ?? 0);

    var format = 'EEEE d/MM';
    if (showHour) {
      format = 'EEEE d/MM à HH:mm';
    }
    return toBeginningOfSentenceCase(
        DateFormat(format, "fr_FR").format(eventStartDate));
  }

  static String eventScoreDispay(Events event) {
    // if event canceled
    if (event.eventStatus.eventStatusId == 5) {
      if (event.eventStatus.name.toLowerCase() == "postponed") {
        return "Reporté";
      }
      return "Annulé";
    }

    var message = introduceMessage(event);
    if (message == aVenirStr) {
      return message;
    }

    return "${event.teams[0].score} | ${event.teams[1].score}";
  }
}
