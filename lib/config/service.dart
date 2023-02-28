import 'dart:developer';

import 'package:dio/dio.dart';
import 'config.dart';

class ApiService {
  var dio = new Dio();

  //SignUpUser
  Future<dynamic> signup(data) async {
    var url = Configuration.url + '/user/create';
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    // log(b.toString());
    return b;
  }

  //createAds
  Future<dynamic> adscreate(data) async {
    var url = Configuration.url + '/ads/create';
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    // log(b.toString());
    return b;
  }

//checkUser
  Future<dynamic> checkUser(data) async {
    log("i am running");
    log(data.toString());
    var url = Configuration.url + '/user/check';
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    log(b.toString());
    return b;
  }

//logoutUser
  Future<dynamic> logout(body) async {
    // log(body.toString());
    var url = Configuration.url + '/user/logout_fcm';
    var resp = await dio.post(url, data: body);
    var b = resp.data;
    // log(b.toString());
    return b;
  }

  //Get All Categories
  Future<dynamic> allCategories() async {
    var url = Configuration.url + '/category/allCategories';
    var resp = await dio.get(url);
    var b = resp.data;
    // log(b.toString());
    return b;
  }

  //Get All Categories
  Future<dynamic> allads() async {
    var url = Configuration.url + '/ads/allads';
    var resp = await dio.get(url);
    var b = resp.data;
    // log(b.toString());
    return b;
  }

  //Get All SubCategories
  Future<dynamic> allSubCategories(body) async {
    var url = Configuration.url + '/subcategory/allSubCategories';
    var resp = await dio.post(url, data: body);
    var b = resp.data;
    // log(b.toString());
    return b;
  }

  //add New factory
  Future<dynamic> addFactory(body) async {
    var url = Configuration.url + '/factory/create';
    var resp = await dio.post(url, data: body);
    var b = resp.data;
    return b;
  }

  //Get all factory list
  Future<dynamic> allFactory() async {
    var url = Configuration.url + '/factory/allFactories';
    var resp = await dio.get(url);
    var b = resp.data;
    return b;
  }

  //Get All Factories on the filter of Category and country
  Future<dynamic> allfactoriesFCC(data) async {
    var url = Configuration.url + '/factory/getAllFactories';
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    return b;
  }

  //Get All Product (Factories)
  Future<dynamic> allProductF(data) async {
    var url = Configuration.url + '/product/getAllProduct';
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    return b;
  }

  //Update User Name
  Future<dynamic> updateUser(data) async {
    var url = Configuration.url + '/user/updateUser';
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    return b;
  }

  //change user Password
  Future<dynamic> changeUserPass(data) async {
    var url = Configuration.url + '/user/changePassword';
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    return b;
  }

  Future<dynamic> notification(data) async {
    var url = Configuration.url + '/Announcement/statusUpdate';
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    return b;
  }

  Future<dynamic> fileUpload(data) async {
    var url = Configuration.url + '/uploads/imgupload';
    var resp = await dio.post(url, data: data);
    var b = resp.data; //var b = jsonDecode(jsonEncode(resp.data));
    // var b = resp.data;
    return b;
  }

//find ads on category
  Future<dynamic> findads(data) async {
    var url = Configuration.url + '/ads/findAds';
    var resp = await dio.post(url, data: data);
    var b = resp.data; //var b = jsonDecode(jsonEncode(resp.data));
    // var b = resp.data;
    return b;
  }

  //find ads of logined user
  Future<dynamic> findUserads(data) async {
    var url = Configuration.url + '/ads/findUserAds';
    var resp = await dio.post(url, data: data);
    var b = resp.data; //var b = jsonDecode(jsonEncode(resp.data));
    // var b = resp.data;
    return b;
  }

  //Edit ads of logined user
  Future<dynamic> editUserads(data) async {
    var url = Configuration.url + '/ads/editAds';
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    //var b = jsonDecode(jsonEncode(resp.data));
    // var b = resp.data;
    return b;
  }

  //Edit ads of logined user
  Future<dynamic> deactivateUserads(data) async {
    var url = Configuration.url + '/ads/deactivateAds';
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    return b;
  }

  //Favourite ads of logined user
  Future<dynamic> favouriteAds(data) async {
    var url = Configuration.url + '/ads/favAds';
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    return b;
  }

  //Filter api data
  Future<dynamic> filterads(data) async {
    var url = Configuration.url + '/ads/filterAds';
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    return b;
  }

  // turn on notification
  Future<dynamic> turnOnNotification(data) async {
    var url = Configuration.url + '/user/fcmNew';
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    return b;
  }

//send notification
  Future<dynamic> sendnotification(data) async {
    var url = Configuration.url + '/notifications/create';
    var resp = await dio.post(url);
    var b = resp.data;
    return b;
  }

  //Update Notification Data
  Future<dynamic> updatenotification(data) async {
    var url = Configuration.url + '/notifications/update';
    var resp = await dio.post(url);
    var b = resp.data;
    return b;
  }

  //get all notification of user
  Future<dynamic> getallnotify(id) async {
    var url = Configuration.url + '/notifications/getAllNotify/$id';
    var resp = await dio.get(url);
    var b = resp.data;
    return b;
  }

  //ask question create
  Future<dynamic> MessageCreate(body) async {
    var url = Configuration.url + '/conversation/create';
    var resp = await dio.post(url, data: body);
    var b = resp.data;
    return b;
  }

  //Product Detail chat button api
  Future<dynamic> chatButton(body) async {
    var url = Configuration.url + '/conversation/createChat';
    var resp = await dio.post(url, data: body);
    var b = resp.data;
    return b;
  }

  // find conversation
  Future<dynamic> findConversation(data) async {
    var url = Configuration.url + '/conversation/find';
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    return b;
  }

  //final  all conversation
  Future<dynamic> findallConv(data) async {
    log(data.toString());
    var url = Configuration.url + '/conversation/findall';
    // log(url.toString());
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    // log(b.toString());
    return b;
  }

  //find buy conversation
  Future<dynamic> findallbuy(data) async {
    log(data.toString());
    var url = Configuration.url + '/conversation/findBuy';
    // log(url.toString());
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    // log(b.toString());
    return b;
  }

  //find Selling conversation
  Future<dynamic> findallSelling(data) async {
    log(data.toString());
    var url = Configuration.url + '/conversation/findSelling';
    // log(url.toString());
    var resp = await dio.post(url, data: data);
    var b = resp.data;
    // log(b.toString());
    return b;
  }

  //delete conversation message
  Future<dynamic> deleteMessages(id) async {
    var url = Configuration.url + '/conversation/delete/$id';
    log(url.toString());
    var resp = await dio.get(url);
    var b = resp.data;
    return b;
  }

  //update last message and quentity of messages
  Future<dynamic> updateMessages(body) async {
    var url = Configuration.url + '/conversation/update';
    log(body.toString());
    var resp = await dio.post(url, data: body);
    var b = resp.data;
    return b;
  }

  //find Favorite ads of the user
  Future<dynamic> userfavAds(body) async {
    var url = Configuration.url + '/ads/findFavAds';
    log(body.toString());
    var resp = await dio.post(url, data: body);
    var b = resp.data;
    // log(b.toString());
    return b;
  }

  //fav ads api
  Future<dynamic> favAds(body) async {
    var url = Configuration.url + '/ads/favAds';
    log(body.toString());
    var resp = await dio.post(url, data: body);
    var b = resp.data;
    return b;
  }

  //unFav ads api
  Future<dynamic> unfavAds(body) async {
    var url = Configuration.url + '/ads/unfavAds';
    log(body.toString());
    var resp = await dio.post(url, data: body);
    var b = resp.data;
    return b;
  }
}
