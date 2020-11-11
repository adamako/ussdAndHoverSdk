import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckMoney extends StatefulWidget {
  @override
  _CheckMoneyState createState() => _CheckMoneyState();
}

class _CheckMoneyState extends State<CheckMoney> {
  static const _hover = const MethodChannel("kikoba.co.tz/hover");
  final _formKey = GlobalKey<FormState>();

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

  Future<dynamic> getMessage() async {
    String reponse = " ";
    try {
      final String message = await _hover.invokeMethod('getMessage');
      reponse = message;
    } on PlatformException catch (e) {
      reponse = e.message;
    }
    setState(() {
      message = reponse;
    });
  }

  Widget _buildNumberTextField() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: TextFormField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
          ],
          controller: codeController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter phone number';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Phone Number',
            suffixIcon: Icon(Icons.dialpad),
          ),
          keyboardType: TextInputType.numberWithOptions(),
        ));
  }

  Widget _buildTuma() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                checkMoney();
              },
              child: Text("Consulter solde"),
            ),
            Text(_response),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hover'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildTuma()],
        ),
      ),
    );
  }
}
