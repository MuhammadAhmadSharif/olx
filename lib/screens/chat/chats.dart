import 'package:flutter/material.dart';
import 'package:olx/screens/chat/buy_messages.dart';
import 'package:olx/screens/chat/selling_messages.dart';
import 'package:olx/screens/chat/no_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            bottom: TabBar(
              indicatorColor: Colors.blueGrey[800],
              tabs: [
                Tab(
                  child: Text(
                    "All",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    "BUYING",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    "SELLING",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            // TabBar
            title: const Text(
              'Chats',
              style: TextStyle(color: Colors.black, fontSize: 22),
            ),
            backgroundColor: Colors.white,
          ), // AppBar
          body: const TabBarView(
            children: [
              NoMessageScreen(),
              BuyMessageScreen(),
              SellingMessageScreen(),
            ],
          ), // TabBarView
        ), // Scaffold
      ),
    );
  }
}
