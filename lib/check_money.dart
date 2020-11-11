import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckMoney extends StatefulWidget {
  @override
  _CheckMoneyState createState() => _CheckMoneyState();
}

class _CheckMoneyState extends State<CheckMoney> {
  static const _hover = const MethodChannel("kikoba.co.tz/hover");

  String _response = 'Waiting for response...';

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
      appBar: AppBar(
        title: Text('Hover'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                checkMoney();
              },
              child: Text("send Money"),
            ),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
