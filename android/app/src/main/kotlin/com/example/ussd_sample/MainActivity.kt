package com.example.ussd_sample

import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import com.hover.sdk.api.Hover
import com.hover.sdk.api.HoverParameters
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception

class MainActivity: FlutterActivity() {
    private val CHANNEL: String= "kikoba.co.tz/hover"

    private fun SendMoney(phoneNumber:String,amount:String){
        Hover.initialize(this)
        try {
            Log.d("MainActivity","Sims are= "+ Hover.getPresentSims(this))
            Log.d("MainActivity","Hover actions are=  "+ Hover.getAllValidActions(this))
        }catch (e:Exception){
            Log.d("MainActivity", "hiver exception",e)

        }
        val i:Intent = HoverParameters.Builder(this)
                .request("c98397c9")
                .buildIntent()

        startActivityForResult(i,0)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler { call, result ->
            val arguments: Map<String, Any> = call.arguments()
            val phoneNumber: String= arguments["phoneNumber"] as String
            val amount: String= arguments["amount"] as String

            if(call.method.equals("sendMoney")){
                SendMoney(phoneNumber,amount)
                val response: String= "sent"

                result.success(response)
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        Hover.initialize(this)
    }



}
