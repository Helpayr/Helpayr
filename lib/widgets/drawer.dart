import 'package:flutter/material.dart';
import 'package:helpayr/screens/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:helpayr/constants/Theme.dart';

import 'package:helpayr/widgets/drawer-tile.dart';

class NowDrawer extends StatelessWidget {
  final String currentPage;

  NowDrawer({this.currentPage});

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
          child: ListView(
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
                    if (currentPage != "Stores")
                      Navigator.pushReplacementNamed(context, '/stores');
                  },
                  iconColor: HelpayrColors.info,
                  title: "Stores",
                  isSelected: currentPage == "Stores" ? true : false),
              DrawerTile(
                  icon: Icons.message,
                  onTap: () {
                    if (currentPage != "Messaging")
                      Navigator.pushReplacementNamed(context, '/messaging');
                  },
                  iconColor: HelpayrColors.info,
                  title: "Messaging",
                  isSelected: currentPage == "Messaging" ? true : false),
              DrawerTile(
                  icon: FontAwesomeIcons.user,
                  onTap: () {
                    if (currentPage != "Profile")
                      Navigator.pushReplacementNamed(context, '/profile');
                  },
                  iconColor: HelpayrColors.warning,
                  title: "Profile",
                  isSelected: currentPage == "Profile" ? true : false),
              DrawerTile(
                  icon: FontAwesomeIcons.cog,
                  onTap: () {
                    if (currentPage != "Settings")
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Settings_Home(
                            isHome: true,
                          ),
                        ),
                      );
                  },
                  iconColor: HelpayrColors.success,
                  title: "Settings",
                  isSelected: currentPage == "Settings" ? true : false),
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
