import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidable/hidable.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../Message/pages/chatroom.dart';
import '../Message/widgets/avatar.dart';
import '../widgets/drawer.dart';
import '../widgets/navbar.dart';
import 'home.dart';

class Dashboard_User extends StatefulWidget {
  const Dashboard_User({key});

  @override
  State<Dashboard_User> createState() => _Dashboard_UserState();
}

class _Dashboard_UserState extends State<Dashboard_User> {
  bool pending = true;
  bool accepted = false;
  bool cancel = false;
  PageController _pageController = PageController(initialPage: 0);
  ScrollController _scrollController = ScrollController();
  List<String> sorted = [];
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
        },
        elevation: 5,
        child: Center(child: Icon(Icons.add)),
      ),
      drawer: NowDrawer(currentPage: "Bookings"),
      appBar: Hidable(
        wOpacity: true,
        preferredWidgetSize: Size.fromHeight(100),
        controller: _scrollController,
        child: Navbar(
          greetings: true,
          isProfile: false,
          name: user.displayName,
          url: user.photoURL,
          title: "Bookings",
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Text(
                        "My Bookings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(3, 0),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              pending = true;
                              accepted = false;
                              cancel = false;
                            });

                            _pageController.animateToPage(0,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut);
                          },
                          child: Flexible(
                            child: AnimatedContainer(
                              width: 100,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: pending ? Colors.blue : Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: Text(
                                  "Pending",
                                  style: TextStyle(
                                    fontWeight: pending
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: pending ? Colors.white : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              pending = false;
                              accepted = true;
                              cancel = false;
                            });
                            _pageController.animateToPage(1,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut);
                          },
                          child: Flexible(
                            child: AnimatedContainer(
                              width: 100,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: accepted ? Colors.blue : Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: Text(
                                  "Accepted",
                                  style: TextStyle(
                                      fontWeight: accepted
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: accepted
                                          ? Colors.white
                                          : Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              pending = false;
                              accepted = false;
                              cancel = true;
                            });
                            _pageController.animateToPage(2,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut);
                          },
                          child: Flexible(
                            child: AnimatedContainer(
                              width: 100,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: cancel ? Colors.blue : Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: Text(
                                  "Canceled",
                                  style: TextStyle(
                                      fontWeight: cancel
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color:
                                          cancel ? Colors.white : Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: PageView(
                      onPageChanged: (value) {
                        setState(() {
                          pending = value == 0;
                          accepted = value == 1;
                          cancel = value == 2;
                        });
                      },
                      controller: _pageController,
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .collection("Bookings")
                                      .where('is_pending', isEqualTo: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.data.docs.isEmpty) {
                                      return Column(
                                        children: [
                                          LottieBuilder.network(
                                              "https://assets3.lottiefiles.com/packages/lf20_EMTsq1.json"),
                                        ],
                                      );
                                    }
                                    return Pending(
                                      sorted: sorted,
                                      snapshot: snapshot,
                                    );
                                  }),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .collection("Bookings")
                                      .where('is_accepted', isEqualTo: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.data.docs.isEmpty) {
                                      return Column(
                                        children: [
                                          LottieBuilder.network(
                                              "https://assets3.lottiefiles.com/packages/lf20_EMTsq1.json"),
                                        ],
                                      );
                                    }
                                    return ListView.builder(
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: ((context, index) {
                                        DateTime lastLog = (snapshot
                                            .data.docs[index]['time']
                                            .toDate());
                                        String time_review = DateFormat.yMMMd()
                                            .add_jm()
                                            .format(lastLog);
                                        return StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection("Helpers")
                                              .doc("Service")
                                              .collection(
                                                  '${snapshot.data.docs[index]['service']}')
                                              .doc(
                                                  '${snapshot.data.docs[index]['servicer']}')
                                              .snapshots(),
                                          builder: (context, snapshot_chat) =>
                                              Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              elevation: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Avatar.large(
                                                          url: snapshot.data
                                                                  .docs[index]
                                                              ['servicer_dp'],
                                                        ),
                                                        SizedBox(
                                                          width: 30,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            FittedBox(
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                              child: Text(
                                                                "${snapshot.data.docs[index]['servicer']}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              "${snapshot.data.docs[index]['service']}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                                "${time_review}")
                                                          ],
                                                        )
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
                                                              style: GoogleFonts.raleway(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              "Booking Date (Start)",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                              style: GoogleFonts.raleway(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              "Booking Date (End)",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
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
                                                              .mapMarked,
                                                          color: Colors.blue,
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
                                                              '${snapshot.data.docs[index]['location']} ',
                                                              style: GoogleFonts.raleway(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              "Location",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 50.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextButton.icon(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Chatroom(
                                                                      recipient: snapshot_chat
                                                                          .data
                                                                          .data(),
                                                                      chatroomId: mod_chat(
                                                                          FirebaseAuth
                                                                              .instance
                                                                              .currentUser
                                                                              .displayName,
                                                                          snapshot_chat
                                                                              .data
                                                                              .data()),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              icon: Icon(Icons
                                                                  .message),
                                                              label: Text(
                                                                  "Message"))
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  }),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .collection("Bookings")
                                      .where('is_accepted', isEqualTo: false)
                                      .snapshots(),
                                  builder: (context, snapshot) {
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
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: ((context, index) {
                                        DateTime lastLog = (snapshot
                                            .data.docs[index]['time']
                                            .toDate());
                                        String time_review = DateFormat.yMMMd()
                                            .add_jm()
                                            .format(lastLog);
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            elevation: 5,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Avatar.large(
                                                        url: snapshot.data
                                                                .docs[index]
                                                            ['servicer_dp'],
                                                      ),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          FittedBox(
                                                            fit:
                                                                BoxFit.fitWidth,
                                                            child: Text(
                                                              "${snapshot.data.docs[index]['servicer']}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "${snapshot.data.docs[index]['service']}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          Text("${time_review}")
                                                        ],
                                                      )
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
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .mapMarked,
                                                        color: Colors.blue,
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
                                                            '${snapshot.data.docs[index]['location']} ',
                                                            style: GoogleFonts
                                                                .raleway(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          Text(
                                                            "Location",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Chatroom(
                                                        recipient: snapshot
                                                            .data.docs[index]
                                                            .data(),
                                                        chatroomId: mod_chat(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                .displayName,
                                                            snapshot.data
                                                                .docs[index]
                                                                .data()),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 50.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextButton.icon(
                                                              onPressed: () {},
                                                              icon: Icon(Icons
                                                                  .message),
                                                              label: Text(
                                                                  "Message"))
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  String mod_chat(String currentUser, Map<String, dynamic> data) {
    String sendTo = data['full_name'];
    if (currentUser[0].toLowerCase().codeUnits[0] >
        sendTo[0].toLowerCase().codeUnits[0]) {
      return "$currentUser$sendTo";
    }
    return "$sendTo$currentUser";
  }
}

class Pending extends StatelessWidget {
  const Pending({
    Key key,
    @required this.sorted,
    this.snapshot,
  }) : super(key: key);

  final List<String> sorted;
  final AsyncSnapshot<dynamic> snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: snapshot.data.docs.length,
      itemBuilder: ((context, index) {
        DateTime lastLog = (snapshot.data.docs[index]['time'].toDate());
        String time_review = DateFormat.yMMMd().add_jm().format(lastLog);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Avatar.large(
                        url: snapshot.data.docs[index]['servicer_dp'],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "${snapshot.data.docs[index]['servicer']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${snapshot.data.docs[index]['service']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text("${time_review}")
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.calendar,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${snapshot.data.docs[index]['date']}, ${snapshot.data.docs[index]['hour']}  ',
                            style: GoogleFonts.raleway(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Booking Date (Start)",
                            style: TextStyle(
                              color: Colors.black,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.calendarMinus,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${snapshot.data.docs[index]['end_Date']}, ${snapshot.data.docs[index]['hour_end']}  ',
                            style: GoogleFonts.raleway(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.mapMarked,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${snapshot.data.docs[index]['location']} ',
                            style: GoogleFonts.raleway(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Location",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            FirebaseFirestore.instance
                                .collection("Users")
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .collection("Bookings")
                                .where('is_pending', isEqualTo: true)
                                .get()
                                .then((value) => value.docs.forEach((element) {
                                      sorted.add(
                                        element.reference.id,
                                      );
                                    }));

                            showDialog(
                                context: context,
                                builder: ((context) => AlertDialog(
                                      actions: [
                                        TextButton.icon(
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection("Helpers")
                                                  .doc("Service")
                                                  .collection(
                                                      '${snapshot.data.docs[index]['service']}')
                                                  .doc(
                                                      '${snapshot.data.docs[index]['servicer']}')
                                                  .collection("Bookings")
                                                  .doc(
                                                      '${snapshot.data.docs[index]['uid']}')
                                                  .delete();
                                              await FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(FirebaseAuth
                                                      .instance.currentUser.uid)
                                                  .collection("Bookings")
                                                  .doc(sorted[index])
                                                  .delete()
                                                  .whenComplete(() {
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            icon: Icon(Icons.check),
                                            label: Text("Yes")),
                                        TextButton.icon(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(Icons.deselect),
                                            label: Text("No"))
                                      ],
                                      title: Text(
                                        "Cancel Confirmation",
                                        style: GoogleFonts.raleway(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Text(
                                        "The selected appointment will be permanently deleted. Proceed?",
                                        style: GoogleFonts.raleway(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.message),
                            label: Text("Message"))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
