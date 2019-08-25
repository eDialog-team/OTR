import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:either_option/either_option.dart';
import 'package:otr_lib/models/states.dart';

import 'package:otr_lib/models/article.dart';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import 'package:otr_lib/app.dart';

final _requestUrl =
    "webservice/articles/_item.asp?deep=1&xsl=article.json.xsl&v=&_=1565967077777";

class _Response {
  // TODO: if type != true throw an exception
  static Either<OTRState, Article> parse(String responseBody) {
    dynamic parsed = jsonDecode(responseBody);
    if (parsed.runtimeType == String) {
      // required, when using cache, need to parse twice
      parsed = jsonDecode(parsed);
    }

    return new Right(Article.fromJson(parsed['article']));
  }
}

Future<Either<OTRState, Article>> fetchArticle({
  @required String articleId,
}) async {
  // with dio cache
  Response<String> response = await dio.get(
    _requestUrl,
    queryParameters: {"id": articleId},
    options: buildCacheOptions(
      Duration(hours: 9), // cache directly
      maxStale: Duration(days: 3), // network first / if error fallback to cache
    ),
  );
  debugPrint(response.request.uri.toString());
  return compute(_Response.parse, response.data);
}
