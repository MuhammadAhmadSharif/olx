// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/screens/sell_screens/congratulation.dart';
import '../../config/auth.dart';
import '../../config/config.dart';
import '../../config/service.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class EditAdScreen extends StatefulWidget {
  var adsDetail;
  EditAdScreen({
    Key? key,
    required this.adsDetail,
  }) : super(key: key);

  @override
  State<EditAdScreen> createState() => _EditAdScreenState();
}

final priceControllar = TextEditingController();
final titleControllar = TextEditingController();
final detailControllar = TextEditingController();
List<Asset> images = <Asset>[];
bool _loading = false;
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

class _EditAdScreenState extends State<EditAdScreen> {
  File? img;
  var image;

  List finalImages = [];
  List<XFile>? imageFileList = [];

  var user;

  void adsApi() async {
    setState(() {
      _loading = true;
    });
    dynamic data = {
      "_id": widget.adsDetail["_id"],
      "price": priceControllar.text.toString(),
      "image": finalImages,
      "title": titleControllar.text.toString(),
      "description": detailControllar.text.toString(),
      "status": 1,
      "condition": selectedChip,
      "userId": user["_id"], //63cfdabd6c4b820a747c703f
      "subcategoryId": widget.adsDetail["subcategoryId"]["_id"],
    };
    var response = await ApiService().editUserads(data);
    if (response["status"] == 1) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CongratulationsScreen(),
          ));
      setState(() {
        _loading = false;
      });
    }
    log(response.toString());
  }

  Future<void> addimages() async {
    for (var i = 0; i < widget.adsDetail["image"].length; i++) {
      finalImages.add(widget.adsDetail["image"][i]);
      log("final images listtttttttttttttttttttttttttttttttt");
      log(finalImages.toString());
    }
  }

  List<Asset> resultList = <Asset>[];
  Future pickImage(ImageSource source) async {
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "OLX PAKISTAN",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      for (var i = 0; i < resultList.length; i++) {
        var img = resultList[i];
        var byteData = await img.getByteData();
        var base64 = base64Encode(byteData.buffer.asUint8List());
        var name = img.name;
        var data = {'image': base64, 'name': name};
        ApiService().fileUpload(data).then((value) {
          log("lllllllllllllllllllllllllllllllllllllllllllllllll");
          log(value.toString());
          if (value['status'] == 1) {
            // updating the fianlImages with the uploaded image name
            finalImages.add(value['address']);
            log(finalImages.toString());
          }
          setState(() {});
        });
      }
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  Future<void> getUser() async {
    user = await Auth().getUser();
    log(user.toString());
  }

  @override
  void initState() {
    addimages();

    priceControllar.text = widget.adsDetail["price"].toString();
    titleControllar.text = widget.adsDetail["title"];
    detailControllar.text = widget.adsDetail["description"];
    log(widget.adsDetail.toString());
    images.clear();
    log(widget.adsDetail.toString());
    getUser();
    // TODO: implement initState
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // Color disableColors = Colors.grey.shade100;
    // Color selecColor = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            Icons.close,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: Text(
          "Edit your ad",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 20),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey.shade100,
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: InkWell(
                            onTap: () {
                              pickImage(ImageSource.gallery);
                            },
                            child: Row(
                              children: [
                                Text(
                                  "UPLOAD UP TO 20 PHOTOS",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 15,
                                ),
                              ],
                            ),
                          )),
                      // images.isEmpty
                      //     ? InkWell(
                      //         onTap: () {
                      //           pickImage(ImageSource.gallery);
                      //         },
                      //         child: Container(
                      //           decoration:
                      //               BoxDecoration(color: Colors.tealAccent),
                      //           child: Container(
                      //             // margin: EdgeInsets.symmetric(horizontal: 50),
                      //             height: 150,
                      //             decoration: BoxDecoration(
                      //               color: Colors.teal[800],
                      //               borderRadius: BorderRadius.only(
                      //                   topLeft: Radius.elliptical(50, 50),
                      //                   bottomLeft: Radius.circular(50),
                      //                   bottomRight: Radius.circular(50),
                      //                   topRight: Radius.circular(50)),
                      //             ),
                      //             child: Center(
                      //                 child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               crossAxisAlignment: CrossAxisAlignment.center,
                      //               children: [
                      //                 Icon(
                      //                   Icons.add_circle_outline_outlined,
                      //                   color: Colors.white,
                      //                 ),
                      //                 SizedBox(
                      //                   width: 5,
                      //                 ),
                      //                 Text(
                      //                   "Add Images",
                      //                   style: TextStyle(
                      //                       fontSize: 18,
                      //                       fontWeight: FontWeight.bold,
                      //                       color: Colors.white),
                      //                 )
                      //               ],
                      //             )),
                      //           ),
                      //         ))
                      // :
                      Container(
                        height: 125,
                        decoration: BoxDecoration(
                          // color: Colors.teal[800],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(50, 50),
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                              topRight: Radius.circular(50)),
                        ),
                        child: ListView.separated(
                          itemCount: finalImages.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            // Asset asset = images[index];
                            return Container(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    height: 150,
                                    width: 150,
                                    child: Image(
                                      image: NetworkImage(Configuration.url +
                                          "/uploads/" +
                                          finalImages[index]),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                      right: -10,
                                      top: -10,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            finalImages.removeAt(index);
                                          });
                                        },
                                      ))
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: 5,
                            );
                          },
                        ),
                        // child: GridView.count(
                        //     scrollDirection: Axis.horizontal,
                        //     crossAxisCount: 3,
                        //     children: List.generate(images.length, (index) {
                        //       Asset asset = images[index];
                        //       return AssetThumb(
                        //         asset: asset,
                        //         width: 150,
                        //         height: 150,
                        //       );
                        //     })),
                      )
                      // : Container(
                      //     height: 150,
                      //     decoration: BoxDecoration(
                      //       color: Colors.transparent,
                      //       shape: BoxShape.circle,
                      //       border: Border.all(width: 6, color: Colors.white),
                      //       image: DecorationImage(
                      //           image: NetworkImage(Configuration.url +
                      //               "/" +
                      //               "uploads" +
                      //               "/" +
                      //               "image_picker5620826456608917038.png"),
                      //           fit: BoxFit.contain),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      "Category *",
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
                    // Container(
                    //   height: 65,
                    //   width: 65,
                    //   decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //         image: NetworkImage(
                    //             widget.categoryDetail["categoryId"]["image"]),
                    //         fit: BoxFit.contain),
                    //     shape: BoxShape.circle,
                    //     // border: Border.all()
                    //   ),
                    // ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.adsDetail["subcategoryId"]["name"],
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        // Text(
                        //   widget.categoryDetail["name"],
                        //   style: TextStyle(color: Colors.black54, fontSize: 18),
                        // ),
                      ],
                    )
                  ],
                ),
                Divider(
                  color: Colors.grey.shade200,
                  height: 20,
                  thickness: 2,
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Brand *",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Acer",
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
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
                      "Price *",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  // decoration: BoxDecoration(
                  //     border: Border.all(),
                  //     borderRadius: BorderRadius.circular(6)),
                  height: 50,
                  // width: MediaQuery.of(context).size.width / 2,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter the Price";
                      }
                      return null;
                    },
                    controller: priceControllar,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedErrorBorder: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      border: InputBorder.none,
                      errorBorder: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      focusColor: Colors.teal[800],

                      // hintText: "What are you looking for?",
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
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
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ChoiceChip(
                        shape: StadiumBorder(
                            side: BorderSide(color: Colors.grey.shade400)),
                        label: Text(
                          chip2,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        selected: selected1,
                        onSelected: (value) {
                          setState(() {
                            log(value.toString());
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
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 10),
                    //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    //   // width: 300,
                    //   // height: 50,
                    //   decoration: BoxDecoration(
                    //       color: Colors.grey.shade200,
                    //       shape: BoxShape.rectangle,
                    //       border: Border.all(color: Colors.grey.shade400),
                    //       borderRadius: BorderRadius.circular(18)),
                    //   child: Center(
                    // child: Text(
                    //   "USED",
                    //   style: TextStyle(
                    //       fontSize: 14, fontWeight: FontWeight.bold),
                    // ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ChoiceChip(
                        shape: StadiumBorder(
                            side: BorderSide(color: Colors.grey.shade400)),
                        label: Text(
                          chip3,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
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
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
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
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Location *",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Choose",
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
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
                      "Ad title *",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  // decoration: BoxDecoration(border: Border.all()),
                  height: 50,
                  // width: MediaQuery.of(context).size.width / 2,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter the Title";
                      }
                      return null;
                    },
                    controller: titleControllar,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      focusedErrorBorder: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      // disabledBorder: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      focusColor: Colors.teal[800],

                      // hintText: "What are you looking for?",
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
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
                      "Describe what you are selling *",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  // decoration: BoxDecoration(border: Border.all()),
                  height: 50,
                  // width: MediaQuery.of(context).size.width / 2,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter the detail";
                      }
                      return null;
                    },
                    controller: detailControllar,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      focusedErrorBorder: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      // disabledBorder: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      focusColor: Colors.teal[800],

                      // hintText: "What are you looking for?",
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.grey.shade200,
                  height: 20,
                  thickness: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: _loading
            ? () {}
            : () {
                if (_formKey.currentState!.validate()) {
                  adsApi();
                }
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
                ? CircularProgressIndicator()
                : Text(
                    "Next",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }
}
