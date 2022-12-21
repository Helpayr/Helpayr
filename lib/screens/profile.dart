import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/constants/Theme.dart';
//widgets
import 'package:helpayr/widgets/navbar.dart';
import 'package:helpayr/widgets/drawer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import '../Message/widgets/avatar.dart';

class Profile extends StatefulWidget {
  const Profile({Key key, this.isServicer = false, this.service, this.name})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
  final bool isServicer;
  final String service;
  final String name;
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;
  ScrollController _scroll = ScrollController();

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
          service: widget.service,
          title: "Profile",
          transparent: true,
        ),
        backgroundColor: HelpayrColors.bgColorScreen,
        drawer: widget.isServicer ? null : NowDrawer(currentPage: "Profile"),
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/imgs/bluescreen.png"),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      color: Color.fromARGB(255, 6, 44, 75).withOpacity(.8),
                      child: Stack(
                        children: <Widget>[
                          SafeArea(
                            bottom: false,
                            right: false,
                            left: false,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, top: 0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius: 70,
                                      backgroundImage:
                                          NetworkImage(user.photoURL)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
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
                                    child: Text(widget.service,
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
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Helpers")
                            .doc("Service")
                            .collection(widget.service)
                            .doc(widget.name)
                            .collection("Ratings")
                            .orderBy("time", descending: true)
                            .snapshots(),
                        builder: ((context, snapshot) {
                          if (snapshot.data.docs.isEmpty) {
                            return Column(
                              children: [
                                LottieBuilder.network(
                                    "https://assets3.lottiefiles.com/packages/lf20_EMTsq1.json"),
                                Text(
                                  "Nothing to see here",
                                  style: GoogleFonts.oswald(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            );
                          }
                          return ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scroll,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: ((context, index) {
                              DateTime lastLog =
                                  (snapshot.data.docs[index]['time'].toDate());
                              String time_review =
                                  DateFormat.yMMMd().add_jm().format(lastLog);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Card(
                                      elevation: 10,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Avatar.medium(
                                                      url: snapshot
                                                              .data.docs[index]
                                                          ['user_pic']),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Flexible(
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        '${snapshot.data.docs[index]['user']}',
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      RatingBarIndicator(
                                                        rating: snapshot.data
                                                                .docs[index]
                                                            ['user_rating'],
                                                        itemBuilder:
                                                            (context, index) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors.blue,
                                                        ),
                                                        itemCount: 5,
                                                        itemSize: 20.0,
                                                        direction:
                                                            Axis.horizontal,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    '${time_review}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0, vertical: 15),
                                            child: Text(
                                              '${snapshot.data.docs[index]['review']}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            }),
                          );
                        })),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, top: 10),
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
                            child: Text("Reviews",
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
                        child: Icon(FontAwesomeIcons.star,
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
                        child: Icon(FontAwesomeIcons.pen,
                            size: 14.0, color: Colors.black),
                        padding: EdgeInsets.all(0.0),
                        shape: CircleBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
