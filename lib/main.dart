import 'package:flutter/material.dart';
import './page/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Near Me',
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        accentColor: Colors.orange
      ),
      home: HomePage(),
    );
  }
}
