import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:helpayr/constants/Theme.dart';

//widgets
import 'package:helpayr/widgets/navbar.dart';
import 'package:helpayr/widgets/table-cell.dart';

import 'package:helpayr/widgets/drawer.dart';

class Settings_Home extends StatefulWidget {
  @override
  const Settings_Home({key, this.isHome = false});
  final bool isHome;
  _Settings_HomeState createState() => _Settings_HomeState();
}

class _Settings_HomeState extends State<Settings_Home> {
  final user = FirebaseAuth.instance.currentUser;
  bool switchValueOne;
  bool switchValueTwo;

  void initState() {
    setState(() {
      switchValueOne = true;
      switchValueTwo = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isHome
        ? Scaffold(
            appBar: Navbar(
              url: user.photoURL,
              title: "Settings",
            ),
            drawer: NowDrawer(currentPage: "Settings"),
            body: Container(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 32.0, left: 16, right: 16),
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("Recommended Settings",
                              style: TextStyle(
                                  color: HelpayrColors.text,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18)),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("These are the most important settings",
                              style: TextStyle(
                                  color: HelpayrColors.time, fontSize: 14)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Use FaceID to signin",
                              style: TextStyle(color: HelpayrColors.text)),
                          Switch.adaptive(
                            value: switchValueOne,
                            onChanged: (bool newValue) =>
                                setState(() => switchValueOne = newValue),
                            activeColor: HelpayrColors.info,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Auto-Lock security",
                              style: TextStyle(color: HelpayrColors.text)),
                          Switch.adaptive(
                            value: switchValueTwo,
                            onChanged: (bool newValue) =>
                                setState(() => switchValueTwo = newValue),
                            activeColor: HelpayrColors.info,
                          )
                        ],
                      ),
                      TableCellSettings(
                          title: "Notifications",
                          onTap: () {
                            Navigator.pushNamed(context, '/pro');
                          }),
                      SizedBox(height: 36.0),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text("Payment Settings",
                              style: TextStyle(
                                  color: HelpayrColors.text,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18)),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("These are also important settings",
                              style: TextStyle(color: HelpayrColors.time)),
                        ),
                      ),
                      TableCellSettings(title: "Manage Payment Options"),
                      TableCellSettings(title: "Manage Gift Cards"),
                      SizedBox(
                        height: 36.0,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text("Privacy Settings",
                              style: TextStyle(
                                  color: HelpayrColors.text,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18)),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("Third most important settings",
                              style: TextStyle(color: HelpayrColors.time)),
                        ),
                      ),
                      TableCellSettings(
                          title: "User Agreement",
                          onTap: () {
                            Navigator.pushNamed(context, '/pro');
                          }),
                      TableCellSettings(
                          title: "Privacy",
                          onTap: () {
                            Navigator.pushNamed(context, '/pro');
                          }),
                      TableCellSettings(
                          title: "About",
                          onTap: () {
                            Navigator.pushNamed(context, '/pro');
                          }),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Recommended Settings",
                            style: TextStyle(
                                color: HelpayrColors.text,
                                fontWeight: FontWeight.w600,
                                fontSize: 18)),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("These are the most important settings",
                            style: TextStyle(
                                color: HelpayrColors.time, fontSize: 14)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Use FaceID to signin",
                            style: TextStyle(color: HelpayrColors.text)),
                        Switch.adaptive(
                          value: switchValueOne,
                          onChanged: (bool newValue) =>
                              setState(() => switchValueOne = newValue),
                          activeColor: HelpayrColors.info,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Auto-Lock security",
                            style: TextStyle(color: HelpayrColors.text)),
                        Switch.adaptive(
                          value: switchValueTwo,
                          onChanged: (bool newValue) =>
                              setState(() => switchValueTwo = newValue),
                          activeColor: HelpayrColors.info,
                        )
                      ],
                    ),
                    TableCellSettings(
                        title: "Notifications",
                        onTap: () {
                          Navigator.pushNamed(context, '/pro');
                        }),
                    SizedBox(height: 36.0),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text("Payment Settings",
                            style: TextStyle(
                                color: HelpayrColors.text,
                                fontWeight: FontWeight.w600,
                                fontSize: 18)),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("These are also important settings",
                            style: TextStyle(color: HelpayrColors.time)),
                      ),
                    ),
                    TableCellSettings(title: "Manage Payment Options"),
                    TableCellSettings(title: "Manage Gift Cards"),
                    SizedBox(
                      height: 36.0,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text("Privacy Settings",
                            style: TextStyle(
                                color: HelpayrColors.text,
                                fontWeight: FontWeight.w600,
                                fontSize: 18)),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Third most important settings",
                            style: TextStyle(color: HelpayrColors.time)),
                      ),
                    ),
                    TableCellSettings(
                        title: "User Agreement",
                        onTap: () {
                          Navigator.pushNamed(context, '/pro');
                        }),
                    TableCellSettings(
                        title: "Privacy",
                        onTap: () {
                          Navigator.pushNamed(context, '/pro');
                        }),
                    TableCellSettings(
                        title: "About",
                        onTap: () {
                          Navigator.pushNamed(context, '/pro');
                        }),
                  ],
                ),
              ),
            ),
          );
  }
}
