// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:olx/config/service.dart';

import '../config/auth.dart';

class ProductContianer extends StatefulWidget {
  int relatedAds;
  String name;
  String price;
  String image;
  String date;
  List fav;
  String adID;
  String ownerId;

  ProductContianer({
    Key? key,
    required this.relatedAds,
    required this.name,
    required this.price,
    required this.image,
    required this.date,
    required this.fav,
    required this.adID,
    required this.ownerId,
  }) : super(key: key);

  @override
  State<ProductContianer> createState() => _ProductContianerState();
}

var user;
bool _loading = true;
Icon favicon = Icon(
  Icons.favorite,
  size: 20,
  color: Colors.red,
);

Icon unFavicon = Icon(
  Icons.favorite_border,
  size: 20,
  color: Colors.black,
);

class _ProductContianerState extends State<ProductContianer> {
  Future<void> getUser() async {
    setState(() {
      _loading = true;
    });
    user = await Auth().getUser();
    log(user.toString());
    setState(() {
      _loading = false;
    });
  }

  var body;
  favads() async {
    body = {
      "_id": widget.adID,
      "fav": user["_id"],
    };
    var response = await ApiService().favAds(body);
    if (response["status"] == 1) {
      setState(() {
        widget.fav.contains(user["_id"])
            ? widget.fav.remove(user["_id"])
            : widget.fav.add(user["_id"]);
      });
    }
    log(response["status"].toString());
  }

  Unfavads() async {
    body = {
      "_id": widget.adID,
      "fav": user["_id"],
    };
    var response = await ApiService().unfavAds(body);
    if (response["status"] == 1) {
      setState(() {
        widget.fav.contains(user["_id"])
            ? widget.fav.remove(user["_id"])
            : widget.fav.add(user["_id"]);
      });
    }
    log(response["status"].toString());
  }

  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              tag: widget.relatedAds == 1
                  ? widget.adID + widget.adID
                  : widget.adID,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  image: DecorationImage(
                    image: NetworkImage(widget.image),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 145,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
                _loading
                    ? CircularProgressIndicator()
                    : widget.ownerId == user["_id"]
                        ? Visibility(
                            child: Icon(
                            Icons.favorite,
                            size: 0.1,
                          ))
                        : Padding(
                            padding: const EdgeInsets.only(right: 8, left: 4),
                            child: widget.fav.contains(user["_id"])
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
                                    child: unFavicon))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Rs " + widget.price.toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(
                children: [
                  Container(
                    // decoration: BoxDecoration(border: Border.all()),
                    width: MediaQuery.of(context).size.width / 3.6,
                    child: FittedBox(
                      child: Text(
                        "Address of Faisalabad",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis, fontSize: 12),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    widget.date,
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
    );
  }
}
