import 'package:flutter/material.dart';
import 'package:helpayr/screens/when_complete.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:helpayr/constants/Theme.dart';

import 'package:helpayr/widgets/drawer-tile.dart';

class NowDrawer extends StatelessWidget {
  final String currentPage;
  final bool isHelper;

  NowDrawer({this.currentPage, this.isHelper = false});

  _launchURL() async {
    const url = 'pornhub.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: HelpayrColors.info,
      child: Column(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.85,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 20.0, top: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Image.asset(
                      "assets/helpayr logo3.png",
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: HelpayrColors.white.withOpacity(0.82),
                              size: 24.0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                  ],
                ),
              ),
            )),
        Expanded(
          flex: 2,
          child: isHelper
              ? ListView(
                  padding: EdgeInsets.only(top: 36, left: 8, right: 16),
                  children: [
                    DrawerTile(
                        icon: FontAwesomeIcons.home,
                        onTap: () {
                          if (currentPage != "Home")
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WhenCompleted(),
                              ),
                            );
                        },
                        iconColor: HelpayrColors.info,
                        title: "Home",
                        isSelected: currentPage == "Home" ? true : false),
                    DrawerTile(
                        icon: Icons.message,
                        onTap: () {
                          if (currentPage != "Messaging")
                            Navigator.pushReplacementNamed(
                                context, '/messaging');
                        },
                        iconColor: HelpayrColors.info,
                        title: "Messaging",
                        isSelected: currentPage == "Messaging" ? true : false),
                  ],
                )
              : ListView(
                  padding: EdgeInsets.only(top: 36, left: 8, right: 16),
                  children: [
                    DrawerTile(
                        icon: FontAwesomeIcons.home,
                        onTap: () {
                          if (currentPage != "Home")
                            Navigator.pushReplacementNamed(context, '/home');
                        },
                        iconColor: HelpayrColors.info,
                        title: "Home",
                        isSelected: currentPage == "Home" ? true : false),
                    DrawerTile(
                        icon: FontAwesomeIcons.store,
                        onTap: () {
                          if (currentPage != "Bookings")
                            Navigator.pushReplacementNamed(
                                context, '/user_app');
                        },
                        iconColor: HelpayrColors.info,
                        title: "Bookings",
                        isSelected: currentPage == "Bookings" ? true : false),
                    DrawerTile(
                        icon: FontAwesomeIcons.clock,
                        onTap: () {
                          if (currentPage != "History")
                            Navigator.pushReplacementNamed(context, '/history');
                        },
                        iconColor: HelpayrColors.info,
                        title: "History",
                        isSelected: currentPage == "History" ? true : false),
                    DrawerTile(
                        icon: Icons.message,
                        onTap: () {
                          if (currentPage != "Messaging")
                            Navigator.pushReplacementNamed(
                                context, '/messaging');
                        },
                        iconColor: HelpayrColors.info,
                        title: "Messaging",
                        isSelected: currentPage == "Messaging" ? true : false),
                    DrawerTile(
                        icon: FontAwesomeIcons.questionCircle,
                        onTap: () {
                          if (currentPage != "About Us")
                            Navigator.pushReplacementNamed(context, '/about');
                        },
                        iconColor: HelpayrColors.info,
                        title: "About Us",
                        isSelected: currentPage == "About Us" ? true : false),
                    DrawerTile(
                        icon: FontAwesomeIcons.shieldAlt,
                        onTap: () {
                          if (currentPage != "Privacy Policy")
                            Navigator.pushReplacementNamed(context, '/privacy');
                        },
                        iconColor: HelpayrColors.info,
                        title: "Privacy Policy",
                        isSelected:
                            currentPage == "Privacy Policy" ? true : false),
                  ],
                ),
        ),
        Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.only(left: 8, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                      height: 4,
                      thickness: 0,
                      color: HelpayrColors.white.withOpacity(0.8)),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 16, bottom: 8),
                    child: Text("DOCUMENTATION",
                        style: TextStyle(
                          color: HelpayrColors.white.withOpacity(0.8),
                          fontSize: 13,
                        )),
                  ),
                  DrawerTile(
                      icon: FontAwesomeIcons.satellite,
                      onTap: _launchURL,
                      iconColor: HelpayrColors.muted,
                      title: "Getting Started",
                      isSelected:
                          currentPage == "Getting started" ? true : false),
                ],
              )),
        ),
      ]),
    ));
  }
}
