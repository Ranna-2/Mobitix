import 'package:flutter/material.dart';
import 'package:mobitix/admin_dashboard/admin_dashboard.dart';
import 'package:mobitix/pages/LandingPage.dart';
import 'package:mobitix/pages/HomePage.dart';

void main() {
  runApp(const MobitixApp());
}

class MobitixApp extends StatelessWidget {
  const MobitixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobitix',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}