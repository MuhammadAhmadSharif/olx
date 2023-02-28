import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../config/auth.dart';
import '../config/config.dart';
import '../config/service.dart';

class userProfileScreen extends StatefulWidget {
  const userProfileScreen({super.key});

  @override
  State<userProfileScreen> createState() => _userProfileScreenState();
}

class _userProfileScreenState extends State<userProfileScreen> {
  List<String> items = ["Male", "Female", "Prefer not to say"];
  String? dropdownvalue = "Male";
  var ph;
  File? img;
  var image;
  var user;
  var imageName = "";

  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var aboutYouController = TextEditingController();
  var dobController = TextEditingController();
  var emailController = TextEditingController();
  bool _loading = true;
  bool _loading2 = false;

  Future<void> getUser() async {
    user = await Auth().getUser();
    log(user.toString());
    setState(() {
      _loading = false;
    });
  }

  apiCalled() async {
    setState(() {
      _loading2 = true;
    });
    // log("""""" """""" "message" """""" """""");
    var body = {
      "_id": user["_id"],
      "name": nameController.text,
      "image": imageName,
      "about": aboutYouController.text,
      "gender": dropdownvalue,
      "dob": dobController.text,
      "email": emailController.text,
    };
    print(body);

    var response = await ApiService().updateUser(body);
    log(response.toString());
    if (response["status"] == 1) {
      var d = response["data"];
      log(d.toString());
      var check = await Auth().setUser(d);
      if (check) {
        setState(() {
          _loading2 = false;
        });
        Fluttertoast.showToast(
            msg: "User Info has been Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
      }
    }
  }

  Future pickImage(ImageSource source) async {
    try {
      image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      img = File(image.path);
      setState(() {});
      var base64 = base64Encode(img!.readAsBytesSync());
      var name = image.name;
      var data = {'image': base64, 'name': name};
      //  final imagePermanent = await saveImagePermanently(image.path);
      setState(() => this.image = img);
      // log(data.toString());

      // log("main b run hoo raha hoo");
      // dynamic da = {'_id': user["_id"], "image": name};
      // var response = await ApiService().userImage(da);

      await ApiService().fileUpload(data).then((value) {
        if (value['status'] == 1) imageName = value['address'];

        log('$value  its a value =-=-=-=-=-=-');
        log(imageName.toString());
        print(imageName.toString());
        setState(() {});
        // initState();
      });
    } on PlatformException catch (e) {
      print("Faild to pick image $e");
    }
  }

  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

//
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                  onPressed: _loading2
                      ? () {}
                      : () {
                          if (nameController.text.isNotEmpty &&
                              aboutYouController.text.isNotEmpty &&
                              dobController.text.isNotEmpty &&
                              emailController.text.isNotEmpty) {
                            apiCalled();
                          } else {
                            Fluttertoast.showToast(
                                msg: "Kindly fill all the fields",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                          // print("ahhhhhhhhhhhhhhhhhhhhhhhhhh");
                          // if (_formKey.currentState!.validate()) {
                          //   print("kkkkkkkkkk");

                          // }
                        },
                  child: _loading2
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          "Save",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        )),
            )
          ],
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return false;
            },
            child: _loading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                "Basic information",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  pickImage(ImageSource.gallery);
                                  setState(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      image:
                                          // user["image"] == null ||
                                          imageName == "" && user["image"] == ""
                                              ? DecorationImage(
                                                  image: AssetImage(
                                                      "assets/logo.png"),
                                                  fit: BoxFit.contain)
                                              : imageName == ""
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                          Configuration.url +
                                                              "/uploads/" +
                                                              user["image"]),
                                                      fit: BoxFit.contain)
                                                  : DecorationImage(
                                                      image: NetworkImage(
                                                          Configuration.url +
                                                              "/uploads/" +
                                                              imageName),
                                                      fit: BoxFit.contain),
                                      shape: BoxShape.circle,
                                      border: Border.all()),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              //name row
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Enter your name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    // decoration: BoxDecoration(border: Border.all()),
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width / 1.4,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Your Name";
                                        }
                                        return null;
                                      },
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 28,
                                          vertical: 16,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        // suffixIcon: Icon(Icons.remove_red_eye_outlined),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                                color: Colors.tealAccent)),
                                        // hintText: "Current Password",

                                        hintStyle: TextStyle(fontSize: 16),
                                        // labelText: "Email",
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              //
                            ],
                          ),
                          //something about you
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Something about you",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                // decoration: BoxDecoration(border: Border.all()),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                  controller: aboutYouController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter Somthing about you";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    // suffixIcon: Icon(Icons.remove_red_eye_outlined),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: BorderSide(
                                            color: Colors.tealAccent)),
                                    // hintText: "Current Password",

                                    hintStyle: TextStyle(fontSize: 16),
                                    // labelText: "Email",
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //gender
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Gender",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(4)),
                                  // decoration: BoxDecoration(border: Border.all()),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          isExpanded: true,
                                          elevation: 0,
                                          // Initial Value
                                          value: dropdownvalue,
                                          // Down Arrow Icon
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          // Array list of items
                                          items: items.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),

                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownvalue = newValue!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              //DOB
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date of birth",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                // decoration: BoxDecoration(border: Border.all()),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter Your DOB";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: dobController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    // suffixIcon: Icon(Icons.remove_red_eye_outlined),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: BorderSide(
                                            color: Colors.tealAccent)),
                                    hintText: "DD-MM-YYYY",

                                    hintStyle: TextStyle(fontSize: 16),
                                    // labelText: "Email",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Divider(
                                color: Colors.grey.shade200,
                                height: 20,
                                thickness: 2,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Contact information",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Phone Number",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 65,
                                width: MediaQuery.of(context).size.width,
                                child: IntlPhoneField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(),
                                    ),
                                  ),
                                  onChanged: (phone) {
                                    ph = phone.completeNumber;
                                    log(ph.toString());
                                  },
                                  onCountryChanged: (country) {
                                    print(
                                        'Country changed to: ' + country.name);
                                  },
                                ),
                              ),

                              Text(
                                "This is the number for buyers contacts, reminders, and other notifications.",
                                // overflow: TextOverflow.ellipsis,
                                // maxLines: 3,
                                // style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              //Eamil
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                // decoration: BoxDecoration(border: Border.all()),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter Your Email";
                                    }
                                    return null;
                                  },
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    // suffixIcon: Icon(Icons.remove_red_eye_outlined),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: BorderSide(
                                            color: Colors.tealAccent)),
                                    hintText: "Enter your email",

                                    hintStyle: TextStyle(fontSize: 16),
                                    // labelText: "Email",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "This email will be useful to keep in touch. We wont't share your private email adress with other OLX users.",
                                // overflow: TextOverflow.ellipsis,
                                // maxLines: 3,
                                // style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Divider(
                                color: Colors.grey.shade200,
                                height: 20,
                                thickness: 2,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Optional Information",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Facebook",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(4)),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: Text(
                                  "Connect",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19),
                                )),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Sign in with Facebook and discover your trusted connections to buyers.",
                                // overflow: TextOverflow.ellipsis,
                                // maxLines: 3,
                                // style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              //google
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Google",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(4)),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: Text(
                                  "Connect",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19),
                                )),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Connect your OLX account your Google account for simplicity and ease.",
                                // overflow: TextOverflow.ellipsis,
                                // maxLines: 3,
                                // style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )));
  }
}
