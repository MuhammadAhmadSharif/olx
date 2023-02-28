// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'package:olx/screens/productDetail.dart';
import 'package:olx/widgets/product.dart';

import '../../config/config.dart';
import '../../config/service.dart';

class SellerProfileScreen extends StatefulWidget {
  var userinfo;
  SellerProfileScreen({
    Key? key,
    required this.userinfo,
  }) : super(key: key);

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

var data;
List userAds = [];

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  Future<void> userAdsAPi() async {
    data = {"userId": widget.userinfo["_id"]};
    var response = await ApiService().findUserads(data);
    userAds = response["data"];
    setState(() {
      log(userAds.toString());
    });
  }

  @override
  void initState() {
    userAdsAPi();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(230),
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                color: Colors.black,
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
              ),
              backgroundColor: Colors.grey.shade100,
              elevation: 0,
              actions: [
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.black,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(child: Text("Share Profile")),
                    PopupMenuItem(child: Text("Report User")),
                    PopupMenuItem(child: Text("Block user")),
                  ],
                )
                // IconButton(
                //     onPressed: () {
                //       // setState(() {});
                //       Container(
                //         child: ListView(
                //           children: [
                //             Text("Share profile"),
                //             Text("Report user"),
                //             Text("Block user"),
                //           ],
                //         ),
                //       );
                //     },
                //     icon: Icon(
                //       Icons.more_vert_rounded,
                //       color: Colors.black,
                //     ))
              ],
            ),
            Container(
              padding: EdgeInsets.only(bottom: 0),
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/logo.png"),
                                  fit: BoxFit.contain),
                              shape: BoxShape.circle,
                              border: Border.all()),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userinfo["name"],
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              // decoration: BoxDecoration(border: Border.all()),
                              width: MediaQuery.of(context).size.width - 200,
                              child: Text(
                                "Member since " +
                                    Jiffy(widget.userinfo["joinDate"])
                                        .format('MMM do yyyy'),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                    height: 20,
                    thickness: 2,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: Row(
                      children: [
                        Text(
                          "Published ads [${userAds.length}]",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: ListView(
          children: [
            GridView.builder(
                physics: const ScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                itemCount: userAds.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.7,
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  return InkWell(
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
                      child: ProductContianer(
                        image: Configuration.url +
                            "/uploads/" +
                            userAds[index]["image"][0],
                        name: userAds[index]["title"],
                        price: "RS." + "${userAds[index]["price"]}",
                        date: Jiffy(userAds[index]["datePublish"])
                            .format('MMM do'),
                        fav: userAds[index]["fav"],
                        adID: userAds[index]["_id"],
                        relatedAds: 0,
                        ownerId: userAds[index]["userId"]["_id"],
                      ));
                }),
          ],
        ),
      ),
    );
  }
}
