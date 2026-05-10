package com.github.hanzothegreat.refugium

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.github.hanzothegreat.refugium/nsd"
    private var nsdService: NsdService? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "registerService" -> {
                        val deviceId = call.argument<String>("deviceId") ?: ""
                        val port = call.argument<Int>("port") ?: 7890
                        nsdService = NsdService(applicationContext)
                        nsdService!!.registerService(
                            deviceId = deviceId,
                            port = port,
                            onSuccess = { result.success(true) },
                            onFailure = { result.error("NSD_ERROR", "Registration failed", null) }
                        )
                    }
                    "discoverServices" -> {
                        nsdService = nsdService ?: NsdService(applicationContext)
                        val discovered = mutableListOf<Map<String, Any>>()
                        nsdService!!.discoverServices(
                            onFound = { name, host, port ->
                                discovered.add(mapOf(
                                    "name" to name,
                                    "host" to host,
                                    "port" to port
                                ))
                                // Flutter via EventChannel informieren wäre besser,
                                // aber für MVP reicht polling
                            },
                            onLost = { name ->
                                discovered.removeAll { it["name"] == name }
                            }
                        )
                        result.success(discovered)
                    }
                    "stopServices" -> {
                        nsdService?.stop()
                        nsdService = null
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        nsdService?.stop()
        super.onDestroy()
    }
}