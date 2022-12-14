import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/Message/widgets/widget.dart';
import 'package:helpayr/main.dart';
import 'package:helpayr/screens/profile.dart';
import 'package:helpayr/screens/schedules_services.dart';
import 'package:hidable/hidable.dart';
import 'package:intl/intl.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../Message/pages/message_service.dart';

class Servicer_Dashboard extends StatefulWidget {
  const Servicer_Dashboard({key, this.service});
  final String service;

  @override
  State<Servicer_Dashboard> createState() => _Servicer_DashboardState();
}

class _Servicer_DashboardState extends State<Servicer_Dashboard> {
  TextEditingController search = TextEditingController();
  dynamic selected;
  var heart = false;
  PageController controller = PageController();
  ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return noback(
      wid: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
                padding: const EdgeInsets.all(8.0),
                child: Avatar.small(
                  url: FirebaseAuth.instance.currentUser.photoURL,
                ),
              ),
            )
          ],
          elevation: 0,
          backgroundColor: Colors.white,
          leadingWidth: 190,
          title: Text(
            "Dashboard",
            style: TextStyle(color: Colors.black),
          ),
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Hello",
                    style: GoogleFonts.raleway(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                Text(FirebaseAuth.instance.currentUser.displayName,
                    style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Hidable(
          controller: _controller,
          child: StylishBottomBar(
            items: [
              AnimatedBarItems(
                  icon: const Icon(
                    Icons.house_outlined,
                  ),
                  selectedIcon: const Icon(Icons.house_rounded),
                  selectedColor: Colors.teal,
                  backgroundColor: Colors.tealAccent,
                  title: const Text('Home')),
              AnimatedBarItems(
                  icon: const Icon(
                    Icons.message_outlined,
                  ),
                  selectedIcon: const Icon(
                    Icons.message,
                  ),
                  backgroundColor: Colors.amber,
                  selectedColor: Colors.deepOrangeAccent,
                  title: const Text('Message')),
              AnimatedBarItems(
                  icon: const Icon(
                    Icons.person_outline,
                  ),
                  selectedIcon: const Icon(
                    Icons.person,
                  ),
                  backgroundColor: Colors.purpleAccent,
                  selectedColor: Colors.deepPurple,
                  title: const Text('Profile')),
            ],
            iconSize: 32,
            barAnimation: BarAnimation.blink,
            iconStyle: IconStyle.animated,
            hasNotch: true,
            fabLocation: StylishBarFabLocation.end,
            opacity: 0.3,
            currentIndex: selected ?? 0,
            onTap: (index) {
              controller.jumpToPage(index);
              setState(() {
                selected = index;
              });
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              heart = !heart;
            });
          },
          backgroundColor: Colors.white,
          child: Icon(
            heart ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
            color: Colors.red,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: SafeArea(
          child: PageView(
            controller: controller,
            children: [
              Home(
                search: search,
                widget: widget,
              ),
              MessagePageService(),
              Schedule_Service(
                service: widget.service,
                controller: _controller,
              ),
            ],
          ),
        ),
        extendBody: false,
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key key,
    @required this.search,
    @required this.widget,
  }) : super(key: key);

  final TextEditingController search;
  final Servicer_Dashboard widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AnimSearchBar(
              width: MediaQuery.of(context).size.width,
              onSuffixTap: () {},
              textController: search,
            ),
          ),
          Text(
            "Pending Appointment/s",
            style:
                GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width / 1.1,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Helpers")
                    .doc("Service")
                    .collection(widget.service)
                    .doc(FirebaseAuth.instance.currentUser.displayName)
                    .collection("Bookings")
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: ((context, snapshot) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: ((context, index) {
                        DateTime lastLog =
                            (snapshot.data.docs[index]['time'].toDate());
                        String time_review =
                            DateFormat.yMMMd().add_jm().format(lastLog);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(3, 0),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            height: 200,
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: Card(
                              color: Colors.white,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Avatar.large(
                                          url: snapshot.data.docs[index]
                                              ['user_dp'],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${snapshot.data.docs[index]['user']}',
                                              style: GoogleFonts.raleway(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              '${time_review}',
                                              style: GoogleFonts.raleway(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Card(
                                            elevation: 5,
                                            color: Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .calendar,
                                                        color: Colors.black,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${snapshot.data.docs[index]['date']}, ${snapshot.data.docs[index]['hour']}  ',
                                                            style: GoogleFonts
                                                                .raleway(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          Text(
                                                            "Booking Date (Start)",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .calendarMinus,
                                                        color: Colors.red,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${snapshot.data.docs[index]['end_Date']}, ${snapshot.data.docs[index]['hour_end']}  ',
                                                            style: GoogleFonts
                                                                .raleway(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          Text(
                                                            "Booking Date (End)",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.facebookMessenger,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }));
                })),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Top ${widget.service}",
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Helpers")
                        .doc("Service")
                        .collection(widget.service)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          FirebaseFirestore.instance
                              .collection("Helpers")
                              .doc("Service")
                              .collection(widget.service)
                              .doc(
                                  FirebaseAuth.instance.currentUser.displayName)
                              .collection("Bookings")
                              .orderBy('time', descending: true)
                              .snapshots();
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Helpers")
                                .doc("Service")
                                .collection(widget.service)
                                .doc(
                                    '${snapshot.data.docs[index]['full_name']}')
                                .collection("Ratings")
                                .snapshots(),
                            builder: (context, snapshot_rating) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 160,
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(3, 0),
                                                    blurRadius: 6,
                                                  ),
                                                ],
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(snapshot
                                                        .data
                                                        .docs[index]['dp']))),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "${snapshot.data.docs[index]['full_name']}",
                                                  style: GoogleFonts.raleway(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "${snapshot.data.docs[index]['Address']} -",
                                                      ),
                                                      Text(
                                                        "${snapshot.data.docs[index]['job_profession']} ",
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.star,
                                                            color: Colors.blue),
                                                        Text(
                                                          "${snapshot_rating.data.docs[0]['user_rating']} -  ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "${snapshot_rating.data.docs.length} review/s",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
