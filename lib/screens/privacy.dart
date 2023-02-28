import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:olx/screens/change_password.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool isSwitched = true;
  Future<void> toggleSwitch(bool value) async {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
    } else {
      setState(() {
        isSwitched = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: Text(
          "Privacy",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 32,
              top: 10,
            ),
            child: Row(
              children: [
                Text(
                  "Show my phone number in ads",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Spacer(),
                FlutterSwitch(
                  width: 55,
                  toggleSize: 25,
                  padding: 0,
                  height: 28,
                  // splashRadius: 5,
                  value: isSwitched,
                  onToggle: toggleSwitch,
                  activeColor: Colors.indigo.shade900,
                  activeIcon: Icon(Icons.done),
                  activeToggleColor: Colors.white,
                  inactiveColor: Colors.black54,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: Colors.grey.shade200,
            height: 20,
            thickness: 2,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 32, top: 10, bottom: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen(),
                    ));
              },
              child: Row(
                children: [
                  Text(
                    "Change password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: Colors.grey.shade200,
            height: 20,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
