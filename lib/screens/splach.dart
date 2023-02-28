import 'dart:async';
import 'package:flutter/material.dart';
import 'package:olx/screens/bottom_bar.dart';
import 'package:olx/screens/login.dart';

import '../config/auth.dart';
import 'home_screen.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 2),
      () {
        checkLogin();
      },
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  checkLogin() async {
    bool isLoggedIn = await Auth().isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => BottomBar()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.blue,
        child: Center(
            child: Image(
          image: AssetImage("assets/logo.png"),
          height: 250,
          width: 250,
        )),
      ),
    );
  }
}
