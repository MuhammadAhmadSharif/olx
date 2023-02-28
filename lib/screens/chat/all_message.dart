import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:olx/screens/account.dart';
import '../../config/auth.dart';
import '../../config/service.dart';

class AllMessagesScreen extends StatefulWidget {
  dynamic data;

  AllMessagesScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<AllMessagesScreen> createState() => _AllMessagesScreenState();
}

class _AllMessagesScreenState extends State<AllMessagesScreen> {
  var image;
  File? img;
  var name;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    log(widget.data.toString());
    Future.delayed(Duration(milliseconds: 500), () {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 300,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeOut);
    });
    getUser();
    // log(widget.data.toString());
    // TODO: implement initState
    super.initState();
  }

  // Future pickImage(ImageSource source) async {
  //   try {
  //     image = await ImagePicker().pickImage(source: source);
  //     if (image == null) return;
  //     img = File(image.path);
  //     setState(() {});
  //     name = image.name;
  //     var data = {'image': img, 'name': name};
  //     log("main b run hoo raha hoo");
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  var user;
  String id = "";
  Future<void> getUser() async {
    user = await Auth().getUser();
    id = user["_id"];
    log(id.toString());
    setState(() {});
    updateFieldInAllDocuments(user["_id"], true);
  }

  var messageEditingController = TextEditingController();
  void updateLastMesg() async {
    dynamic body = {
      "_id": widget.data["_id"],
      "lastMessage": messageEditingController.text,
      "userId": widget.data["userId"],
      "status": '1',
      "lastMessagedate": DateTime.now().toString(),
      "userId": user["_id"],
      "adId": widget.data["adId"]["_id"],
    };
    // log(body.toString());
    var response = await ApiService().updateMessages(body);
    // log(response.toString());
  }

  // Future<void> uplodad() async {
  //   // Get a reference to the Firebase Storage:
  //   //Create a reference to the location where you want to upload the image:
  //   Reference ref = FirebaseStorage.instance.ref("'uploads/$name'");
  //   //Upload the image using the putFile() method:
  //   UploadTask uploadTask = ref.putFile(File(image.path));
  //   //Monitor the status of the upload
  //   uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
  //     switch (taskSnapshot.state) {
  //       case TaskState.running:
  //         final progress =
  //             100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
  //         log("Upload is $progress% complete.");

  //         break;
  //       case TaskState.paused:
  //         log("Upload is paused.");
  //         break;
  //       case TaskState.canceled:
  //         log("Upload was canceled");
  //         break;
  //       case TaskState.success:
  //         // TODO: Handle this case.
  //         break;
  //       case TaskState.error:
  //         // TODO: Handle this case.
  //         break;
  //     }
  //   });
  //   log("""""" """""" """""" """""'message'""" """""" """""" """""" "");
  //   String url = (await ref.getDownloadURL()).toString();
  //   if (url != null) {
  //     log(url.toString());
  //   }
  // }
  void updateFieldInAllDocuments(String fieldName, dynamic fieldValue) async {
    final CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("${widget.data["adId"]["_id"]}" +
            "_" +
            widget.data["ownerId"] +
            "_" +
            widget.data["userId"]["_id"]);
    final QuerySnapshot querySnapshot = await collectionReference.get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({
        fieldName: fieldValue,
      });
    }
    // final List<DocumentSnapshot> documents = querySnapshot.docs;
    // final WriteBatch batch = FirebaseFirestore.instance.batch();
    // for (DocumentSnapshot document in documents) {
    //   log("message");
    //   batch.update(document.reference, {fieldName: fieldValue});
    // }
    // await batch.commit();
  }

  void addFirestore() async {
    log("${widget.data["adId"]["userId"]}");
    log("main run howa hoo".toString());
    final firestore = await FirebaseFirestore.instance
        .collection("${widget.data["adId"]["_id"]}" +
            "_" +
            widget.data["ownerId"] +
            "_" +
            widget.data["userId"]["_id"])
        .add({
      "ownerId": widget.data["adId"]["userId"],
      "${widget.data["ownerId"]}": false,
      "${user["_id"]}": true,
      "message": messageEditingController.text,
      // "sender_owner_id": [user["_id"], widget.data["adId"]["userId"]],
      "sender_id": user["_id"],
      "created_At": DateTime
          .now(), //your data which will be added to the collection and collection will be created after this
    }).then((_) {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 300,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut);
      updateFieldInAllDocuments(user["_id"], true);
      log("collection created".toString());
      messageEditingController.clear();
      // setState(() {});
    }).catchError((_) {
      log("an error occured".toString());
    });
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
          centerTitle: true,
          title: Text(
            widget.data["userId"]["name"],
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("${widget.data["adId"]["_id"]}" +
                      "_" +
                      widget.data["ownerId"] +
                      "_" +
                      widget.data["userId"]["_id"])
                  .orderBy('created_At', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text("SnapShot is Empty"));
                }
                if (snapshot.hasError) {
                  return const Text(
                    "Some Error",
                  );
                } else {
                  // log(snapshot.data!.docs[0].toString());
                  return Padding(
                    padding: const EdgeInsets.all(14),
                    child: Container(
                      // decoration: BoxDecoration(border: Border.all()),
                      height: MediaQuery.of(context).size.height,
                      child: Column(children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              // decoration: BoxDecoration(border: Border.all()),
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  bool isMe = user["_id"] ==
                                      snapshot.data?.docs[index]["sender_id"];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: isMe
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: isMe
                                              ? EdgeInsets.only(left: 50)
                                              : EdgeInsets.only(right: 50),
                                          child: Material(
                                            borderRadius: isMe
                                                ? const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30.0),
                                                    bottomLeft:
                                                        Radius.circular(30.0),
                                                    bottomRight:
                                                        Radius.circular(30.0),
                                                  )
                                                : const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(30.0),
                                                    bottomLeft:
                                                        Radius.circular(30.0),
                                                    bottomRight:
                                                        Radius.circular(30.0),
                                                  ),
                                            elevation: 5.0,
                                            color: isMe
                                                ? Colors.lightBlueAccent
                                                : Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                              child: Text(
                                                snapshot.data?.docs[index]
                                                    ["message"],
                                                style: TextStyle(
                                                  color: isMe
                                                      ? Colors.white
                                                      : Colors.black54,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        //bottom write message area and send button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.photo_camera),
                              onPressed: () {
                                // pickImage(ImageSource.gallery);
                                // uplodad();
                              },
                            ),
                            Flexible(
                                child: TextField(
                              maxLines: 10,
                              minLines: 1,
                              //  focusNode: focusNode,
                              textInputAction: TextInputAction.send,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              controller: messageEditingController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  // vertical: 22,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    borderSide:
                                        BorderSide(color: HexColor("#FFD700"))),
                                fillColor: Colors.white,
                                hintText: "Write here........",
                                hintStyle: TextStyle(fontSize: 16),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: HexColor("#EBEBEB")),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                            )),
                            Container(
                              margin: const EdgeInsets.only(right: 8, left: 4),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  addFirestore();
                                  updateLastMesg();
                                },
                                icon: const Icon(Icons.send_rounded),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
                  );
                }
              }),
        ));
  }
}
