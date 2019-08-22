import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import 'package:otr_lib/common/projects.dart';

import 'package:otr_lib/route_generator.dart';

import 'package:otr_lib/models/current_page.dart';
import 'package:intl/date_symbol_data_local.dart';

final dio = Dio();

@immutable
class OTRApp extends StatelessWidget {
  final OTRProjects _project;

  // Setup DIO (http clients)
  void _setup() async {
    // base url
    dio.options.baseUrl = _project.httpRoot;

    // cache http request
    dio.interceptors.add(DioCacheManager(CacheConfig()).interceptor);

    await initializeDateFormatting("fr_FR", null);
  }

  OTRApp(this._project) {
    _setup();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => CurrentPage()),
        Provider<OTRProjects>.value(value: _project),
      ],
      child: MaterialApp(
        title: _project.projectName,
        theme: _project.themeData,
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
