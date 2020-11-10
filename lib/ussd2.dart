import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ussd/ussd.dart';

class USSD2 extends StatefulWidget {
  @override
  _USSD2State createState() => _USSD2State();
}

class _USSD2State extends State<USSD2> {
  var _requestCode;
  @override
  void initState() {
    super.initState();
  }

  Future<void> launchUssd(String ussdCode) async {
    Ussd.runUssd(ussdCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('USSD 2'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Entrer le Code ussd',
            ),
            onChanged: (newValue) {
              setState(() {
                _requestCode = newValue;
              });
            },
          ),
          SizedBox(
            height: 15,
          ),
          RaisedButton(
            onPressed: () {
              launchUssd(_requestCode);
            },
            child: Text(
              "Envoyé",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue[400],
          ),
        ],
      )),
    );
  }
}
