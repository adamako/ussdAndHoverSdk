package com.example.ussd_sample

import android.app.Activity
import android.content.Intent
import android.util.Log
import android.widget.Toast
import com.hover.sdk.api.Hover
import com.hover.sdk.api.HoverParameters
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL: String= "kikoba.co.tz/hover"

    private var message: String=""

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
////          val arguments: Map<String, Any> = call.arguments()
//            val phoneNumber: String= arguments["phoneNumber"] as String
//            val amount: String= arguments["amount"] as String
//
//            val code: String= call.arguments.toString()
//            print(code)
//            if(call.method == "checkMoney"){
//                checkMoney()
//                val response: String= "Envoyé"
//                result.success(response)
//            }
            when(call.method){
                "checkMoney" -> {
                    checkMoney()
                    val response: String= "Envoyé"

                    result.success(response)
                }
                "getMessage"->{
                    getMessage()
                    result.success(getMessage())
                }
            }
        }
    }

    private fun getMessage(): String {
        return message
    }


    private fun SendMoney(phoneNumber: String, amount: String){
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


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        if (requestCode == 0 && resultCode == Activity.RESULT_OK) {
            val sessionTextArr = data.getStringArrayExtra("session_messages")
            val uuid = data.getStringExtra("uuid")
            for (me in sessionTextArr.indices){
                message+=me
            }

        } else if (requestCode == 0 && resultCode == Activity.RESULT_CANCELED) {
            Log.d("MainActivity", "Error: " + data.getStringExtra("error"))
        }
    }
}
