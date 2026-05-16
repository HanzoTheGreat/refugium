package com.github.hanzothegreat.refugium

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val NSD_CHANNEL = "com.github.hanzothegreat.refugium/nsd"
    private val SYNC_CHANNEL = "com.github.hanzothegreat.refugium/sync"
    private var nsdService: NsdService? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Engine cachen damit RefugiumForegroundService sie findet
        // wenn die App im Hintergrund ist aber der Prozess noch lebt.
        FlutterEngineCache.getInstance().put(
            RefugiumForegroundService.FLUTTER_ENGINE_ID,
            flutterEngine
        )

        // NSD Channel (unverändert)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NSD_CHANNEL)
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

        // Sync Channel: Flutter steuert den ForegroundService,
        // Service ruft triggerSync zurück wenn SSE-Ping kommt.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SYNC_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startForegroundService" -> {
                        val deviceId = call.argument<String>("deviceId") ?: run {
                            result.error("MISSING_DEVICE_ID", "deviceId required", null)
                            return@setMethodCallHandler
                        }
                        // Für BootReceiver cachen (unverschlüsselt – nur nicht-sensitive ID)
                        getSharedPreferences("refugium_boot_prefs", MODE_PRIVATE)
                            .edit().putString("device_id", deviceId).apply()

                        val intent = Intent(applicationContext, RefugiumForegroundService::class.java).apply {
                            action = RefugiumForegroundService.ACTION_START
                            putExtra(RefugiumForegroundService.EXTRA_DEVICE_ID, deviceId)
                        }
                        startForegroundService(intent)
                        result.success(true)
                    }
                    "stopForegroundService" -> {
                        val intent = Intent(applicationContext, RefugiumForegroundService::class.java).apply {
                            action = RefugiumForegroundService.ACTION_STOP
                        }
                        startService(intent)
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