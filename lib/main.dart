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
  Future<AppStore> createStore() async {
    final sampleData = generateSampleRoutine();
    final sampleWeightSetup = generateSampleWeightSetup();
    final prefs = await SharedPreferences.getInstance();
    final currentStageIdx = prefs.getInt('current_stage_idx') ?? 0;
    final currentSessionIdx = prefs.getInt('current_session_idx') ?? 0;
    return AppStore(
      [sampleData],
      [sampleWeightSetup],
      currentStageIdx,
      currentSessionIdx,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: createStore(),
      builder: (context, AsyncSnapshot<AppStore> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            title: 'Leonidas',
            home: Scaffold(),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              builder: (_) {
                return snapshot.data;
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
              primaryColor: LeonidasTheme.blue,
              accentColor: LeonidasTheme.accentColor,
            ),
            home: HomePage(),
          ),
        );
      },
    );
  }
}
