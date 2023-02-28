import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiffy/jiffy.dart';
import 'package:olx/screens/category_grid.dart';

import '../config/auth.dart';
import '../config/config.dart';
import '../config/service.dart';
import '../screens/chat/all_message.dart';

class NoMessageScreen extends StatefulWidget {
  const NoMessageScreen({super.key});

  @override
  State<NoMessageScreen> createState() => _NoMessageScreenState();
}

class _NoMessageScreenState extends State<NoMessageScreen> {
  var user;
  var userdata;

  List data = [];
  Future<void> getUser() async {
    user = await Auth().getUser();
    // log(user.toString());
    userdata = {"id": user["_id"]};
    var response = await ApiService().findallConv(userdata);
    // log(response.toString());
    data = response["data"];
    setState(() {});
    log(data.toString());
  }

  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: ListView(children: [
        FutureBuilder(
            future: ApiService().findallConv(userdata),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else if (data == []) {
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/message.png"))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "No messages yet?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
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
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height / 1.29,
                  // decoration: BoxDecoration(border: Border.all()),
                  child: ListView.separated(
                    itemCount: data.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: 0,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllMessagesScreen(
                                  data: data[index],
                                ),
                              ));
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
                                            FittedBox(
                                              child: Text(
                                                data[index]["userId"]["name"],
                                                // data[index]["pName"],
                                                style: GoogleFonts.lato(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(data[index]["adId"]["title"],
                                                // "${data[index]["lastMessage"]}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: GoogleFonts.lato(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                                        onTap: () {},
                                                        child: InkWell(
                                                          onTap: () {},
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Delete Chat",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ],
                                                          ),
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
            })
      ]),
    );
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
