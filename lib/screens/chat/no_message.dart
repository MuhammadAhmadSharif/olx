import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiffy/jiffy.dart';
import '../../config/auth.dart';
import '../../config/config.dart';
import '../../config/service.dart';
import 'all_message.dart';

class NoMessageScreen extends StatefulWidget {
  const NoMessageScreen({super.key});

  @override
  State<NoMessageScreen> createState() => _NoMessageScreenState();
}

class _NoMessageScreenState extends State<NoMessageScreen> {
  var user;
  var userdata;
  bool _loading = false;
  bool _loading2 = true;
  List unreadMessages = [];
  List collectionName = [];

  List data = [];
  Future<void> getUser() async {
    unreadMessages.clear();

    user = await Auth().getUser();
    log(user.toString());
    userdata = {
      "id": user["_id"],
    };
    var response = await ApiService().findallConv(userdata);
    log(response["data"][0].toString());
    data = response["data"];
    setState(() {});
    countDocumentsWithFieldInAllCollections(user["_id"]);
  }

  @override
  void initState() {
    getUser();
    setState(() {});
    // TODO: implement initState
    super.initState();
  }

  deleteMessages(_id, index) async {
    setState(() {
      _loading = true;
    });
    log(_id.toString());
    var response = await ApiService().deleteMessages(_id);
    log(response.toString());
    if (response["status"] == 1) {
      deletchat(index);
    }
  }

  deletchat(index) async {
    final CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("${data[index]["adId"]["_id"]}" +
            "_" +
            "${data[index]["ownerId"]}" +
            "_" +
            data[index]["userId"]["_id"]);
    await collectionReference.get().then((snapshot) {
      for (DocumentSnapshot document in snapshot.docs) {
        document.reference.delete();
      }
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
          msg: "Chat has been deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          fontSize: 16.0);
      initState();
    });
  }

  Future countDocumentsWithFieldInAllCollections(String fieldName) async {
    log("i am in the field ");
    unreadMessages.clear();
    collectionName.clear();
    for (int i = 0; i < data.length; i++) {
      collectionName.add("${data[i]["adId"]["_id"]}" +
          "_" +
          "${data[i]["ownerId"]}" +
          "_" +
          "${data[i]["userId"]["_id"]}");
    }
    List<CollectionReference> collections = [];
    for (String collectionName in collectionName) {
      collections.add(FirebaseFirestore.instance.collection(collectionName));
    }
    for (CollectionReference collectionReference in collections) {
      final QuerySnapshot querySnapshot =
          await collectionReference.where(fieldName, isEqualTo: false).get();
      unreadMessages.add(querySnapshot.docs.length);
    }
    log(unreadMessages.toString());
    setState(() {
      _loading2 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: FutureBuilder(
            future: ApiService().findallConv(userdata),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else if (data.isEmpty) {
                return ListView(children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage("assets/message.png"))),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "No messages yet?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Find something you like and start a \nconversation!",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 1.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.blueGrey[800],
                                ),
                                child: Center(
                                  child: Text(
                                    "Explore the latest ads",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ]);
              } else {
                return Container(
                  padding: EdgeInsets.only(bottom: 30),
                  height: MediaQuery.of(context).size.height / 1.29,
                  // decoration: BoxDecoration(border: Border.all()),
                  child: ListView.separated(
                    itemCount: data.length,
                    // padding: EdgeInsets.only(top: 10),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllMessagesScreen(
                                  data: data[index],
                                ),
                              )).then((value) => getUser());
                        },
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Container(
                                        height: 65,
                                        width: 65,
                                        decoration: BoxDecoration(
                                            // border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    Configuration.url +
                                                        "/uploads/" +
                                                        data[index]["image"]),
                                                fit: BoxFit.fill)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              data[index]["userId"]["name"],
                                              // data[index]["pName"],
                                              style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      data[index]["adId"]
                                                          ["title"],
                                                      // "${data[index]["lastMessage"]}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: GoogleFonts.lato(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 30),
                                                    child: _loading2 ||
                                                            unreadMessages
                                                                    .length <
                                                                data.length
                                                        ? const CircleAvatar(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            radius: 8,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 1,
                                                            ))
                                                        : unreadMessages[
                                                                    index] !=
                                                                0
                                                            ? CircleAvatar(
                                                                radius: 8,
                                                                child: Center(
                                                                    child: FittedBox(
                                                                        child: Text(

                                                                            // "0"
                                                                            // :
                                                                            unreadMessages[index].toString()))),
                                                              )
                                                            : SizedBox())
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      data[index]
                                                          ["lastMessage"],
                                                      // "${data[index]["lastMessage"]}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: GoogleFonts.lato(
                                                          fontSize: 16,
                                                          color: HexColor(
                                                              "#383838"))),
                                                ),
                                                PopupMenuButton(
                                                  padding: EdgeInsets.only(
                                                      right: 24),
                                                  icon: Icon(
                                                    Icons.more_vert_rounded,
                                                    color: Colors.black,
                                                  ),
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                        onTap: () {
                                                          deleteMessages(
                                                              data[index]
                                                                  ["_id"],
                                                              index);
                                                        },
                                                        // onTap: () {
                                                        //   FirebaseFirestore
                                                        //       .instance
                                                        //       .collection(
                                                        //           "${data[index]["adId"]["_id"]}" +
                                                        //               "_" +
                                                        //               "${data[index]["ownerId"]}" +
                                                        //               user[
                                                        //                   "_id"])
                                                        //       .get()
                                                        //       .then((snapshot) {
                                                        //     for (var document
                                                        //         in snapshot
                                                        //             .docs) {
                                                        //       document.reference
                                                        //           .delete();
                                                        //     }
                                                        //   });
                                                        // },
                                                        child: _loading
                                                            ? CircularProgressIndicator()
                                                            : Row(
                                                                children: [
                                                                  Text(
                                                                    "Delete Chat",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ],
                                                              )),
                                                    PopupMenuItem(
                                                        onTap: () {},
                                                        child: Text(
                                                          "Cencel",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Positioned(
                                  top: 20,
                                  right: 30,
                                  child: Text(
                                    Jiffy(data[index]["lastMessagedate"])
                                        .format('MMM do'),
                                    style: GoogleFonts.lato(fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 5,
                      );
                    },
                  ),
                );
              }
            }));
  }
}

////////////////////////
// ));

// }
//  Container(
//   child: Center(

//When no messages are there
// child: Column(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     Container(
//       height: 100,
//       width: 100,
//       decoration: BoxDecoration(
//           image:
//               DecorationImage(image: AssetImage("assets/message.png"))),
//     ),
//     SizedBox(
//       height: 10,
//     ),
//     Text(
//       "No messages yet?",
//       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//     ),
//     SizedBox(
//       height: 15,
//     ),
//     Text(
//       "Find something you like and start a \nconversation!",
//       textAlign: TextAlign.center,
//       style: TextStyle(fontSize: 16),
//     ),
//     SizedBox(
//       height: 20,
//     ),
//     Container(
//       height: 50,
//       width: MediaQuery.of(context).size.width / 1.1,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(4),
//         color: Colors.blueGrey[800],
//       ),
//       child: Center(
//         child: Text(
//           "Explore the latest ads",
//           style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//     )
//   ],
// ),
//   ),
// );
// no messages end...................................
