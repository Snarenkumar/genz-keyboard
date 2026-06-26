package com.codekeys.codekeys

import android.inputmethodservice.InputMethodService
import android.view.KeyEvent
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

/**
 * CodeKeys Input Method Service.
 * Hosts a FlutterView inside the system keyboard area and bridges
 * Flutter key events to the Android InputConnection.
 */
class CodeKeysIME : InputMethodService() {

    private var flutterEngine: FlutterEngine? = null
    private var flutterView: FlutterView? = null
    private var methodChannel: MethodChannel? = null
    private var engineFromCache = false

    override fun onCreate() {
        super.onCreate()

        // Try to get the pre-warmed engine from cache
        val cachedEngine = FlutterEngineCache.getInstance().get(CodeKeysApplication.ENGINE_ID)
        if (cachedEngine != null) {
            flutterEngine = cachedEngine
            engineFromCache = true
        } else {
            // Fallback: create a new engine
            flutterEngine = FlutterEngine(this)
            flutterEngine!!.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint(
                    io.flutter.FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                    "keyboardMain"
                )
            )
            engineFromCache = false
        }

        // Set up the method channel for communication with Flutter
        setupMethodChannel()
    }

    private fun setupMethodChannel() {
        val engine = flutterEngine ?: return
        methodChannel = MethodChannel(engine.dartExecutor.binaryMessenger, "com.codekeys/ime")
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "insertText" -> {
                    val text = call.argument<String>("text") ?: ""
                    val ic = currentInputConnection
                    ic?.commitText(text, 1)
                    result.success(null)
                }

                "deleteBackward" -> {
                    val count = call.argument<Int>("count") ?: 1
                    val ic = currentInputConnection
                    ic?.deleteSurroundingText(count, 0)
                    result.success(null)
                }

                "sendKeyEvent" -> {
                    val keyCode = call.argument<Int>("keyCode") ?: 0
                    val ic = currentInputConnection
                    ic?.sendKeyEvent(KeyEvent(KeyEvent.ACTION_DOWN, keyCode))
                    ic?.sendKeyEvent(KeyEvent(KeyEvent.ACTION_UP, keyCode))
                    result.success(null)
                }

                "moveCursor" -> {
                    val offset = call.argument<Int>("offset") ?: 0
                    val ic = currentInputConnection
                    if (ic != null) {
                        // Get current cursor position
                        val extracted = ic.getExtractedText(
                            android.view.inputmethod.ExtractedTextRequest(), 0
                        )
                        if (extracted != null) {
                            val currentPos = extracted.selectionStart
                            val newPos = currentPos + offset
                            ic.setSelection(newPos, newPos)
                        }
                    }
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onCreateInputView(): View {
        val engine = flutterEngine ?: return FrameLayout(this)

        // Create a container
        val container = FrameLayout(this).apply {
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                (300 * resources.displayMetrics.density).toInt() // ~300dp height
            )
        }

        // Create and attach FlutterView
        flutterView = FlutterView(this)
        flutterView?.attachToFlutterEngine(engine)

        container.addView(
            flutterView,
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
            )
        )

        // Notify Flutter that we are active
        engine.lifecycleChannel.appIsResumed()

        return container
    }

    override fun onStartInputView(info: android.view.inputmethod.EditorInfo?, restarting: Boolean) {
        super.onStartInputView(info, restarting)
        flutterEngine?.lifecycleChannel?.appIsResumed()
    }

    override fun onFinishInputView(finishingInput: Boolean) {
        super.onFinishInputView(finishingInput)
        flutterEngine?.lifecycleChannel?.appIsPaused()
    }

    override fun onDestroy() {
        flutterView?.detachFromFlutterEngine()
        flutterView = null

        // Only destroy the engine if we created it (not from cache)
        if (!engineFromCache) {
            flutterEngine?.destroy()
        }
        flutterEngine = null

        super.onDestroy()
    }
}
