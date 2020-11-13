package com.example.ussd_sample

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import com.hover.sdk.api.Hover
import com.hover.sdk.api.HoverParameters
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class MainActivity: FlutterActivity() {
    private val CHANNEL: String= "kikoba.co.tz/hover"

    private var message: String=""

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->

            when(call.method){
                "checkMoney" -> {
                    val response: String ="Sent"
                    checkMoney()
                    result.success(response)
                }
            }
        }
    }

    private fun checkMoney(){
        Hover.initialize(this)
        try {
            Log.d("MainActivity", "Sims are= " + Hover.getPresentSims(this))
            Log.d("MainActivity", "Hover actions are=  " + Hover.getAllValidActions(this))
        }catch (e: Exception){
            Log.d("MainActivity", "hiver exception", e)

        }
        val i:Intent =HoverParameters.Builder(this)
                .request("288a7dbd")
                .buildIntent()

        startActivityForResult(i, 0)

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?){
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 0 && resultCode == Activity.RESULT_OK) {
            val sessionTextArr = data?.getStringArrayExtra("session_messages")
            if (sessionTextArr != null) {
                for (me in sessionTextArr.indices){
                    message+=me
                }
            }

        } else if (requestCode == 0 && resultCode == Activity.RESULT_CANCELED) {
            if (data != null) {
                Log.d("MainActivity", "Error: " + data.getStringExtra("error"))
            }
        }
    }
}
