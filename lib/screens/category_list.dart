// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:olx/screens/bottom_bar.dart';
import 'package:olx/screens/category_sub.dart';

import '../config/service.dart';

class AllCategorisScreen extends StatefulWidget {
  int filter;
  int sellOrnot;
  String titleName;
  AllCategorisScreen({
    Key? key,
    required this.filter,
    required this.sellOrnot,
    required this.titleName,
  }) : super(key: key);

  @override
  State<AllCategorisScreen> createState() => _AllCategorisScreenState();
}

List catName = [
  "Mobiles",
  "Vehicles",
  "Kids",
  "Bikes",
];
List catimage = [
  "assets/category/smartphone.png",
  "assets/category/car.png",
  "assets/category/kids.png",
  "assets/category/bike.png",
];
List catName1 = [
  "Services",
  "Jobs",
  "Animals",
  "Fashion & Beauty",
  "Books, Sports & Hobbies",
  "Electronics & Home Appliances",
  "Business, Industrial & Agriculture",
  "Furniture & Home Decor",
];
List catimage1 = [
  "assets/category/service.png",
  "assets/category/businessman.png",
  "assets/category/bear.png",
  "assets/category/fashion.png",
  "assets/category/books.png",
  "assets/category/power.png",
  "assets/category/businessman.png",
  "assets/category/furniture.png"
];
List categories = [];
List popularCategory = [];
List otherCategory = [];
Future<void> popularCat() async {
  dynamic response = await ApiService().allCategories();
  categories = response["data"];
  popularCategory = categories.where((e) => e['popular'] == 1).toList();
  log(popularCategory[0].toString());
  otherCategory = categories.where((e) => e['popular'] == 0).toList();
  log(otherCategory[0].toString());
}

// Future<void> otherCat() async {
//   dynamic response = await ApiService().allCategories();
//   otherCategory = response["data"]["popular"];

//   log(otherCategory[0].toString());
// }

class _AllCategorisScreenState extends State<AllCategorisScreen> {
  @override
  void initState() {
    popularCat();
    // otherCat();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            icon: widget.sellOrnot == 0
                ? Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                  )
                : Icon(
                    Icons.close,
                    size: 20,
                  ),
            onPressed: () {
              widget.sellOrnot == 0
                  ? Navigator.pop(context)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BottomBar()),
                    );
            },
          ),
          backgroundColor: Colors.grey.shade100,
          elevation: 0,
          title: Text(
            widget.titleName,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: ApiService().allCategories(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(child: CircularProgressIndicator()));
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              "Popular",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: popularCategory.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  widget.filter == 1
                                      ? Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CategorySubScreen(
                                              name: popularCategory[index]
                                                  ["name"],
                                              sellorNot: widget.sellOrnot,
                                              id: popularCategory[index]["_id"],
                                              filter: widget.filter,
                                            ),
                                          ))
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CategorySubScreen(
                                              name: popularCategory[index]
                                                  ["name"],
                                              sellorNot: widget.sellOrnot,
                                              id: popularCategory[index]["_id"],
                                              filter: widget.filter,
                                            ),
                                          ));
                                  // : Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => CategorySubScreen(
                                  //             sellorNot: 1, name: catName[index])));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                popularCategory[index]
                                                    ["image"]),
                                            fit: BoxFit.contain),
                                        shape: BoxShape.circle,
                                        // border: Border.all()
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      popularCategory[index]["name"],
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 15,
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 18,
                              );
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Others",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: otherCategory.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    widget.filter == 1
                                        ? Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CategorySubScreen(
                                                name: otherCategory[index]
                                                    ["name"],
                                                sellorNot: widget.sellOrnot,
                                                id: otherCategory[index]["_id"],
                                                filter: widget.filter,
                                              ),
                                            ))
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CategorySubScreen(
                                                name: otherCategory[index]
                                                    ["name"],
                                                sellorNot: widget.sellOrnot,
                                                id: otherCategory[index]["_id"],
                                                filter: widget.filter,
                                              ),
                                            ));
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  otherCategory[index]
                                                      ["image"]),
                                              fit: BoxFit.contain),
                                          shape: BoxShape.circle,
                                          // border: Border.all()
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        otherCategory[index]["name"],
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 15,
                                      )
                                    ],
                                  ));
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 18,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ));
  }
}
