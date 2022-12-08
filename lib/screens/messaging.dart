import 'package:circle_bottom_navigation_bar/circle_bottom_navigation_bar.dart';
import 'package:circle_bottom_navigation_bar/widgets/tab_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpayr/Message/pages/messages_page.dart';
import 'package:helpayr/Message/widgets/widget.dart';
import 'package:helpayr/screens/profile.dart';
import 'package:helpayr/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Message/pages/contacts.dart';

class Messaging extends StatefulWidget {
  @override
  State<Messaging> createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final user = FirebaseAuth.instance.currentUser;
  int currentPage = 0;
  List<Widget> pages = [
    MessagePage(),
    Contacts(),
  ];
  List<String> appBarTitle = [
    "Message",
    "Contacts",
  ];
  bool colorSelect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Center(
          child: IconBackground(
            onTap: () {},
            icon: Icons.search,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: CircleAvatar(
                radius: 17,
                backgroundImage: NetworkImage(user.photoURL),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          appBarTitle[currentPage],
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      drawer: NowDrawer(
        currentPage: "Messaging",
      ),
      body: pages[currentPage],
      bottomNavigationBar: CircleBottomNavigationBar(
        activeIconColor: Colors.white,
        initialSelection: currentPage,
        circleColor: Colors.blue,
        inactiveIconColor: Colors.black,
        itemIconOff: -1.5,
        circleSize: 35,
        arcHeight: 60,
        textYAxisSpace: 5,
        arcWidth: 70,
        barHeight: 75,
        tabs: [
          TabData(
            icon: Icons.message,
            iconSize: 20,
            title: "Message",
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          TabData(
            icon: FontAwesomeIcons.personBooth,
            iconSize: 20,
            title: "Contacts",
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ],
        onTabChangedListener: (index) => setState(() => currentPage = index),
      ),
    );
  }
}
