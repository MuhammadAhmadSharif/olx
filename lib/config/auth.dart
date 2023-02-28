// import 'dart:html';

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class Auth {
  var dio = new Dio();
  var client = http.Client();

  // login the driver
  Future<dynamic> login(data) async {
    var url = Configuration.url + 'user/login';
    var resp = await dio.post(url, data: data);
    return resp.data;
  }

  //login api

  Future<bool> setLogin(user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // log(user.toString());
    String u = jsonEncode(user);
    //In Flutter, json.encode is a method used to convert a Dart object to a JSON string,
    await prefs.setString("fcm", user['fcm'][0]);
    await prefs.setString('_id', user["_id"]);
    await prefs.setBool('loggedIn', true);
    await prefs.setString('user', u);
    log("Set user hoo gaya");
    return true;
  }

  Future<bool> setUser(user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String u = jsonEncode(user);
    await prefs.setString('user', u);
    await prefs.setBool('loggedIn', true);
    log("Set user hoo gaya");
    log(prefs.getBool("loggedIn").toString());
    return true;
  }

  //  get user from local storage
  // Future getUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var f = prefs.getString('fcm');
  //   var s = prefs.getString("_id");
  //   dynamic data = {f, s};
  //   // print({data, "jjjjjjjjjjjjjjjjjjjjjjjjjjjjj"});
  //   if (s == null && f == null) {
  //     return null;
  //   } else {
  //     var user = json.decode(data);
  //     // print(user);
  //     return user;
  //   }
  // }

  isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('loggedIn') == null || prefs.getBool('loggedIn') == false)
      return false;
    else
      return true;
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    await prefs.clear();
    return true;
  }

  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var u = prefs.getString('user');
    if (u == null) {
      return null;
    } else {
      var user = json.decode(u);
      return user;
    }
  }

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("switchState", value);
    print('Switch Value saved $value');
    return prefs.setBool("switchState", value);
  }

  Future<bool?> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSwitched = prefs.getBool("switchState");
    print(isSwitched);
    return isSwitched;
  }
}
