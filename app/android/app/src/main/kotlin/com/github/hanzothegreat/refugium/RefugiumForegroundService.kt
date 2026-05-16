package com.github.hanzothegreat.refugium

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.IBinder
import androidx.core.app.NotificationCompat
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.URL
import javax.net.ssl.HttpsURLConnection

class RefugiumForegroundService : Service() {

    companion object {
        const val NOTIFICATION_ID = 1001
        const val NOTIFICATION_NEW_DATA_ID = 1002
        const val CHANNEL_ID = "refugium_sync"
        const val ACTION_START = "ACTION_START"
        const val ACTION_STOP = "ACTION_STOP"
        const val EXTRA_DEVICE_ID = "device_id"
        const val SERVER_URL = "https://refugium-sync.duckdns.org"
        const val FLUTTER_ENGINE_ID = "main_engine"
        const val SYNC_CHANNEL = "com.github.hanzothegreat.refugium/sync"
    }

    private var sseThread: Thread? = null
    @Volatile private var running = false

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            stopSelf()
            return START_NOT_STICKY
        }

        val deviceId = intent?.getStringExtra(EXTRA_DEVICE_ID) ?: run {
            stopSelf()
            return START_NOT_STICKY
        }

        startForeground(NOTIFICATION_ID, buildPersistentNotification())

        if (!running) {
            running = true
            startSseLoop(deviceId)
        }

        return START_STICKY
    }

    override fun onDestroy() {
        running = false
        sseThread?.interrupt()
        super.onDestroy()
    }

    // SSE-Loop mit exponentiellem Backoff bei Verbindungsfehlern
    private fun startSseLoop(deviceId: String) {
        sseThread = Thread {
            var backoffMs = 5_000L
            while (running) {
                try {
                    connectSse(deviceId)
                    // Sauberer Disconnect → kurze Pause dann reconnect
                    if (running) Thread.sleep(2_000L)
                    backoffMs = 5_000L
                } catch (_: InterruptedException) {
                    break
                } catch (_: Exception) {
                    if (running) {
                        try { Thread.sleep(backoffMs) } catch (_: InterruptedException) { break }
                        backoffMs = (backoffMs * 2).coerceAtMost(300_000L)
                    }
                }
            }
        }.also { it.isDaemon = true; it.start() }
    }

    private fun connectSse(deviceId: String) {
        val url = URL("$SERVER_URL/api/v1/sse/$deviceId")
        val conn = url.openConnection() as HttpsURLConnection
        conn.connectTimeout = 30_000
        conn.readTimeout = 0  // Streaming – kein Read-Timeout
        conn.setRequestProperty("Accept", "text/event-stream")
        conn.setRequestProperty("Cache-Control", "no-cache")

        try {
            conn.connect()
            val reader = BufferedReader(InputStreamReader(conn.inputStream))
            var line: String?
            while (reader.readLine().also { line = it } != null && running) {
                // SSE-Zeile "data: new_message" → Sync triggern
                if (line!!.startsWith("data:") && line!!.contains("new_message")) {
                    onNewMessagePing()
                }
            }
        } finally {
            conn.disconnect()
        }
    }

    private fun onNewMessagePing() {
        val engine = FlutterEngineCache.getInstance().get(FLUTTER_ENGINE_ID)
        if (engine != null) {
            // App im Hintergrund – Engine lebt, Sync direkt in Dart ausführen
            val handler = android.os.Handler(mainLooper)
            handler.post {
                MethodChannel(engine.dartExecutor.binaryMessenger, SYNC_CHANNEL)
                    .invokeMethod("triggerSync", null)
            }
        } else {
            // App vollständig geschlossen – Notification, Nachrichten warten auf Server
            showNewDataNotification()
        }
    }

    private fun showNewDataNotification() {
        val tapIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val pendingIntent = PendingIntent.getActivity(
            this, 0, tapIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle("Refugium")
            .setContentText("Neue Daten verfügbar")
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .build()

        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.notify(NOTIFICATION_NEW_DATA_ID, notification)
    }

    private fun buildPersistentNotification(): Notification {
        val stopIntent = Intent(this, RefugiumForegroundService::class.java).apply {
            action = ACTION_STOP
        }
        val stopPending = PendingIntent.getService(
            this, 0, stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle("Refugium")
            .setContentText("Synchronisation aktiv")
            .setOngoing(true)
            .setSilent(true)
            .setPriority(NotificationCompat.PRIORITY_MIN)
            .addAction(
                android.R.drawable.ic_menu_close_clear_cancel,
                "Beenden",
                stopPending
            )
            .build()
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Refugium Sync",
            NotificationManager.IMPORTANCE_MIN
        ).apply {
            description = "Hält die Synchronisation aktiv"
            setShowBadge(false)
        }
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.createNotificationChannel(channel)
    }
}