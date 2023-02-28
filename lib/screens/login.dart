import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:olx/screens/pincode.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

FirebaseAuth auth = FirebaseAuth.instance;
final _formKey = GlobalKey<FormState>();
bool _loading = false;

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    _loading = false;
    // TODO: implement initState
    super.initState();
  }

  var ph;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   leading: Icon(
        //     Icons.arrow_back_ios_new,
        //     size: 20,
        //     color: Colors.black,
        //   ),
        //   backgroundColor: Colors.blue[50],
        //   elevation: 0,
        //   title: Text(
        //     "Login",
        //     style: TextStyle(
        //         color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        //   ),
        // ),
        body: Column(
          children: [
            ClipPath(
                clipper: SinCosineWaveClipper(),
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.blueGrey[900],
                  child: const Padding(
                    padding: EdgeInsets.only(top: 50, left: 18),
                    child: Text(
                      "Welcome\nBack!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                      ),
                    ),
                  ),
                )),

            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    // CircleAvatar(
                    //   radius: 34,
                    //   backgroundColor: Colors.amber,
                    //   child: Image(image: AssetImage("assets/person.png")),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Enter your phone",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "We will send a confirmation code to your phone.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: IntlPhoneField(
                        style: TextStyle(fontSize: 14, height: 1.5),
                        // initialCountryCode: "+92",
                        flagsButtonMargin: EdgeInsets.only(left: 16),
                        showDropdownIcon: false,
                        // pickerDialogStyle: PickerDialogStyle(
                        //     countryCodeStyle: TextStyle(
                        //         fontSize: 36, fontWeight: FontWeight.bold)),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(),
                          ),
                        ),
                        onChanged: (phone) {
                          ph = phone.completeNumber;
                          log(ph.toString());
                        },
                        onCountryChanged: (country) {
                          print('Country changed to: ' + country.name);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // _loading
            //     ? Container(
            //         margin: EdgeInsets.symmetric(vertical: 16),
            //         // padding:,

            //         width: MediaQuery.of(context).size.width,
            //         height: 80,
            //         child: WaveWidget(
            //           config: CustomConfig(
            //             colors: [
            //               Colors.indigo[400]!,
            //               Colors.indigo[300]!,
            //               Colors.indigo[200]!,
            //               Colors.indigo[100]!
            //             ],
            //             durations: [18000, 8000, 5000, 12000],
            //             heightPercentages: [0.65, 0.66, 0.68, 0.70],
            //           ),
            //           size: Size(double.infinity, double.infinity),
            //           waveAmplitude: 0,
            //         ),
            //       )
            //     : Container(
            //         margin: EdgeInsets.symmetric(vertical: 16),
            //         // padding:,
            //         color: Colors.blueGrey[900],
            //         width: MediaQuery.of(context).size.width,
            //         height: 50,
            //         child: OutlinedButton(
            //             onPressed: () {
            //               if (_formKey.currentState!.validate()) {
            //                 setState(() {
            //                   _loading = true;
            //                 });
            //                 auth.verifyPhoneNumber(
            //                   phoneNumber: ph.toString(),
            //                   verificationCompleted: (_) {},
            //                   codeAutoRetrievalTimeout: (e) {
            //                     Fluttertoast.showToast(
            //                         msg: "TimeOut",
            //                         toastLength: Toast.LENGTH_SHORT,
            //                         gravity: ToastGravity.BOTTOM,
            //                         textColor: Colors.white,
            //                         fontSize: 16.0);
            //                   },
            //                   //code sended
            //                   codeSent: (String verificationId,
            //                       int? forceResendingToken) {
            //                     Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                           builder: (BuildContext context) =>
            //                               PinCodeVerificationScreen(
            //                             verificationID: verificationId,
            //                             phoneNumber: ph.toString(),
            //                           ),
            //                         )).then(
            //                       (value) {
            //                         _loading = false;
            //                       },
            //                     );

            //                     // (Route<dynamic> route) => false);
            //                   },
            //                   verificationFailed:
            //                       (FirebaseAuthException error) {
            //                     Fluttertoast.showToast(
            //                         msg: error.toString(),
            //                         toastLength: Toast.LENGTH_SHORT,
            //                         gravity: ToastGravity.BOTTOM,
            //                         textColor: Colors.white,
            //                         fontSize: 16.0);
            //                   },
            //                 );
            //               }
            //               setState(() {
            //                 _loading == false;
            //               });
            //             },
            //             child: Text(
            //               "Next",
            //               style: TextStyle(color: Colors.white, fontSize: 18),
            //             )),
            //       ),

            _loading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      // padding:,
                      color: Colors.blueGrey[900],
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: OutlinedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              auth.verifyPhoneNumber(
                                phoneNumber: ph.toString(),
                                verificationCompleted: (_) {},
                                codeAutoRetrievalTimeout: (e) {
                                  setState(() {
                                    _loading = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: "TimeOut",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                },
                                //code sended
                                codeSent: (String verificationId,
                                    int? forceResendingToken) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            PinCodeVerificationScreen(
                                          verificationID: verificationId,
                                          phoneNumber: ph.toString(),
                                        ),
                                      )).then(
                                    (value) {
                                      _loading = false;
                                    },
                                  );
                                  // (Route<dynamic> route) => false);
                                },
                                verificationFailed:
                                    (FirebaseAuthException error) {
                                  setState(() {
                                    _loading = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg:
                                          "Something Went Wrong, Please Try Again",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                },
                              );
                            }
                            setState(() {
                              _loading == false;
                            });
                          },
                          child: Text(
                            "Next",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
