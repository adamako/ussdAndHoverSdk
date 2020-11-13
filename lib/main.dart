import 'package:flutter/material.dart';
import 'package:ussd_sample/check_money.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Ussd '),
          ),
          body: CheckMoney()),
    );
  }
}
