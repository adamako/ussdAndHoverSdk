import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';
import 'package:ussd_sample/ussd2.dart';
import 'package:ussd_service/ussd_service.dart';

import 'check_money.dart';

enum RequestState {
  Ongoing,
  Success,
  Error,
}

class USSD extends StatefulWidget {
  @override
  _USSDState createState() => _USSDState();
}

class _USSDState extends State<USSD> {
  RequestState _requestState;
  String _requestCode = "";
  String _responseCode = "";
  String _responseMessage = "";

  Future<void> sendUssdRequest() async {
    setState(() {
      _requestState = RequestState.Ongoing;
    });
    try {
      String responseMessage;
      await Permission.phone.request();
      if (!await Permission.phone.isGranted) {
        throw Exception("permission missing");
      }

      SimData simData = await SimDataPlugin.getSimData();
      if (simData == null) {
        throw Exception("sim data is null");
      }
      responseMessage = await UssdService.makeRequest(
          simData.cards.first.subscriptionId, _requestCode);

      setState(() {
        _requestState = RequestState.Success;
        _responseMessage = responseMessage;
      });
    } catch (e) {
      setState(() {
        _requestState = RequestState.Error;
        _responseCode = e is PlatformException ? e.code : "";
        _responseMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            const SizedBox(height: 20),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: _requestState == RequestState.Ongoing
                  ? null
                  : () {
                      sendUssdRequest();
                    },
              child: const Text('Envoyer'),
            ),
            const SizedBox(height: 20),
            if (_requestState == RequestState.Ongoing)
              Row(
                children: const <Widget>[
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(width: 24),
                  Text('Requete en cours...'),
                ],
              ),
            if (_requestState == RequestState.Success) ...[
              const Text('Requete traitée avec succès !'),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black26,
                ),
                child: Text(
                  _responseMessage,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
            if (_requestState == RequestState.Error) ...[
              const Text('La requete n\'a pas aboutie'),
              const SizedBox(height: 10),
              const Text('Error code was:'),
              Text(
                _responseCode,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('Message d\'erreur:'),
              Text(
                _responseMessage,
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
            Spacer(),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => USSD2()));
              },
              child: Text(
                'USSD 2',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
            ),
            SizedBox(
              height: 40,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CheckMoney()));
              },
              child: Text('Hover'),
            )
          ]),
    );
  }
}
