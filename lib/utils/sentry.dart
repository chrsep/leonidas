import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry/sentry.dart';

class Sentry {
  Sentry() {
    FlutterError.onError = (FlutterErrorDetails details) async {
      if (isInDebugMode) {
        // In development mode simply print to console.
        FlutterError.dumpErrorToConsole(details);
      } else {
        // In production mode report to the application zone to report to
        // Sentry.
        Zone.current.handleUncaughtError(details.exception, details.stack);
      }
    };
  }

  final SentryClient _sentry = SentryClient(dsn: DotEnv().env['SENTRY_DSN']);

  bool get isInDebugMode {
    bool inDebugMode = false;
    // Assert expressions are only evaluated during development. They are ignored
    // in production. Therefore, this code only sets `inDebugMode` to true
    // in a development environment.
    assert(inDebugMode = true);
    return inDebugMode;
  }

  /// Reports [error] along with its [stackTrace] to Sentry.io.
  // ignore: prefer_void_to_null
  Future<Null> reportError(dynamic error, dynamic stackTrace) async {
    print('Caught error: $error');

    await _sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }
}
