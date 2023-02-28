import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/config/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/auth.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isSwitched = true;
  bool isSwitched2 = true;
  dynamic data;
  dynamic fcm;
  var user;
  var _id;

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data = await prefs.getString("user");
    fcm = await prefs.getString("fcm");
    user = jsonDecode(data);
    _id = user["_id"];
    log(fcm.toString());
    log(_id.toString());
  }

  Future<void> toggleSwitch(bool value) async {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        trunOnNotification();
      });
    } else {
      setState(() {
        isSwitched = false;
        turnOffNotification();
      });
    }
  }

  Future<void> toggleSwitch2(bool value) async {
    if (isSwitched2 == false) {
      setState(() {
        isSwitched2 = true;
        trunOnNotification();
      });
    } else {
      setState(() {
        isSwitched2 = false;
        turnOffNotification();
      });
    }
  }

  turnOffNotification() async {
    dynamic body = {
      "_id": _id,
      "fcm": fcm,
    };
    log(body.toString());
    var response = await ApiService().logout(body);
    if (response["status"] == 1) {
      Fluttertoast.showToast(
          msg: "Notifications are turned Off",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  trunOnNotification() async {
    var body = {
      "_id": _id,
      "fcm": fcm,
    };

    var response = await ApiService().turnOnNotification(body);
    if (response["status"] == 1) {
      Fluttertoast.showToast(
          msg: "Notifications are turned On",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
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
          "Notifications",
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
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recommendations",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Receive recommendations base on your activity",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
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
            padding: const EdgeInsets.only(
              left: 16,
              right: 32,
              top: 10,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Special Communications & offers",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Receive Updates, offers, surveys and more",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
                Spacer(),
                FlutterSwitch(
                  width: 55,
                  toggleSize: 25,
                  padding: 0,
                  height: 28,
                  // splashRadius: 5,
                  value: isSwitched2,
                  onToggle: toggleSwitch2,
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
        ],
      ),
    );
  }
}
