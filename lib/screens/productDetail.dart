// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:olx/config/service.dart';
import 'package:olx/screens/chat/chats.dart';
import 'package:olx/screens/sell_screens/seller_profile.dart';
import 'package:olx/widgets/product.dart';
import '../config/auth.dart';
import '../config/config.dart';

class ProductDetail extends StatefulWidget {
  int productDetail;
  var detial;

  ProductDetail({
    Key? key,
    required this.productDetail,
    required this.detial,
  }) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

List favList = [];

int myIndex = 0;
List images = [];
bool _loading = true;
bool _loading2 = true;

void addimaegestoList() {
  images.clear();
}

class _ProductDetailState extends State<ProductDetail> {
  bool _loading = false;
  bool _loading3 = true;
  bool _loading4 = true;
  String phoneNumber = "";

  var user;
  Future<void> getUser() async {
    user = await Auth().getUser();
    favList = widget.detial["fav"];
    phoneNumber = widget.detial["userId"]["phoneNumber"];
    // favList.removeAt(widget.detial["_id"]);
    // log(user.toString());
    setState(() {
      _loading3 = false;
      _loading4 = false;
    });
  }

  void addFirestore() async {
    setState(() {
      _loading = true;
    });
    log("main run howa hoo".toString());
    final firestore = await FirebaseFirestore.instance
        .collection("${widget.detial["_id"]}" +
            "_" +
            "${widget.detial["userId"]["_id"]}" +
            "_" +
            "${user["_id"]}")
        .add({
      "ownerId": widget.detial["userId"]["_id"],
      "message": "Lets Make a Deal with this product " + widget.detial["title"],
      "sender_id": user["_id"],
      "${widget.detial["userId"]["_id"]}": false,
      "${user["_id"]}": true,
      "created_At": DateTime
          .now(), //your data which will be added to the collection and collection will be created after this
    }).then((_) {
      log("collection created".toString());
    }).catchError((_) {
      log("an error occured".toString());
    });
  }

  _textMe() async {
    // Android
    var uri = 'sms:$phoneNumber'
        '?body=Hello sir I want to buy your product from OLX application. Can you come online for a while on the OLX application?';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      uri = 'sms:$phoneNumber'
          '?body=hello%20there';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  Future<void> askapiData() async {
    log("api call hoi ha");
    dynamic body = {
      "lastMessage":
          "Lets Make a Deal with this product " + "${widget.detial["title"]}",
      "adId": widget.detial["_id"],
      "userId": user["_id"],
      "ownerId": widget.detial["userId"]["_id"],
      "image": widget.detial["image"][0],
      "pName": widget.detial["title"],
      "userName": user["name"],
      "lastMessagedate": DateTime.now().toString(),
    };

    // log(body.toString());
    dynamic responce = await ApiService().chatButton(body);
    log(responce.toString());
    if (responce["status"] == 1) {
      addFirestore();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(),
          ));
      setState(() {
        _loading = false;
      });
    } else if (responce["status"] == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(),
          ));
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    getUser();
    images.clear();
    relatedAds();
    log(widget.detial.toString());
    images.add(widget.detial["image"]);
    // log(images.toString());
    // TODO: implement initState
    super.initState();
  }

  List relatedads = [];
  dynamic data;
  var body;
  favads() async {
    body = {
      "_id": widget.detial["_id"],
      "fav": user["_id"],
    };
    var response = await ApiService().favAds(body);
    if (response["status"] == 1) {
      setState(() {
        favList.contains(user["_id"])
            ? favList.remove(user["_id"])
            : favList.add(user["_id"]);
      });
    }
    log(response["status"].toString());
  }

  Unfavads() async {
    body = {
      "_id": widget.detial["_id"],
      "fav": user["_id"],
    };
    var response = await ApiService().unfavAds(body);
    if (response["status"] == 1) {
      setState(() {
        favList.contains(user["_id"])
            ? favList.remove(user["_id"])
            : favList.add(user["_id"]);
      });
    }
    log(response["status"].toString());
  }

  Future<void> relatedAds() async {
    setState(() {
      _loading2 = true;
    });
    data = {"subcategoryId": widget.detial["subcategoryId"]["_id"]};
    var response = await ApiService().findads(data);
    relatedads = response["data"];
    int index = relatedads
        .indexWhere((element) => element["_id"] == widget.detial['_id']);
    log(index.toString());
    if (index != -1) {
      relatedads.removeAt(index);
    }
    setState(() {
      _loading2 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
            children: [
              NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowIndicator();
                  return false;
                },
                child: ListView(
                  children: [
                    Container(
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: Swiper(
                        loop: false,
                        autoplay: false,
                        itemBuilder: (BuildContext context, int index) {
                          return Hero(
                            tag: widget.detial['_id'],
                            child: Image(
                              image: NetworkImage(Configuration.url +
                                  "/uploads/" +
                                  images[0][index]),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        itemCount: images[0].length,
                        viewportFraction: 1,
                        scale: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                "Rs " + widget.detial["price"].toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              Spacer(),
                              _loading4
                                  ? CircularProgressIndicator()
                                  : widget.detial["userId"]["_id"] ==
                                          user["_id"]
                                      ? Visibility(
                                          child: Icon(
                                          Icons.favorite,
                                          size: 0.1,
                                        ))
                                      : favList.contains(user["_id"])
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  Unfavads();
                                                });
                                              },
                                              child: favicon)
                                          : InkWell(
                                              onTap: () {
                                                setState(() {
                                                  favads();
                                                });
                                              },
                                              child: unFavicon)
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                widget.detial["title"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.black87,
                                size: 22,
                              ),
                              Text(
                                "D Ground, Faisalabad",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              Spacer(),
                              Text(
                                Jiffy(widget.detial["datePublish"])
                                    .format('MMM do yyyy'),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Divider(
                              color: Colors.grey.shade200,
                              height: 20,
                              thickness: 2,
                            ),
                          ),
                          Row(
                            children: [
                              Text("Details",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text("Brand",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 18)),
                              Spacer(),
                              Text("Samsung",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 18)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Divider(
                              color: Colors.grey.shade200,
                              thickness: 2,
                              height: 20,
                            ),
                          ),
                          Row(
                            children: [
                              Text("Condition",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 18)),
                              Spacer(),
                              Text(widget.detial["condition"],
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 18)),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Divider(
                              color: Colors.grey.shade200,
                              thickness: 2,
                              height: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Text("Description",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ReadMoreText(
                              widget.detial["description"],
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                              trimLines: 2,
                              textAlign: TextAlign.start,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: '    READ MORE',
                              trimExpandedText: '     READ LESS',
                              moreStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              lessStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Divider(
                              color: Colors.grey.shade200,
                              thickness: 2,
                              height: 20,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("assets/logo.png"),
                                        fit: BoxFit.contain),
                                    shape: BoxShape.circle,
                                    border: Border.all()),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: InkWell(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.detial["userId"]["name"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          "Member since " +
                                              Jiffy(widget.detial["userId"]
                                                      ["joinDate"])
                                                  .format('MMM do yyyy'),
                                          style: TextStyle(fontSize: 16)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SellerProfileScreen(
                                                  userinfo:
                                                      widget.detial["userId"],
                                                ),
                                              ));
                                          // }
                                        },
                                        child: Text("SEE PROFILE",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.indigoAccent,
                                                fontSize: 18)),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Divider(
                              color: Colors.grey.shade200,
                              thickness: 2,
                              height: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Text("Related Ads",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ],
                            ),
                          ),
                          _loading2
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  height: 270,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            // widget.productDetail == 0
                                            //     ? Navigator.push(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               ProductDetail(
                                            //             detial:
                                            //                 relatedads[index],
                                            //             productDetail: 1,
                                            //           ),
                                            //         ))
                                            //     :
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetail(
                                                    detial: relatedads[index],
                                                    productDetail: 1,
                                                  ),
                                                ));
                                          },
                                          child: Container(
                                              height: 130,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.23,
                                              child: ProductContianer(
                                                image: Configuration.url +
                                                    "/uploads/" +
                                                    relatedads[index]["image"]
                                                        [0],
                                                name: relatedads[index]
                                                    ["title"],
                                                price: relatedads[index]
                                                        ["price"]
                                                    .toString(),
                                                date: Jiffy(relatedads[index]
                                                        ["datePublish"])
                                                    .format('MMM do'),
                                                fav: relatedads[index]["fav"],
                                                adID: relatedads[index]["_id"],
                                                relatedAds: 1,
                                                ownerId: relatedads[index]
                                                    ["userId"]["_id"],
                                                // owner: relatedads[index]
                                                //             ["userId"]["_id"] ==
                                                //         user["_id"]
                                                //     ? 1
                                                //     : 0,
                                              )),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          width: 10,
                                        );
                                      },
                                      itemCount: relatedads.length),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Your safety matters to us!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22)),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                  "• Only meet in public/crowded places for example metro stations and malls. \n• Never go alone to meet a buyer/seller, always take someone with you.\n• Check and inspect the product properly before purchasing it. \n • Never pay anything in advance or transfer money before inspecting the product",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //positioned stack
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Spacer(),
                    IconButton(
                      color: Colors.white,
                      icon: Icon(
                        Icons.share_outlined,
                        size: 22,
                      ),
                      onPressed: () async {
                        await Share.share(widget.detial["title"] +
                            " is available on OLX" +
                            "."
                                "\n The Price of this Product is " +
                            "Rs. " +
                            widget.detial["price"].toString() +
                            ".");
                      },
                    )
                  ],
                ),
              )
            ],
          ),
          bottomNavigationBar: _loading3
              ? Center(child: CircularProgressIndicator())
              : widget.detial["userId"]["_id"] == user["_id"]
                  ? SizedBox(
                      height: 10,
                    )
                  : BottomAppBar(
                      // elevation: 0,
                      child: Container(
                        // color: Theme.of(context).iconTheme.color,
                        height: 70,
                        // width: ,
                        // decoration: BoxDecoration(
                        //     border: Border.all(), borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: _loading
                                    ? () {}
                                    : () {
                                        // if (widget.detial["userId"]["_id"] ==
                                        //     user["_id"]) {
                                        //   setState(() {
                                        //     _loading = true;
                                        //   });
                                        //   Fluttertoast.showToast(
                                        //       msg: "This is your Ad :)",
                                        //       toastLength: Toast.LENGTH_SHORT,
                                        //       gravity: ToastGravity.BOTTOM,
                                        //       textColor: Colors.white,
                                        //       fontSize: 16.0);
                                        //   Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //         builder: (context) => ChatScreen(),
                                        //       ));
                                        //   setState(() {
                                        //     _loading = false;
                                        //   });
                                        // } else {
                                        askapiData();
                                        // }
                                      },
                                child: Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 3.2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(),
                                      color: Colors.blueGrey[900]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.message_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      _loading
                                          ? CircularProgressIndicator()
                                          : Text(
                                              "Chat",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => launch("tel://" +
                                    widget.detial["userId"]["phoneNumber"]),
                                child: Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 3.2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(),
                                      color: Colors.blueGrey[900]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.call,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Call",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(),
                                      ));
                                },
                                child: InkWell(
                                  onTap: () {
                                    _textMe();
                                  },
                                  child: Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width / 3.2,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(),
                                        color: Colors.blueGrey[900]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.email_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "SMS",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
          // bottomNavigationBar: Container(
          //   child: Column(
          //     children: [],
          //   ),
          // ),
          ),
    );
  }
}
