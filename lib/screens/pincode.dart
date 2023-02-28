// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx/config/auth.dart';
import 'package:olx/config/service.dart';
import 'package:olx/screens/bottom_bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final verificationID;
  final String? phoneNumber;

  PinCodeVerificationScreen({
    Key? key,
    this.phoneNumber,
    this.verificationID,
  }) : super(key: key);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _loading = false;
  bool _loading2 = false;

  Future<void> apiCreateUser() async {
    log("I am running");
    try {
      dynamic data = {
        "fcm": await _fcm.getToken(),
        "status": "1",
        "phoneNumber": widget.phoneNumber,
        "joinDate": DateTime.now().toString()
      };
      // log(data.toString());
      var response = await ApiService().signup(data);
      // log(response.toString());
      var b = response["data"];
      log(b.toString());
      // log(d.toString());
      if (response["status"] == 1) {
        setState(() {
          _loading = false;
          _loading2 = false;
        });
        // print(b["data"]['fcm'][0]);
        bool check = await Auth().setLogin(b);
        log(check.toString());
        if (check) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => BottomBar()),
              (Route<dynamic> route) => false);
          print("Account logined Successfuly");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Something went wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        log("failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 30),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: const Image(image: AssetImage("assets/otp.png"))),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: "${widget.phoneNumber}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      backgroundColor: Colors.white,
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        height: 8,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscuringWidget: Text(
                        "*",
                        style: TextStyle(height: 1.7, fontSize: 22),
                      ),
                      obscureText: true,

                      // obscuringWidget: FlutterLogo(
                      //   size: 24,
                      // ),
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "Please Enter The Code";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        inactiveFillColor: Colors.white,
                        inactiveColor: Colors.grey,
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 50,
                        activeFillColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        debugPrint("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not received the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  _loading2
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              _loading = false;
                              _loading2 = true;
                            });

                            auth.verifyPhoneNumber(
                              phoneNumber: widget.phoneNumber.toString(),
                              verificationCompleted: (_) {},
                              codeAutoRetrievalTimeout: (e) {
                                setState(() {
                                  _loading = false;
                                  _loading2 = false;
                                });
                                Fluttertoast.showToast(
                                    msg: "Timeout",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              },
                              //code sended
                              codeSent: (String verificationId,
                                  int? forceResendingToken) {
                                setState(() {
                                  _loading = false;
                                  _loading2 = false;
                                });
                                log("message");
                                Fluttertoast.showToast(
                                    msg: "OTP Resend",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                // (Route<dynamic> route) => false);
                              },
                              verificationFailed:
                                  (FirebaseAuthException error) {
                                setState(() {
                                  _loading = false;
                                  _loading2 = false;
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
                          },
                          child: Text(
                            "RESEND",
                            style: TextStyle(
                                color: Colors.indigoAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        )
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              _loading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[900],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ButtonTheme(
                        height: 50,
                        child: TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                _loading = true;
                                _loading2 = false;
                              });
                              final credential = PhoneAuthProvider.credential(
                                  verificationId: widget.verificationID,
                                  smsCode: currentText);
                              await FirebaseAuth.instance
                                  .signInWithCredential(credential)
                                  .then((dynamic result) async {
                                if (result == null) {
                                  setState(() {
                                    _loading = false;
                                  });
                                  // print('incorrect Otp');
                                  Fluttertoast.showToast(
                                      msg: "OTP is not correct",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      // timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  apiCreateUser();
                                  // print("successful");
                                }
                              }).catchError((onError) {
                                setState(() {
                                  _loading = false;
                                });
                                // print(onError);
                                print('incorrect Otp');
                                Fluttertoast.showToast(
                                    msg: "OTP is not correct",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              });

                              // conditions for validating
                              if (currentText.length != 6) {
                                setState(() {
                                  _loading = false;
                                });
                                errorController!.add(ErrorAnimationType
                                    .shake); // Triggering error shake animation
                                setState(() => hasError = true);
                              }
                            }
                          },
                          child: Center(
                              child: Text(
                            "VERIFY".toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: TextButton(
                    child: const Text(
                      "Clear",
                      style: TextStyle(color: Colors.indigoAccent),
                    ),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  )),
                  // Flexible(
                  //     child: TextButton(
                  //   child: const Text(
                  //     "Set Text",
                  //     style: TextStyle(color: Colors.indigoAccent),
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       textEditingController.text = "111111";
                  //     });
                  //   },
                  // )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
