// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:olx/config/service.dart';
import 'package:olx/screens/category_grid.dart';
import 'package:olx/screens/category_list.dart';
import 'package:olx/screens/filterResult.dart';

class FilterScreen extends StatefulWidget {
  var categoryName;
  var subcatID;
  // int fromfilterScreen;
  FilterScreen({
    Key? key,
    // required this.fromfilterScreen,
    required this.categoryName,
    required this.subcatID,
  }) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

final fromControllar = TextEditingController();
final toControllar = TextEditingController();

bool selected = false;
bool selected1 = false;
bool selected2 = false;
bool selected3 = false;
bool selected4 = false;

String chip1 = "NEW";
String chip2 = "USED";
String chip3 = "OPEN BOX";
String chip4 = "REFURBISHED";
String chip5 = "FOR PARTS OR NOT WORKING";

String selectedChip = "";
var data;
bool _loading = false;

class _FilterScreenState extends State<FilterScreen> {
  @override
  void initState() {
    log(widget.categoryName.toString());
    // TODO: implement initState
    super.initState();
  }

  void filterData() async {
    setState(() {
      _loading = true;
    });
    data = {
      "condition": selectedChip,
      "priceMin": fromControllar.text,
      "priceMax": toControllar.text,
      "subcategoryId": widget.subcatID,
    };
    print(data);
    var response = await ApiService().filterads(data);
    // log(response["data"].toString());
    if (response["status"] == 1) {
      setState(() {
        _loading = false;
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FilterResultScreen(
                    filterData: response["data"],
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            Icons.close,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: Text(
          "Filters",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Center(
              child: InkWell(
                onTap: () {
                  fromControllar.clear();
                  toControllar.clear();
                  setState(() {
                    selectedChip = "";
                    selected1 = false;
                    selected2 = false;
                    selected3 = false;
                    selected4 = false;
                    selected = false;
                  });
                },
                child: Text(
                  "Clear all",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 18),
          children: [
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllCategorisScreen(
                        sellOrnot: 0,
                        titleName: "All Categories",
                        filter: 1,
                      ),
                    ));
                // (Route<dynamic> route) => false);
              },
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Category",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.categoryName,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.grey.shade200,
              height: 20,
              thickness: 2,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Locations",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Khayaban Colony 3, Faisalabad",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.grey.shade200,
              height: 20,
              thickness: 2,
            ),
            Row(
              children: [
                Text(
                  "Price",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "From",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 12, top: 10),
                          height: 45,
                          width: MediaQuery.of(context).size.width / 2.1,
                          child: TextFormField(
                            controller: fromControllar,
                            // validator: (value) {
                            //   if (double.parse(value!) < 250) {
                            //     return 'Value must be greater than or equal to 250';
                            //   }
                            //   return null;
                            // },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 13,
                              ),
                              hintText: "250",
                              hintStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "To",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 12, top: 10),
                          height: 45,
                          width: MediaQuery.of(context).size.width / 2.1,
                          // decoration: BoxDecoration(
                          // border: Border.all(),
                          // borderRadius: BorderRadius.circular(4)),
                          child: TextFormField(
                            controller: toControllar,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 13,
                              ),
                              hintText: "1,000,000",
                              hintStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.grey.shade200,
              height: 20,
              thickness: 2,
            ),
            // Row(
            //   children: [
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Brand",
            //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            //         ),
            //         SizedBox(
            //           height: 5,
            //         ),
            //         Text(
            //           "Any",
            //           style: TextStyle(fontSize: 16, color: Colors.black54),
            //         ),
            //       ],
            //     ),
            //     Spacer(),
            //     Icon(
            //       Icons.arrow_forward_ios_rounded,
            //       size: 15,
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.grey.shade200,
              height: 20,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "Condition *",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                ChoiceChip(
                  shape: StadiumBorder(
                      side: BorderSide(color: Colors.grey.shade400)),
                  label: Text(
                    chip1,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  selected: selected,
                  onSelected: (value) {
                    setState(() {
                      selectedChip = chip1;
                      selected = value;
                      selected1 = false;
                      selected2 = false;
                      selected3 = false;
                      selected4 = false;
                    });
                  },
                  disabledColor: Colors.grey.shade100,
                  selectedColor: Colors.blue,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    shape: StadiumBorder(
                        side: BorderSide(color: Colors.grey.shade400)),
                    label: Text(
                      chip2,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    selected: selected1,
                    onSelected: (value) {
                      setState(() {
                        selectedChip = chip2;
                        selected1 = value;
                        selected2 = false;
                        selected3 = false;
                        selected4 = false;
                        selected = false;
                      });
                    },
                    disabledColor: Colors.grey.shade100,
                    selectedColor: Colors.blue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    shape: StadiumBorder(
                        side: BorderSide(color: Colors.grey.shade400)),
                    label: Text(
                      chip3,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    selected: selected2,
                    onSelected: (value) {
                      setState(() {
                        selectedChip = chip3;
                        selected2 = value;
                        selected1 = false;
                        selected = false;
                        selected3 = false;
                        selected4 = false;
                      });
                    },
                    disabledColor: Colors.grey.shade100,
                    selectedColor: Colors.blue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    shape: StadiumBorder(
                        side: BorderSide(color: Colors.grey.shade400)),
                    label: Text(
                      chip4,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    selected: selected3,
                    onSelected: (value) {
                      setState(() {
                        selectedChip = chip4;
                        selected3 = value;
                        selected1 = false;
                        selected2 = false;
                        selected = false;
                        selected4 = false;
                      });
                    },
                    disabledColor: Colors.grey.shade100,
                    selectedColor: Colors.blue,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  ChoiceChip(
                    shape: StadiumBorder(
                        side: BorderSide(color: Colors.grey.shade400)),
                    label: Text(
                      chip5,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    selected: selected4,
                    onSelected: (value) {
                      setState(() {
                        selectedChip = chip5;
                        selected4 = value;
                        selected1 = false;
                        selected2 = false;
                        selected3 = false;
                        selected = false;
                      });
                    },
                    disabledColor: Colors.grey.shade100,
                    selectedColor: Colors.blue,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.grey.shade200,
              height: 20,
              thickness: 2,
            ),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: _loading
            ? () {}
            : () {
                filterData();
              },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.blueGrey[900],
              borderRadius: BorderRadius.circular(4)),
          child: Center(
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      "APPLY",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
        ),
      ),
    );
  }
}
