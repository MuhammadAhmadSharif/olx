import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/config/service.dart';
import 'package:olx/screens/delete_account.dart';
import 'package:olx/screens/login.dart';

import '../config/auth.dart';

class ManageAccountScreen extends StatefulWidget {
  const ManageAccountScreen({super.key});

  @override
  State<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

var user;
String id = "";
Future<void> getUser() async {
  user = await Auth().getUser();
  id = user["_id"];
  log(user.toString());
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  void logout() async {
    dynamic body = {
      "_id": user["_id"],
      "fcm": user['fcm'][0],
      "status": user["status"]
    };

    var response = await ApiService().logout(body);
    log(response.toString());
    if (response['status'] == 1) {
      await Auth().logout();
      print("mian run ho raha hooo");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
          (Route<dynamic> route) => false);
    } else {
      Fluttertoast.showToast(
          msg: "Logout failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
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
          "Manage Account",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                logout();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigoAccent),
                    borderRadius: BorderRadius.circular(4)),
                child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.indigoAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey.shade200,
              height: 20,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeleteAccountScreen(),
                      ));
                },
                child: Row(
                  children: [
                    Text(
                      "Delete account",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
          ],
        ),
      ),
    );
  }
}
