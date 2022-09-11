import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Image.asset('assets/images/splash.png')),
        //Here you can set what ever background color you need.
        backgroundColor: Colors.white,
      ),
    );
  }
}
