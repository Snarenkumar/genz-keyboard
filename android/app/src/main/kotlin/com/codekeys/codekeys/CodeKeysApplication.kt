package com.codekeys.codekeys

import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

/**
 * Application class that pre-warms a FlutterEngine for the keyboard IME service.
 * This reduces keyboard startup latency significantly.
 */
class CodeKeysApplication : FlutterApplication() {

    companion object {
        const val ENGINE_ID = "keyboard_engine"
    }

    override fun onCreate() {
        super.onCreate()
        // Pre-warm the Flutter engine for the keyboard service
        val flutterEngine = FlutterEngine(this)

        // Execute the keyboardMain entrypoint
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint(
                io.flutter.FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                "keyboardMain"
            )
        )

        // Cache the engine for retrieval by the IME service
        FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine)
    }
}
