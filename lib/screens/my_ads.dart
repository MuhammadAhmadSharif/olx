import 'package:flutter/material.dart';
import 'package:olx/tabs/favourites.dart';
import 'package:olx/tabs/no_ads.dart';
import 'package:olx/screens/chat/no_message.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            bottom: TabBar(
              indicatorColor: Colors.blueGrey[800],
              tabs: [
                Tab(
                  child: Text(
                    "ADS",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    "FAVOURITES",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            // TabBar
            title: const Text(
              'My Ads',
              style: TextStyle(color: Colors.black, fontSize: 22),
            ),
            backgroundColor: Colors.white,
          ), // AppBar
          body: const TabBarView(
            children: [
              NoAdsScreen(),
              FavouritesScreen(),
            ],
          ), // TabBarView
        ), // Scaffold
      ),
    );
  }
}
