// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:olx/screens/sell_screens/select_brand.dart';

class AccessoriesScreen extends StatefulWidget {
  int sellorNot;
  String name;
  AccessoriesScreen({
    Key? key,
    required this.sellorNot,
    required this.name,
  }) : super(key: key);

  @override
  State<AccessoriesScreen> createState() => _AccessoriesScreenState();
}

class _AccessoriesScreenState extends State<AccessoriesScreen> {
  List accessories = [
    "Earphone",
    "Other Accessories",
    "Charges",
    "Headphones",
    "Covers & Cases",
    "Power Banks",
    "Charging Cables",
    "Screens",
    "Ring Lights",
    "Mobiles Stands",
    "Converters",
    "External Memory",
    "Selfie Sticks",
    "Screen Protextors"
  ];

  @override
  Widget build(BuildContext context) {
    log(widget.sellorNot.toString());
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              color: Colors.black,
              icon: const Icon(
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
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                widget.sellorNot == 0
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 8),
                            child: TextButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           CategoryGridScreen(),
                                  //     ));
                                },
                                child: Text(
                                  "See all in ${widget.name}",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.indigoAccent),
                                )),
                          ),
                        ],
                      )
                    : const SizedBox(
                        height: 8,
                      ),
                Column(
                  children: [
                    ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              // widget.sellorNot == 1
                              //     ? Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) =>
                              //               SelectBrandScreen(),
                              //         ))
                              //     : Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) =>
                              //               CategoryGridScreen(),
                              //         ));
                            },
                            child: Text(
                              accessories[index],
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 20,
                          );
                        },
                        itemCount: accessories.length),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
