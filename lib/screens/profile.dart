import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpayr/constants/Theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//widgets
import 'package:helpayr/widgets/navbar.dart';
import 'package:helpayr/widgets/drawer.dart';
import 'package:helpayr/widgets/photo-album.dart';

List<String> imgArray = [
  "assets/imgs/album-1.jpg",
  "assets/imgs/album-2.jpg",
  "assets/imgs/album-3.jpg",
  "assets/imgs/album-4.jpg",
  "assets/imgs/album-5.jpg",
  "assets/imgs/album-6.jpg"
];

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle profileButton = TextButton.styleFrom(
      backgroundColor: HelpayrColors.info,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
    );
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: Navbar(
          isProfile: true,
          title: "Profile",
          transparent: true,
        ),
        backgroundColor: HelpayrColors.bgColorScreen,
        drawer: NowDrawer(currentPage: "Profile"),
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/onboarding new/bg_wavy_rotated.png"),
                              fit: BoxFit.cover)),
                      child: Stack(
                        children: <Widget>[
                          SafeArea(
                            bottom: false,
                            right: false,
                            left: false,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, top: 10),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius: 90,
                                      backgroundImage:
                                          NetworkImage(user.photoURL)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 30.0),
                                        child: Text(user.displayName,
                                            style: TextStyle(
                                                color: HelpayrColors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22)),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text("Freelancer",
                                        style: TextStyle(
                                            color: HelpayrColors.white
                                                .withOpacity(0.85),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(user.email,
                                        style: TextStyle(
                                            color: HelpayrColors.white
                                                .withOpacity(0.85),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 24.0, left: 42, right: 32),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("2K",
                                                style: TextStyle(
                                                    color: HelpayrColors.white,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text("Friends",
                                                style: TextStyle(
                                                    color: HelpayrColors.white
                                                        .withOpacity(0.8),
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("26",
                                                style: TextStyle(
                                                    color: HelpayrColors.white,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text("Comments",
                                                style: TextStyle(
                                                    color: HelpayrColors.white
                                                        .withOpacity(0.8),
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("48",
                                                style: TextStyle(
                                                    color: HelpayrColors.white,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text("Bookmarks",
                                                style: TextStyle(
                                                    color: HelpayrColors.white
                                                        .withOpacity(0.8),
                                                    fontSize: 12.0))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                      child: SingleChildScrollView(
                          child: Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0, right: 32.0, top: 42.0),
                    child: Column(children: [
                      Text("About me",
                          style: TextStyle(
                              color: HelpayrColors.text,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0)),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24, top: 30, bottom: 24),
                        child: Text(
                            "Tempor sunt sint aliquip sit ex.Commodo amet aliquip elit in. Dolore culpa laboris tempor mollit. Consequat mollit enim qui dolore irure. Qui eu nulla et ad et fugiat ad nisi ullamco. Ullamco sint do excepteur reprehenderit duis deserunt aute id esse ex esse.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: HelpayrColors.black.withOpacity(.8))),
                      ),
                      PhotoAlbum(imgArray: imgArray)
                    ]),
                  ))),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, top: 235),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                      ),
                      child: TextButton(
                        style: profileButton,
                        onPressed: () {
                          // Respond to button press
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 10, bottom: 10),
                            child: Text("Follow",
                                style: TextStyle(
                                    fontSize: 13.0, color: Colors.white))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: RawMaterialButton(
                        constraints: BoxConstraints.tight(Size(38, 38)),
                        onPressed: () {},
                        elevation: 4.0,
                        fillColor: HelpayrColors.white,
                        child: Icon(FontAwesomeIcons.twitter,
                            size: 14.0, color: Colors.blue),
                        padding: EdgeInsets.all(0.0),
                        shape: CircleBorder(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: RawMaterialButton(
                        constraints: BoxConstraints.tight(Size(38, 38)),
                        onPressed: () {},
                        elevation: 4.0,
                        fillColor: HelpayrColors.white,
                        child: Icon(FontAwesomeIcons.tiktok,
                            size: 14.0, color: Colors.black),
                        padding: EdgeInsets.all(0.0),
                        shape: CircleBorder(),
                      ),
                    ),
                    RawMaterialButton(
                      constraints: BoxConstraints.tight(Size(38, 38)),
                      onPressed: () {},
                      elevation: 4.0,
                      fillColor: HelpayrColors.white,
                      child: Icon(FontAwesomeIcons.pinterest,
                          size: 14.0, color: Colors.red),
                      padding: EdgeInsets.all(0.0),
                      shape: CircleBorder(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
