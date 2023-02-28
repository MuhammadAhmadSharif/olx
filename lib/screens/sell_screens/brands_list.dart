import 'package:flutter/material.dart';

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({super.key});

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  List brandsName = [
    "Google",
    "Apple",
    "Samsung",
    "Huawei",
    "OnePlus",
    "Motorola",
    "LG",
    "Sony",
    "Nokia",
    "HTC",
    "Oppo",
    "Vivo",
    "Xiaomi",
    "Lenovo",
    "Asus",
    "ZTE",
    "Meizu",
    "Micromax",
    "Gionee",
    "Lava",
    "Intex",
    "Karbonn",
    "Celkon",
    "LeEco",
    "Panasonic",
    "BL"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            Icons.close,
          ),
          onPressed: () {
            Navigator.pop(context, "None");
          },
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: Text(
          "Choose Brand",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: ListView(
          // physics: ScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.center,
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    // hintText: "What are you looking for?",
                    hintStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            ListView.separated(
                padding: EdgeInsets.only(top: 16),
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, brandsName[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        brandsName[index],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: Colors.grey.shade200,
                        height: 20,
                        thickness: 2,
                      ),
                    ],
                  );
                },
                itemCount: brandsName.length),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.grey.shade200,
              height: 20,
              thickness: 2,
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height / 1.39,
            // ),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.pop(context, "None");
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.blueGrey[900],
              borderRadius: BorderRadius.circular(4)),
          child: Center(
            child: Text(
              "Confirm",
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
