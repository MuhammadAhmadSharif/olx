// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:olx/screens/filters.dart';
import 'package:olx/screens/productDetail.dart';
import '../config/config.dart';
import '../widgets/product.dart';

class FilterResultScreen extends StatefulWidget {
  var filterData;
  FilterResultScreen({
    Key? key,
    required this.filterData,
  }) : super(key: key);

  @override
  State<FilterResultScreen> createState() => _FilterResultScreenState();
}

bool isDeleted = false;
bool isDeleted1 = false;
List subCategories = [];

dynamic da;

class _FilterResultScreenState extends State<FilterResultScreen> {
  @override
  void initState() {
    // log(widget.filterData.toString());
    subCategories = widget.filterData;
    log(subCategories.toString());
    // log(widget.filterData[0].toString());
    // subCategories = widget.filterData[0]["data"];
    subCategories.toString();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
          child: Container(
            height: 60,
            decoration: BoxDecoration(color: Colors.grey.shade100),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                        // border: Border.all(),
                        ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 25,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 13,
                        ),
                        hintText: "What are you looking for?",
                        hintStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.dashboard,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          preferredSize: const Size.fromHeight(150)),
      body: widget.filterData == null || widget.filterData.isEmpty
          ? Center(
              child: Text(
              "Sorry! No data \n \n Kindly change the filters!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ))
          : NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return false;
              },
              child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilterScreen(
                                      categoryName: widget.filterData[0]
                                          ["subcategoryId"]["name"],
                                      subcatID: widget.filterData[0]
                                          ["subcategoryId"]["_id"],
                                      // fromfilterScreen: 1,
                                    ),
                                  ));
                            },
                            child: Container(
                              height: 35,
                              width: 80,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.indigoAccent),
                                  borderRadius: BorderRadius.circular(18)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.menu,
                                    color: Colors.indigoAccent,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Filters",
                                    style: TextStyle(
                                        color: Colors.indigoAccent,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          (isDeleted1)
                              ? SizedBox()
                              : InputChip(
                                  shape: StadiumBorder(
                                      side: BorderSide(color: Colors.black12)),
                                  label: Text(
                                    "Faisalabad",
                                    selectionColor: Colors.blue,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  backgroundColor: Colors.white,
                                  deleteIcon: Icon(Icons.cancel_outlined),
                                  deleteIconColor: Colors.black,
                                  onDeleted: () {
                                    setState(() {
                                      isDeleted1 = true;
                                    });
                                  },
                                ),
                          (isDeleted)
                              ? SizedBox()
                              : InputChip(
                                  shape: StadiumBorder(
                                      side: BorderSide(color: Colors.black12)),
                                  label: FittedBox(
                                    child: Text(
                                      widget.filterData[0]["subcategoryId"]
                                          ["name"],
                                      selectionColor: Colors.blue,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                  deleteIcon: Icon(Icons.cancel_outlined),
                                  deleteIconColor: Colors.black,
                                  onDeleted: () {
                                    setState(() {
                                      isDeleted = true;
                                    });
                                  },
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Showing:",
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 16),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "${subCategories.length}" +
                                  " Results for Mobiles",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              "Sort By",
                              style: TextStyle(
                                  color: Colors.indigoAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Image(
                              image: AssetImage("assets/updownarrow.png"),
                              height: 12,
                            )
                          ],
                        )),
                    GridView.builder(
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        itemCount: subCategories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                        detial: subCategories[index],
                                        productDetail: 0,
                                        // indexfortag: index,
                                      ),
                                    ));
                              },
                              child: ProductContianer(
                                image: Configuration.url +
                                    "/uploads/" +
                                    subCategories[index]["image"][0],
                                name: subCategories[index]["title"],
                                price: subCategories[index]["price"].toString(),
                                date: Jiffy(subCategories[index]["datePublish"])
                                    .format('MMM do'),
                                fav: subCategories[index]["fav"],
                                adID: subCategories[index]["_id"],
                                relatedAds: 0,
                                ownerId: subCategories[index]["userId"]["_id"],
                                // owner: subCategories[index]["userId"]["_id"],
                              ));
                        }

                        // Container(
                        //   height: MediaQuery.of(context).size.height - 200,
                        //   decoration: BoxDecoration(border: Border.all()),
                        // ),
                        )
                  ]),
            ),
    ));
  }
}
