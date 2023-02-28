import 'package:flutter/material.dart';
import 'package:olx/screens/buy_packages.dart';
import 'package:olx/screens/settings.dart';
import 'package:olx/screens/userProfile.dart';

import '../config/auth.dart';
import '../config/config.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

dynamic user;
var data;
bool _loading = true;

// List userAds = [];

class _AccountScreenState extends State<AccountScreen> {
  Future<void> getUser() async {
    user = await Auth().getUser();
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              _loading
                  ? Center(child: CircularProgressIndicator())
                  : Row(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            image: user["image"] == null || user["image"] == ""
                                ? DecorationImage(
                                    image: AssetImage("assets/logo.png"),
                                    fit: BoxFit.contain)
                                : DecorationImage(
                                    image: NetworkImage(Configuration.url +
                                        "/uploads/" +
                                        user["image"]),
                                    fit: BoxFit.fill),
                            shape: BoxShape.circle,
                            // border: Border.all()
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user["name"] == "" || user["name"] == null
                                  ? "OLX User"
                                  : user["name"],
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => userProfileScreen(),
                                    ));
                              },
                              child: Text(
                                "View and edit profile",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BuyPackagesScreen(),
                      ));
                },
                //1st row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.smart_screen,
                      size: 26,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Buy Packages & My Orders",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Packages, orders, billing and invoices",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                color: Colors.grey.shade200,
                height: 20,
                thickness: 2,
              ),
              //2nd row
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingScreen(),
                      ));
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.settings,
                      size: 26,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Settings",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Privacy and manage account",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                color: Colors.grey.shade200,
                height: 20,
                thickness: 2,
              ),

              //3rd row
              Row(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/logo.png"))),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Help & Support",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Help center and legal terms",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                  )
                ],
              ),
              const SizedBox(
                height: 5,
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
    );
  }
}
