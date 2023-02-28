import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: Text(
          "Change Password",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#EBEBEB")),
                  borderRadius: BorderRadius.circular(4),
                ),
                suffixIcon: Icon(Icons.remove_red_eye_outlined),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.tealAccent)),
                hintText: "Current Password",

                hintStyle: TextStyle(fontSize: 16),
                // labelText: "Email",
              ),
            ),
            SizedBox(
              height: 25,
            ),
            TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#EBEBEB")),
                  borderRadius: BorderRadius.circular(4),
                ),
                suffixIcon: Icon(Icons.remove_red_eye_outlined),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.tealAccent)),
                hintText: "New Password",

                hintStyle: TextStyle(fontSize: 16),
                // labelText: "Email",
              ),
            ),
            SizedBox(
              height: 25,
            ),
            TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(4),
                ),
                suffixIcon: Icon(Icons.remove_red_eye_outlined),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.tealAccent)),
                hintText: "Confirm new Password",

                hintStyle: TextStyle(fontSize: 16),
                // labelText: "Email",
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(4)),
              child: Center(
                child: Text(
                  "Change password",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
