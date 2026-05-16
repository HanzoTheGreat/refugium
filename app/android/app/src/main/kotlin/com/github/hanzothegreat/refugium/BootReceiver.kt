package com.github.hanzothegreat.refugium

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val validActions = setOf(
            Intent.ACTION_BOOT_COMPLETED,
            "android.intent.action.QUICKBOOT_POWERON",  // HTC/OnePlus
            "com.htc.intent.action.QUICKBOOT_POWERON",
        )
        if (intent.action !in validActions) return

        // Device ID aus normalem SharedPreferences-Cache lesen.
        // FlutterSecureStorage (EncryptedSharedPreferences) ist zu Boot-Zeit
        // noch nicht entschlüsselbar – daher separater unverschlüsselter Cache.
        // Der Cache wird von MainActivity beim App-Start befüllt.
        val prefs = context.getSharedPreferences("refugium_boot_prefs", Context.MODE_PRIVATE)
        val deviceId = prefs.getString("device_id", null) ?: return

        val serviceIntent = Intent(context, RefugiumForegroundService::class.java).apply {
            action = RefugiumForegroundService.ACTION_START
            putExtra(RefugiumForegroundService.EXTRA_DEVICE_ID, deviceId)
        }
        context.startForegroundService(serviceIntent)
    }
}