import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:olx/config/config.dart';
import 'package:olx/config/service.dart';
import 'package:olx/screens/category_list.dart';
import 'package:olx/screens/category_sub.dart';
import 'package:olx/screens/productDetail.dart';
import 'package:olx/widgets/product.dart';

import '../config/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool _loading = true;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState

    getads();
    super.initState();
  }

  List categories = [];
  List ads = [];
  Future<void> getCategory() async {
    dynamic response = await ApiService().allCategories();
    categories = response["data"];
    // log(categories.toString());
  }

  Future<void> getads() async {
    setState(() {
      _loading = true;
    });
    getCategory();
    dynamic response = await ApiService().allads();
    ads = response["data"];
    if (response['status'] == 1) {
      setState(() {
        _loading = false;
      });
    }
    log(ads[0].toString());
  }

  Future<void> getUser() async {
    user = await Auth().getUser();
  }

  List images = ["assets/1.jpg", "assets/12.jpg"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/logo.png")),
                        // border: Border.all(),
                        shape: BoxShape.circle),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: const Image(
                          image: AssetImage("assets/car.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      const Text("MOTORS"),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: const Image(
                          image: AssetImage("assets/property.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text("PROPERTY"),
                    ],
                  ),
                ],
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(color: Colors.grey.shade100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.blue[900],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "204 Chak Road,Faisalabad",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.keyboard_arrow_down),
                          Spacer(),
                          Icon(
                            Icons.notifications_none,
                            color: Colors.indigoAccent,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          hintText: "What are you looking for?",
                          hintStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.amber),
                child: Swiper(
                  loop: true,
                  autoplay: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Image(
                      image: AssetImage(images[index]),
                      fit: BoxFit.fill,
                    );
                  },
                  itemCount: images.length,
                  viewportFraction: 1,
                  scale: 1,
                ),
              ),
              _loading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text(
                                "Browse Categories",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AllCategorisScreen(
                                          titleName: "All categoris",
                                          sellOrnot: 0,
                                          filter: 0,
                                        ),
                                      ));
                                },
                                child: Text(
                                  "See all",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.indigoAccent),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 100,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CategorySubScreen(
                                                  name: categories[index]
                                                      ["name"],
                                                  sellorNot: 0,
                                                  id: categories[index]["_id"],
                                                  filter: 0,
                                                ),
                                              ));
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    categories[index]["image"]),
                                                fit: BoxFit.fill),
                                            shape: BoxShape.circle,
                                            // border: Border.all()
                                          ),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 3,
                                      // ),
                                      Container(
                                        // decoration:
                                        //     BoxDecoration(border: Border.all()),
                                        height: 40,
                                        width: 50,
                                        child: Center(
                                          child: Text(
                                            categories[index]["name"],
                                            style: TextStyle(),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 8,
                                );
                              },
                              itemCount: categories.length),
                        ),

                        // SizedBox(
                        //   width: 20,
                        // ),
                        Container(
                          color: Colors.grey.shade100,
                          child: GridView.builder(
                              physics: const ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              itemCount: ads.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.7,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 1000),
                                        reverseTransitionDuration:
                                            Duration(milliseconds: 700),
                                        pageBuilder: (context, a, b) =>
                                            ProductDetail(
                                          detial: ads[index],
                                          productDetail: 0,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ProductContianer(
                                    image: Configuration.url +
                                        "/uploads/" +
                                        ads[index]["image"][0],
                                    name: ads[index]["title"],
                                    price: ads[index]["price"].toString(),
                                    date: Jiffy(ads[index]["datePublish"])
                                        .format('MMM do'),
                                    fav: ads[index]["fav"],
                                    adID: ads[index]["_id"],
                                    relatedAds: 0,
                                    ownerId: ads[index]["userId"]["_id"],
                                    // owner: ads[index]["userId"]["_id"] ==
                                    //         user["_id"]
                                    //     ? 1
                                    //     : 0, //"MMM do"
                                  ),
                                );
                                // productContianer
                                // Padding(
                                //   padding: const EdgeInsets.only(),
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //         color: Colors.white,
                                //         // border: Border.all(),
                                //         borderRadius:
                                //             BorderRadius.circular(8)),
                                //     height: 130,
                                //     width:
                                //         MediaQuery.of(context).size.width / 5,
                                //     child: Column(
                                //       children: [
                                //         Hero(
                                //           tag: index,
                                //           child: Container(
                                //             decoration: BoxDecoration(
                                //               borderRadius: BorderRadius.only(
                                //                   topLeft: Radius.circular(8),
                                //                   topRight:
                                //                       Radius.circular(8)),
                                //               image: DecorationImage(
                                //                 image: NetworkImage(
                                //                     Configuration.url +
                                //                         "/uploads/" +
                                //                         ads[index]["image"]
                                //                             [0]),
                                //                 fit: BoxFit.cover,
                                //               ),
                                //             ),
                                //             height: 145,
                                //             width: MediaQuery.of(context)
                                //                 .size
                                //                 .width,
                                //           ),
                                //         ),
                                //         SizedBox(
                                //           height: 10,
                                //         ),
                                //         Row(
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.start,
                                //           children: [
                                //             Expanded(
                                //               child: Padding(
                                //                 padding:
                                //                     const EdgeInsets.only(
                                //                         left: 10),
                                //                 child: Text(
                                //                   ads[index]["title"],
                                //                   style: TextStyle(
                                //                     fontSize: 14,
                                //                     fontWeight:
                                //                         FontWeight.bold,
                                //                     overflow:
                                //                         TextOverflow.ellipsis,
                                //                   ),
                                //                   maxLines: 2,
                                //                 ),
                                //               ),
                                //             ),
                                //             Padding(
                                //               padding: const EdgeInsets.only(
                                //                   right: 8, left: 4),
                                //               child: Icon(
                                //                 Icons.favorite_border,
                                //                 size: 20,
                                //                 color: Colors.black,
                                //               ),
                                //             )
                                //           ],
                                //         ),
                                //         SizedBox(
                                //           height: 10,
                                //         ),
                                //         Expanded(
                                //           child: Row(
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             children: [
                                //               Padding(
                                //                 padding: const EdgeInsets
                                //                         .symmetric(
                                //                     horizontal: 10),
                                //                 child: Text(
                                //                   "Rs " + ads[index]["price"],
                                //                   style: TextStyle(
                                //                       fontSize: 16,
                                //                       fontWeight:
                                //                           FontWeight.bold),
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //         Padding(
                                //           padding: const EdgeInsets.symmetric(
                                //               horizontal: 10, vertical: 4),
                                //           child: Row(
                                //             children: [
                                //               Container(
                                //                 // decoration: BoxDecoration(
                                //                 //     border: Border.all()),
                                //                 width: MediaQuery.of(context)
                                //                         .size
                                //                         .width /
                                //                     3.4,
                                //                 child: Text(
                                //                   "Address of Faisalabad",
                                //                   style: TextStyle(
                                //                       overflow: TextOverflow
                                //                           .ellipsis,
                                //                       fontSize: 12),
                                //                   maxLines: 1,
                                //                 ),
                                //               ),
                                //               Spacer(),
                                //               Text(
                                //                 Jiffy(ads[index]
                                //                         ["datePublish"])
                                //                     .format('MMM do'),
                                //                 style:
                                //                     TextStyle(fontSize: 12),
                                //               )
                                //             ],
                                //           ),
                                //         ),
                                //         SizedBox(
                                //           height: 5,
                                //         )
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              }),
                        ),
                      ],
                    ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
