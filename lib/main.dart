import 'package:flutter/material.dart';
import 'package:mobitix/pages/LandingPage.dart';
import 'pages/HomePage.dart';

void main() {
  runApp(MobitixApp());
}

class MobitixApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobitix',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
