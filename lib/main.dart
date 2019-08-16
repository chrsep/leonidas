import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:leonidas/models/app_store.dart';
import 'package:leonidas/utils/sample_routine.dart';
import 'package:leonidas/utils/sentry.dart';
import 'package:provider/provider.dart';

import 'components/home_page.dart';

// main() is the entry point of dart programs, similar to C, use this function
// to instantiate anything on
// ignore: prefer_void_to_null
Future<Null> main() async {
  await DotEnv().load('.env');
  // Setup sentry
  final Sentry sentry = Sentry();

  // Report to sentry when error is detected
  // ignore: prefer_void_to_null
  runZoned<Future<Null>>(() async {
    runApp(Leonidas());
  }, onError: (dynamic error, dynamic stackTrace) async {
    await sentry.reportError(error, stackTrace);
  });
}

// Our application root widget, call this on test to render the whole App
class Leonidas extends StatelessWidget {
  final sampleData = generateSampleRoutine();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => AppStore([sampleData]),
        )
      ],
      child: MaterialApp(
        title: 'Leonidas',
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.redAccent,
        ),
        home: HomePage(),
      ),
    );
  }
}
