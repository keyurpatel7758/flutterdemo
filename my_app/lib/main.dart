import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Flutter First App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome First App'),
        ),
        body: Center(
          child: Text('My First Flutter App'),
        ),
      ),
    );
  }

}