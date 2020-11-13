import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckMoney extends StatefulWidget {
  @override
  _CheckMoneyState createState() => _CheckMoneyState();
}

class _CheckMoneyState extends State<CheckMoney> {
  static const _hover = const MethodChannel("kikoba.co.tz/hover");

  TextEditingController codeController = TextEditingController();

  String _response = 'Waiting for response...';
  String message = "";

  Future<dynamic> checkMoney() async {
    String response = " ";
    try {
      final String result = await _hover.invokeMethod('checkMoney');
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: ${e.message}";
    }
    setState(() {
      _response = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                checkMoney();
              },
              child: Text("Check balance"),
            ),
            Text("$_response")
          ],
        ),
      ),
    );
  }
}
