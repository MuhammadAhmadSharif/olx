import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:olx/config/service.dart';
import 'package:olx/screens/productDetail.dart';
import '../config/auth.dart';
import '../config/config.dart';
import '../widgets/product.dart';

class MyList {
  static List favads = [];
}

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

bool _loading = false;

var user;
var body;

class _FavouritesScreenState extends State<FavouritesScreen> {
  Unfavads(adId, index) async {
    body = {
      "_id": adId,
      "fav": user["_id"],
    };
    var response = await ApiService().unfavAds(body);
    if (response["status"] == 1) {
      setState(() {
        MyList.favads.removeAt(index);
      });
    }

    log(response["status"].toString());
  }

  findFavAds() async {
    setState(() {
      _loading = true;
    });
    dynamic body = {"userId": user["_id"]};
    var response = await ApiService().userfavAds(body);
    MyList.favads = response["data"];
    setState(() {
      _loading = false;
    });
    log(MyList.favads[0].toString());
  }

  Future<void> getUser() async {
    user = await Auth().getUser();
    findFavAds();
    // log(user.toString());
    setState(() {});
  }

  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              children: [
                  MyList.favads.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 4.5,
                              ),
                              Container(
                                  child: Text("You haven't liked anything yet.",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                        )
                      : GridView.builder(
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          itemCount: MyList.favads.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.7,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 8),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 1000),
                                      reverseTransitionDuration:
                                          const Duration(milliseconds: 1000),
                                      pageBuilder: (context, a, b) =>
                                          ProductDetail(
                                        detial: MyList.favads[index],
                                        productDetail: 0,
                                        // indexfortag: index,
                                        // p_index: index.toString(),
                                      ),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      // border: Border.all(),
                                      borderRadius: BorderRadius.circular(8)),
                                  height: 130,
                                  width: MediaQuery.of(context).size.width / 5,
                                  child: Column(
                                    children: [
                                      Hero(
                                        tag: Configuration.url +
                                            "/uploads/" +
                                            MyList.favads[index]["image"][0],
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8)),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  Configuration.url +
                                                      "/uploads/" +
                                                      MyList.favads[index]
                                                          ["image"][0]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          height: 145,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                MyList.favads[index]["title"],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                          _loading
                                              ? CircularProgressIndicator()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8, left: 4),
                                                  child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          Unfavads(
                                                              MyList.favads[
                                                                  index]["_id"],
                                                              index);
                                                        });
                                                      },
                                                      child: favicon))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                "Rs " +
                                                    MyList.favads[index]
                                                            ["price"]
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        child: Row(
                                          children: [
                                            Container(
                                              // decoration: BoxDecoration(
                                              //     border: Border.all()),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.4,
                                              child: Text(
                                                "Address of Faisalabad",
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 12),
                                                maxLines: 1,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              Jiffy(MyList.favads[index]
                                                      ["datePublish"])
                                                  .format('MMM do'),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                ]),
    );
    // return
  }
}
