package com.codekeys.codekeys

import android.content.Intent
import android.provider.Settings
import android.view.inputmethod.InputMethodManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Main activity for the CodeKeys app (settings/setup screen).
 * Provides platform channel methods to open system keyboard settings.
 */
class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.codekeys/app"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openInputMethodSettings" -> {
                        val intent = Intent(Settings.ACTION_INPUT_METHOD_SETTINGS)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(null)
                    }

                    "openInputMethodPicker" -> {
                        val imm = getSystemService(INPUT_METHOD_SERVICE) as InputMethodManager
                        imm.showInputMethodPicker()
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
