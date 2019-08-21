import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:leonidas/leonidas_theme.dart';
import 'package:leonidas/models/app_store.dart';
import 'package:leonidas/models/countdown_timer.dart';
import 'package:leonidas/utils/initialize_data.dart';
import 'package:leonidas/utils/sentry.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          builder: (_) {
            final store = AppStore([sampleData]);
            final prefs = SharedPreferences.getInstance();
            prefs.then((prefs) {
              return prefs.getInt('current_cycle_idx');
            }).then((currentCycleIdx) {
              if(currentCycleIdx != null) {
                store.currentCycleIdx = currentCycleIdx;
              }
            });
            prefs.then((prefs) {
              return prefs.getInt('current_session_idx');
            }).then((currentSessionIdx) {
              if(currentSessionIdx != null) {
                store.currentSessionIdx = currentSessionIdx;
              }
            });
            return store;
          },
        ),
        ChangeNotifierProvider(
          builder: (_) => CountdownTimer(),
        )
      ],
      child: MaterialApp(
        title: 'Leonidas',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: LeonidasTheme.primaryColor,
          accentColor: LeonidasTheme.accentColor,
        ),
        home: HomePage(),
      ),
    );
  }
}
