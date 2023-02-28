// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:olx/screens/account.dart';
import 'package:olx/screens/category_list.dart';
import 'package:olx/screens/chat/chats.dart';
import 'package:olx/screens/home_screen.dart';
import 'package:olx/screens/my_ads.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

List<Widget> screens = [
  const HomeScreen(),
  const ChatScreen(),
  AllCategorisScreen(
    titleName: "What are you offering?",
    sellOrnot: 1,
    filter: 0,
  ),
  const MyAdsScreen(),
  const AccountScreen(),
];

class _BottomBarState extends State<BottomBar> {
  int myIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[myIndex],
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.white70,
          color: Colors.black,
          activeColor: Colors.black,
          style: TabStyle.react,
          items: const [
            TabItem(
              icon: Icons.home_outlined,
              title: "HOME",
              activeIcon: Icons.home,
            ),
            TabItem(
                icon: Icons.chat_rounded,
                title: "CHATS",
                activeIcon: Icons.chat_bubble_outlined),
            TabItem(
                icon: Icons.add_circle_outline_sharp,
                title: "SELL",
                activeIcon: Icons.add_circle),
            TabItem(
                icon: Icons.favorite_border_outlined,
                title: "MY ADS",
                activeIcon: Icons.favorite),
            TabItem(
                icon: Icons.person_outline,
                title: "ACCOUNT",
                activeIcon: Icons.person_rounded),
          ],
          initialActiveIndex: 0,
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
        ),
      ),
    );
  }
}
