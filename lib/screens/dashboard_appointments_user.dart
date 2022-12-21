import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/screens/appointment_accepted.dart';
import 'package:helpayr/screens/appointment_pending.dart';
import 'package:helpayr/screens/history.dart';
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
  Future addReview(String service, String name) async {
    await FirebaseFirestore.instance
        .collection("Helpers")
        .doc("Service")
        .collection(service)
        .doc(name)
        .collection("Ratings")
        .add({
      "review": controller.text,
      "time": FieldValue.serverTimestamp(),
      "user": FirebaseAuth.instance.currentUser.displayName,
      "user_rating": double.parse(rating_number.text),
      "user_pic": FirebaseAuth.instance.currentUser.photoURL,
    });
  }

  Future history(
    String date,
    String end_Date,
    String hour,
    String hour_end,
    String servicer,
    String servicer_dp,
    String notes,
    String uid,
    String location,
    String service,
  ) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("History")
        .add({
      "date": date,
      "end_Date": end_Date,
      "hour": hour,
      "hour_end": hour_end,
      "servicer": servicer,
      "user": FirebaseAuth.instance.currentUser.displayName,
      "servicer_dp": servicer_dp,
      "user_dp": FirebaseAuth.instance.currentUser.photoURL,
      "notes": servicer_dp,
      "uid": FirebaseAuth.instance.currentUser.uid,
      "location": location,
      'service': service
    });
  }

  Future history_helper(
    String date,
    String end_Date,
    String hour,
    String hour_end,
    String servicer,
    String servicer_dp,
    String notes,
    String uid,
    String location,
    String service,
  ) async {
    await FirebaseFirestore.instance
        .collection("Helpers")
        .doc("Service")
        .collection(service)
        .doc(servicer)
        .collection("History")
        .add({
      "date": date,
      "end_Date": end_Date,
      "hour": hour,
      "hour_end": hour_end,
      "servicer": servicer,
      "user": FirebaseAuth.instance.currentUser.displayName,
      "servicer_dp": servicer_dp,
      "user_dp": FirebaseAuth.instance.currentUser.photoURL,
      "notes": servicer_dp,
      "uid": FirebaseAuth.instance.currentUser.uid,
      "location": location,
      'service': service
    });
  }

  bool pending = true;
  bool accepted = false;
  bool cancel = false;
  PageController _pageController = PageController(initialPage: 0);
  ScrollController _scrollController = ScrollController();
  TextEditingController rating_number = TextEditingController();
  TextEditingController controller = TextEditingController();
  List<String> sorted = [];
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                        IsAccepted(),
                        Declined(),
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

  Column Declined() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser.uid)
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
                        style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
                      )
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: ((context, index) {
                    DateTime lastLog =
                        (snapshot.data.docs[index]['time'].toDate());
                    String time_review =
                        DateFormat.yMMMd().add_jm().format(lastLog);
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
                                        ['servicer_dp'],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                width: 10,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                              GestureDetector(
                                onTap: () {
                                  Chatroom(
                                    recipient: snapshot.data.docs[index].data(),
                                    chatroomId: mod_chat(
                                        FirebaseAuth
                                            .instance.currentUser.displayName,
                                        snapshot.data.docs[index].data()),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton.icon(
                                          onPressed: () {},
                                          icon: Icon(Icons.message),
                                          label: Text("Message"))
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
    );
  }

  Column IsAccepted() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .collection("Bookings")
                  .where('is_accepted', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data.docs.isEmpty) {
                  return Column(
                    children: [
                      LottieBuilder.network(
                          "https://assets3.lottiefiles.com/packages/lf20_EMTsq1.json"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Bookings that have been accepted by the Helpers will be added here!",
                          textAlign: TextAlign.center,
                          style:
                              GoogleFonts.raleway(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: ((context, index) {
                    DateTime lastLog =
                        (snapshot.data.docs[index]['time'].toDate());
                    String time_review =
                        DateFormat.yMMMd().add_jm().format(lastLog);
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Helpers")
                          .doc("Service")
                          .collection('${snapshot.data.docs[index]['service']}')
                          .doc('${snapshot.data.docs[index]['servicer']}')
                          .snapshots(),
                      builder: (context, snapshot_chat) => Padding(
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
                                          ['servicer_dp'],
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AppointmentDetails_UserAccepted(
                                              onComplete: () {
                                                print("hi");
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        ShowDialog_Complete(
                                                            snapshot,
                                                            index,
                                                            context));
                                              },
                                              start: snapshot.data.docs[index]
                                                  ['date'],
                                              start_hour: snapshot
                                                  .data.docs[index]['hour'],
                                              end: snapshot.data.docs[index]
                                                  ['end_Date'],
                                              end_hour: snapshot
                                                  .data.docs[index]['hour_end'],
                                              pic_servicer: snapshot.data
                                                  .docs[index]['servicer_dp'],
                                              name_servicer: snapshot
                                                  .data.docs[index]['servicer'],
                                              notes: snapshot.data.docs[index]
                                                  ['notes'],
                                              location: snapshot
                                                  .data.docs[index]['location'],
                                              onMessage: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Chatroom(
                                                      recipient: snapshot_chat
                                                          .data
                                                          .data(),
                                                      chatroomId: mod_chat(
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              .displayName,
                                                          snapshot_chat.data
                                                              .data()),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            "See More!",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
    );
  }

  Dialog ShowDialog_Complete(
      AsyncSnapshot<dynamic> snapshot, int index, BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      child: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 600,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(
                children: [
                  Text("Service Review",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(3, 0),
                            blurRadius: 6,
                          ),
                        ],
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                snapshot.data.docs[index]['servicer_dp']))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("${snapshot.data.docs[index]['servicer']}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.center),
                  Text("${snapshot.data.docs[index]['service']}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 15),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 15,
                  ),
                  RatingBarIndicator(
                    rating: 5,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.blue,
                    ),
                    itemCount: 5,
                    itemSize: 30.0,
                    direction: Axis.horizontal,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(3, 0),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: rating_number,
                      decoration: InputDecoration(
                        hintText: "1-5",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(3, 0),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: TextField(
                        style: GoogleFonts.raleway(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 18),
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        controller: controller,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            hintText: "   Write a review for this service :)"),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await history(
                                snapshot.data.docs[index]['date'],
                                snapshot.data.docs[index]['end_Date'],
                                snapshot.data.docs[index]['hour'],
                                snapshot.data.docs[index]['hour_end'],
                                snapshot.data.docs[index]['servicer'],
                                snapshot.data.docs[index]['servicer_dp'],
                                snapshot.data.docs[index]['notes'],
                                snapshot.data.docs[index]['uid'],
                                snapshot.data.docs[index]['location'],
                                snapshot.data.docs[index]['service']);
                            await history_helper(
                                snapshot.data.docs[index]['date'],
                                snapshot.data.docs[index]['end_Date'],
                                snapshot.data.docs[index]['hour'],
                                snapshot.data.docs[index]['hour_end'],
                                snapshot.data.docs[index]['servicer'],
                                snapshot.data.docs[index]['servicer_dp'],
                                snapshot.data.docs[index]['notes'],
                                snapshot.data.docs[index]['uid'],
                                snapshot.data.docs[index]['location'],
                                snapshot.data.docs[index]['service']);
                            await FirebaseFirestore.instance
                                .collection("Users")
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .collection("Bookings")
                                .doc(snapshot.data.docs[index]['servicer'])
                                .delete();
                            await FirebaseFirestore.instance
                                .collection("Helpers")
                                .doc('Service')
                                .collection(
                                    snapshot.data.docs[index]['service'])
                                .doc(snapshot.data.docs[index]['servicer'])
                                .collection("Bookings")
                                .doc(snapshot.data.docs[index]['uid'])
                                .delete();
                            addReview(snapshot.data.docs[index]['service'],
                                    snapshot.data.docs[index]['servicer'])
                                .whenComplete(() async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => History(),
                                ),
                              );
                            });
                          },
                          child: Card(
                            elevation: 5,
                            color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Submit Review",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Positioned(
              top: -100,
              child: LottieBuilder.network(
                "https://assets6.lottiefiles.com/packages/lf20_qq6gioyz.json",
                height: 150,
                width: 300,
              ),
            )
          ],
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
    return ListView.builder(
      itemCount: snapshot.data.docs.length,
      itemBuilder: ((context, index) {
        DateTime lastLog = (snapshot.data.docs[index]['time'].toDate());
        String time_review = DateFormat.yMMMd().add_jm().format(lastLog);
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Helpers")
              .doc("Service")
              .collection('${snapshot.data.docs[index]['service']}')
              .doc('${snapshot.data.docs[index]['servicer']}')
              .snapshots(),
          builder: (context, snapchat) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentDetails_User(
                      isUser: true,
                      start: snapshot.data.docs[index]['date'],
                      start_hour: snapshot.data.docs[index]['hour'],
                      end: snapshot.data.docs[index]['end_Date'],
                      end_hour: snapshot.data.docs[index]['hour_end'],
                      pic_servicer: snapshot.data.docs[index]['servicer_dp'],
                      name_servicer: snapshot.data.docs[index]['servicer'],
                      notes: snapshot.data.docs[index]['notes'],
                      location: snapshot.data.docs[index]['location'],
                      onMessage: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chatroom(
                              recipient: snapchat.data.data(),
                              chatroomId: mod_chat(
                                  FirebaseAuth.instance.currentUser.displayName,
                                  snapchat.data.data()),
                            ),
                          ),
                        );
                      },
                      onDelete: () {
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
                    ),
                  ),
                );
              },
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
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "See More!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
                                    .then((value) =>
                                        value.docs.forEach((element) {
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
                                                  await FirebaseFirestore
                                                      .instance
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
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Users")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser.uid)
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
                                  border:
                                      Border.all(width: 2, color: Colors.black),
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
            ),
          ),
        );
      }),
    );
  }
}
