package io.chrsep.leonidas

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.sentry.Sentry
import io.sentry.android.AndroidSentryClientFactory
import java.lang.Exception

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Sentry.init(
                BuildConfig.SENTRYDSN,
                AndroidSentryClientFactory(applicationContext)
        )
        GeneratedPluginRegistrant.registerWith(this)
    }
}
