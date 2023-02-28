import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:olx/config/auth.dart';
import 'package:olx/config/service.dart';
import 'package:jiffy/jiffy.dart';
import 'package:olx/screens/productDetail.dart';
import 'package:olx/screens/sell_screens/edit_ads.dart';

import '../config/config.dart';

class NoAdsScreen extends StatefulWidget {
  const NoAdsScreen({super.key});

  @override
  State<NoAdsScreen> createState() => _NoAdsScreenState();
}

var user;
void changeDateFormate() {}
var data;

var response;
bool _loading = true;

class _NoAdsScreenState extends State<NoAdsScreen> {
  Future<void> getUser() async {
    user = await Auth().getUser();
    userAdsAPi();
    // log(user.toString());
  }

  Future<void> userAdsAPi() async {
    data = {"userId": user["_id"]};
    log(data.toString());
    response = await ApiService().findUserads(data);

    setState(() {
      userAds = response["data"];
      _loading = false;
    });

    // log(userAds.toString());
  }

  List userAds = [];

  Future<void> deactivateAds(id) async {
    data = {
      "_id": "$id",
      "status": 0,
    };
    var response = await ApiService().deactivateUserads(data);
    // log(response.toString());
    setState(() {});
  }

  @override
  void initState() {
    getUser();
    // userAdsAPi();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text(
                "Active Ads [${userAds.length}]",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.keyboard_arrow_down)
            ],
          ),
        ),
        Divider(
          color: Colors.grey.shade200,
          height: 20,
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
                color: Colors.purple[800],
                borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Heavy discount on packages",
                      // maxLines: 1,
                      style: TextStyle(
                          // overflow: TextOverflow.ellipsis,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width / 3.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Center(
                      child: FittedBox(
                        child: Text("View packages",
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
          // height: MediaQuery.of(context).size.height / 3.5,
        ),
        _loading
            ? Center(child: CircularProgressIndicator())
            : FutureBuilder(
                future: ApiService().findUserads(data),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else if (userAds.isEmpty) {
                    return Center(
                      child: Text(
                        "You don't have any ads yet.",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  } else {
                    return Container(
                      // decoration: BoxDecoration(border: Border.all()),
                      height: MediaQuery.of(context).size.height - 385,
                      child: ListView.builder(
                          itemCount: userAds.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetail(
                                          detial: userAds[index],
                                          productDetail: 0,
                                          // indexfortag: index,
                                        ),
                                      ));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 210,
                                  // decoration: BoxDecoration(border: Border.all()),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black12),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "FROM: ",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                                Jiffy(userAds[index]
                                                        ["datePublish"])
                                                    .format('MMM do yy'),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              "  -TO:  ",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                                Jiffy(userAds[index]
                                                        ["datePublish"])
                                                    .add(
                                                        duration:
                                                            Duration(days: 30))
                                                    .format('MMM do yy'),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Spacer(),
                                            PopupMenuButton(
                                              icon: Icon(
                                                Icons.more_vert_rounded,
                                                color: Colors.black,
                                              ),
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                    onTap: () {},
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EditAdScreen(
                                                                      adsDetail:
                                                                          userAds[
                                                                              index]),
                                                            ));
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Edit",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                PopupMenuItem(
                                                    onTap: () {
                                                      setState(() {
                                                        deactivateAds(
                                                            userAds[index]
                                                                ["_id"]);
                                                      });
                                                    },
                                                    child: Text(
                                                      "Deactivate",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                                PopupMenuItem(
                                                    onTap: () {},
                                                    child: Text(
                                                      "Mark as Sold",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                                PopupMenuItem(
                                                    onTap: () {},
                                                    child: Text(
                                                      "Cencel",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                                // border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        Configuration.url +
                                                            "/uploads/" +
                                                            userAds[index]
                                                                ["image"][0]),
                                                    fit: BoxFit.fill)),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                userAds[index]["title"],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "RS." +
                                                      userAds[index]["price"]
                                                          .toString(),
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Category: ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                      userAds[index]
                                                              ["subcategoryId"]
                                                          ["name"],
                                                      style: TextStyle(
                                                          fontSize: 16))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: Divider(
                                          color: Colors.grey.shade200,
                                          height: 20,
                                          thickness: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // child:
                                ),
                              ),
                            );
                          }),
                    );
                  }
                })
      ],
    );
  }
}
