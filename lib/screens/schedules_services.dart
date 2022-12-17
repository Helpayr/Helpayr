import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/Message/widgets/widget.dart';
import 'package:intl/intl.dart';

import '../Message/pages/chatroom.dart';

class Schedule_Service extends StatefulWidget {
  const Schedule_Service({key, this.service, this.controller});
  final String service;
  final ScrollController controller;

  @override
  State<Schedule_Service> createState() => _Schedule_ServiceState();
}

class _Schedule_ServiceState extends State<Schedule_Service> {
  bool pending = true;
  bool cancel = false;
  bool accepted = false;

  ScrollController _controller = ScrollController();
  PageController _pageController = PageController(initialPage: 0);
  List<String> sorted = [];
  List<String> user_sorted = [];
  List<String> sorted_accept = [];
  String mod_chat(String currentUser, Map<String, dynamic> data) {
    String sendTo = data['full_name'];
    if (currentUser[0].toLowerCase().codeUnits[0] >
        sendTo[0].toLowerCase().codeUnits[0]) {
      return "$currentUser$sendTo";
    }
    return "$sendTo$currentUser";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Schedules",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
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
                                  color: accepted ? Colors.white : Colors.grey),
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
                                  color: cancel ? Colors.white : Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
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
                                .collection("Helpers")
                                .doc("Service")
                                .collection(widget.service)
                                .doc(FirebaseAuth
                                    .instance.currentUser.displayName)
                                .collection("Bookings")
                                .where('is_pending', isEqualTo: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              return ListView.builder(
                                controller: _controller,
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
                                                  url: snapshot.data.docs[index]
                                                      ['user_dp'],
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${snapshot.data.docs[index]['user']}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
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
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.calendar,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${snapshot.data.docs[index]['date']}, ${snapshot.data.docs[index]['hour']}  ',
                                                      style:
                                                          GoogleFonts.raleway(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${snapshot.data.docs[index]['end_Date']}, ${snapshot.data.docs[index]['hour_end']}  ',
                                                      style:
                                                          GoogleFonts.raleway(
                                                              color: Colors.red,
                                                              fontSize: 15,
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
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.mapMarked,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${snapshot.data.docs[index]['location']} ',
                                                      style:
                                                          GoogleFonts.raleway(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder:
                                                              ((context) =>
                                                                  AlertDialog(
                                                                    actions: [
                                                                      TextButton.icon(
                                                                          onPressed: () async {
                                                                            _pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeInOut).whenComplete(() {
                                                                              Navigator.of(context).pop();
                                                                            });
                                                                            await FirebaseFirestore.instance.collection("Helpers").doc("Service").collection(widget.service).doc(FirebaseAuth.instance.currentUser.displayName).collection("Bookings").where('is_pending', isEqualTo: true).get().then((value) =>
                                                                                value.docs.forEach((element) {
                                                                                  sorted.add(
                                                                                    element.reference.id,
                                                                                  );
                                                                                }));

                                                                            await FirebaseFirestore.instance.collection("Helpers").doc("Service").collection(widget.service).doc(FirebaseAuth.instance.currentUser.displayName).collection("Bookings").doc(sorted[index]).update({
                                                                              'is_pending': false,
                                                                              'is_accepted': false,
                                                                            });

                                                                            await FirebaseFirestore.instance.collection("Users").doc('${snapshot.data.docs[index]['uid']}').collection("Bookings").orderBy('time', descending: true).get().then((value) =>
                                                                                value.docs.forEach((element) {
                                                                                  user_sorted.add(
                                                                                    element.reference.id,
                                                                                  );
                                                                                }));
                                                                            await FirebaseFirestore.instance.collection("Users").doc('${snapshot.data.docs[index]['uid']}').collection("Bookings").doc(user_sorted[index]).update({
                                                                              'is_accepted': false,
                                                                              'is_pending': false,
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
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      "The selected appointment will be permanently deleted. Proceed?",
                                                                      style: GoogleFonts.raleway(
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                  )));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 2,
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder:
                                                              ((context) =>
                                                                  AlertDialog(
                                                                    actions: [
                                                                      TextButton.icon(
                                                                          onPressed: () async {
                                                                            _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut).whenComplete(() {
                                                                              Navigator.of(context).pop();
                                                                            });
                                                                            await FirebaseFirestore.instance.collection("Helpers").doc("Service").collection(widget.service).doc(FirebaseAuth.instance.currentUser.displayName).collection("Bookings").where('is_pending', isEqualTo: true).get().then((value) =>
                                                                                value.docs.forEach((element) {
                                                                                  sorted.add(
                                                                                    element.reference.id,
                                                                                  );
                                                                                }));

                                                                            await FirebaseFirestore.instance.collection("Helpers").doc("Service").collection(widget.service).doc(FirebaseAuth.instance.currentUser.displayName).collection("Bookings").doc(sorted[index]).update({
                                                                              'is_accepted': true,
                                                                              'is_pending': false,
                                                                            });

                                                                            await FirebaseFirestore.instance.collection("Users").doc('${snapshot.data.docs[index]['uid']}').collection("Bookings").orderBy('time', descending: true).get().then((value) =>
                                                                                value.docs.forEach((element) {
                                                                                  user_sorted.add(
                                                                                    element.reference.id,
                                                                                  );
                                                                                }));
                                                                            await FirebaseFirestore.instance.collection("Users").doc('${snapshot.data.docs[index]['uid']}').collection("Bookings").doc(user_sorted[index]).update({
                                                                              'is_accepted': true,
                                                                              'is_pending': false,
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
                                                                      "Accept this appointment?",
                                                                      style: GoogleFonts.raleway(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      "The selected appointment will be accepted. Proceed?",
                                                                      style: GoogleFonts.raleway(
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                  )));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.blueAccent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Accept",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
                            }),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Helpers")
                                .doc("Service")
                                .collection(widget.service)
                                .doc(FirebaseAuth
                                    .instance.currentUser.displayName)
                                .collection("Bookings")
                                .where('is_accepted', isEqualTo: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              return ListView.builder(
                                controller: _controller,
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
                                        .collection("Users")
                                        .doc(snapshot.data.docs[index]['uid'])
                                        .snapshots(),
                                    builder: (context, snapchat) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        elevation: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Avatar.large(
                                                    url: snapshot.data
                                                        .docs[index]['user_dp'],
                                                  ),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${snapshot.data.docs[index]['user']}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
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
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.calendar,
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
                                                        style:
                                                            GoogleFonts.raleway(
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 15,
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
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.mapMarked,
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
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 50.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton.icon(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Chatroom(
                                                                recipient:
                                                                    snapchat
                                                                        .data
                                                                        .data(),
                                                                chatroomId: mod_chat(
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser
                                                                        .displayName,
                                                                    snapchat
                                                                        .data
                                                                        .data()),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        icon:
                                                            Icon(Icons.message),
                                                        label: Text("Message"))
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
                                .collection("Helpers")
                                .doc("Service")
                                .collection(widget.service)
                                .doc(FirebaseAuth
                                    .instance.currentUser.displayName)
                                .collection("Bookings")
                                .where('is_accepted', isEqualTo: false)
                                .snapshots(),
                            builder: (context, snapshot) {
                              return ListView.builder(
                                controller: _controller,
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
                                                  url: snapshot.data.docs[index]
                                                      ['user_dp'],
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${snapshot.data.docs[index]['user']}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
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
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.calendar,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${snapshot.data.docs[index]['date']}, ${snapshot.data.docs[index]['hour']}  ',
                                                      style:
                                                          GoogleFonts.raleway(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${snapshot.data.docs[index]['end_Date']}, ${snapshot.data.docs[index]['hour_end']}  ',
                                                      style:
                                                          GoogleFonts.raleway(
                                                              color: Colors.red,
                                                              fontSize: 15,
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
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.mapMarked,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${snapshot.data.docs[index]['location']} ',
                                                      style:
                                                          GoogleFonts.raleway(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
            ))
          ],
        ),
      )),
    );
  }
}
