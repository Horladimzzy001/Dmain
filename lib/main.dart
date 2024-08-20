import 'package:flutter/material.dart';
import 'package:phidrillsim_app/calculationTable.dart';

import 'homePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PhiDrillSim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image.asset(
  'assets/drill_logo.jpg',  // Replace with the path to your image
  fit: BoxFit.contain,         // This will make the image cover the entire screen
  height: MediaQuery.of(context).size.height,  // Match the height of the screen
  width: MediaQuery.of(context).size.width,    // Match the width of the screen
),

    );
  }
}

