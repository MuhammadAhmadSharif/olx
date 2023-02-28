// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:olx/config/service.dart';
import 'package:olx/screens/accessories.dart';
import 'package:olx/screens/category_grid.dart';
import 'package:olx/screens/filters.dart';
import 'package:olx/screens/sell_screens/ad_detail.dart';
import 'package:olx/screens/sell_screens/select_brand.dart';

class CategorySubScreen extends StatefulWidget {
  var id;
  int sellorNot;
  String name;
  int filter;

  CategorySubScreen({
    Key? key,
    required this.id,
    required this.sellorNot,
    required this.name,
    required this.filter,
  }) : super(key: key);

  @override
  State<CategorySubScreen> createState() => _CategorySubScreenState();
}

List subCategories = [];

class _CategorySubScreenState extends State<CategorySubScreen> {
  Future<void> getAllSubCategory() async {
    var categoryID = {"categoryId": widget.id};
    dynamic response = await ApiService().allSubCategories(categoryID);

    subCategories = response["data"];
    log(subCategories[0].toString());
    setState(() {});
  }

  @override
  void initState() {
    getAllSubCategory();
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
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: Text(
          widget.name,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: SingleChildScrollView(
            child: Column(children: [
          widget.sellorNot == 0 && widget.filter == 0
              ? Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: TextButton(
                          onPressed: () {
                            widget.filter == 1
                                ? Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoryGridScreen(
                                        subcategoryID: subCategories[0]["_id"],
                                        filterName: "all",
                                      ),
                                    ))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoryGridScreen(
                                        subcategoryID: subCategories[0]["_id"],
                                        filterName: "No Selected",
                                      ),
                                    ));
                          },
                          child: Text(
                            "See all in ${widget.name}",
                            style: TextStyle(
                                fontSize: 18, color: Colors.indigoAccent),
                          )),
                    ),
                  ],
                )
              : SizedBox(
                  height: 25,
                ),
          Column(
            children: [
              ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        widget.filter == 1
                            ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FilterScreen(
                                    categoryName: subCategories[index]["name"],
                                    subcatID: subCategories[index]["_id"],
                                    // fromfilterScreen: 0,
                                  ),
                                ))
                            : widget.sellorNot == 1
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdDetailScreen(
                                        categoryDetail: subCategories[index],
                                      ),
                                    ))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoryGridScreen(
                                        subcategoryID: subCategories[index]
                                            ["_id"],
                                        filterName: subCategories[index]["name"]
                                            .toString(),
                                      ),
                                    ));
                      },
                      child: Text(
                        subCategories[index]["name"],
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: subCategories.length),
              SizedBox(
                height: 20,
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => AccessoriesScreen(
              //             name: "Accessories",
              //             sellorNot: widget.sellorNot,
              //           ),
              //         ));
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 16),
              //     child: Row(
              //       children: [
              //         Text(
              //           "Accessories",
              //           style: TextStyle(fontSize: 18),
              //         ),
              //         Spacer(),
              //         Icon(
              //           Icons.arrow_forward_ios_rounded,
              //           size: 15,
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          )
        ])),
      ),
    );
  }
}
