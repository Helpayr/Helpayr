import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/Message/widgets/widget.dart';
import 'package:helpayr/constants/services_tentative.dart';
import 'package:intl/intl.dart';

class Servicer_Dashboard extends StatefulWidget {
  const Servicer_Dashboard({key, this.service});
  final String service;

  @override
  State<Servicer_Dashboard> createState() => _Servicer_DashboardState();
}

class _Servicer_DashboardState extends State<Servicer_Dashboard> {
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Avatar.small(
              url: FirebaseAuth.instance.currentUser.photoURL,
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
      body: Container(
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
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width / 1.1,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Helpers")
                      .doc("Service")
                      .collection(widget.service)
                      .doc(FirebaseAuth.instance.currentUser.displayName)
                      .collection("Bookings")
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
                          return Container(
                            height: 170,
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: Card(
                              color: colors[index + 1],
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
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
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${time_review}',
                                              style: GoogleFonts.raleway(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Card(
                                            color: Colors.blue.withOpacity(.8),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .calendar,
                                                        color: Colors.white,
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
                                                            '${snapshot.data.docs[index]['date']} 2022, ${snapshot.data.docs[index]['hour']}  ',
                                                            style: GoogleFonts
                                                                .raleway(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          Text(
                                                            "Booking Date",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                          );
                        }));
                  })),
            ),
            SizedBox(
              height: 40,
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                            return Padding(
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
                                          child: Container(
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    )),
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
      ),
    );
  }
}
