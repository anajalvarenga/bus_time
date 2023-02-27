import 'package:flutter/material.dart';

import 'widgets/map_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bus Time'),
          backgroundColor: Colors.blue,
        ),
        body: const MapScreen(),
      ),
    );
  }
}