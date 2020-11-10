import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendMoney extends StatefulWidget {
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  static const _hover = const MethodChannel("kikoba.co.tz/hover");
  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  String _response = 'Waiting for response...';

  Future<dynamic> sendMoney(String phoneNumber, amount) async {
    var sendMap = <String, dynamic>{
      'phoneNumber': phoneNumber,
      'amount': amount
    };
    String response = " ";
    try {
      final String result = await _hover.invokeMethod('sendMoney', sendMap);
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: ${e.message}";
    }
    setState(() {
      _response = response;
    });
  }

  Widget _buildNumberTextField() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: TextFormField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
          ],
          controller: phoneController,
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

  Widget _buildAmountTextField() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: TextFormField(
          controller: amountController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter amount';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Amount',
          ),
          keyboardType: TextInputType.numberWithOptions(),
        ));
  }

  Widget _buildTuma() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildNumberTextField(),
            _buildAmountTextField(),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  sendMoney(phoneController.text, amountController.text);
                }
              },
              child: Text("send Money"),
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
