import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:either_option/either_option.dart';
import 'package:otr_lib/common/states.dart';

import 'package:otr_lib/models/corpus.dart';
import 'package:otr_lib/app.dart';

final _requestUrl =
    "webservice/corpuses/_item.asp?id=C58A489B-BA43-415B-A423-33EED56D68D3&xsl=corpus.json.xsl&v=2.0.6&_=1527328500088";

class _Response {
  // TODO if type != true throw an exception
  static Either<OTRState, Corpus> parse(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return new Right(Corpus.fromJson(parsed['corpus']));
  }
}

Future<Either<OTRState, Corpus>> fetchCorpusSlider() async {
  // no cache
  Response<String> response = await dio.get(_requestUrl);
  debugPrint(response.request.uri.toString());
  return compute(_Response.parse, response.data);
}
