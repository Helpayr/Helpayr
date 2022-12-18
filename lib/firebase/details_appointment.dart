import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../Message/widgets/avatar.dart';
import '../screens/dashboard_appointments_user.dart';

class DetailsBooking extends StatefulWidget {
  const DetailsBooking({
    key,
    this.details,
  });
  final Map<String, dynamic> details;

  @override
  State<DetailsBooking> createState() => _DetailsBookingState();
}

class _DetailsBookingState extends State<DetailsBooking> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Helpers")
          .doc("Service")
          .collection('${widget.details['job_profession']}')
          .doc('${widget.details['full_name']}')
          .collection("Bookings")
          .where("user",
              isEqualTo: FirebaseAuth.instance.currentUser.displayName)
          .snapshots(),
      builder: ((context, snapshot) {
        return Scaffold(
          extendBody: true,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/imgs/onboarding-bg.png"),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 40,
                      bottom: snapshot.data.docs[0]['is_accepted'] ? 0 : 70),
                  child: Container(
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 10,
                        child: if_accepted(context)),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  SingleChildScrollView if_accepted(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 10,
            width: 50,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 12, 103, 179),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Booking Details",
              style: GoogleFonts.raleway(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  height: 120,
                  width: 150,
                  child: Column(
                    children: [
                      Text(
                        "User",
                        style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Avatar.small(
                          url: FirebaseAuth.instance.currentUser.photoURL),
                      Text(
                        FirebaseAuth.instance.currentUser.displayName,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: LottieBuilder.network(
                  "https://assets4.lottiefiles.com/packages/lf20_bqUlAq.json",
                  repeat: true,
                ),
              ),
              Flexible(
                child: Container(
                  height: 120,
                  width: 150,
                  child: Column(
                    children: [
                      Text(
                        'Service',
                        style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Avatar.small(url: widget.details['dp']),
                      Text(
                        '${widget.details['full_name']}',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: 180,
            child: Swiper(
                autoplay: true,
                itemCount: widget.details['image'].length,
                itemBuilder: ((context, index) => Card(
                      elevation: 5,
                      child: Container(
                        height: 140,
                        width: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    widget.details['image'][index]))),
                      ),
                    ))),
          ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Helpers")
                  .doc("Service")
                  .collection('${widget.details['job_profession']}')
                  .doc('${widget.details['full_name']}')
                  .collection("Bookings")
                  .where("user",
                      isEqualTo: FirebaseAuth.instance.currentUser.displayName)
                  .snapshots(),
              builder: ((context, snapshot) => Container(
                    width: MediaQuery.of(context).size.width / 1.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(3, 0),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(FontAwesomeIcons.calendar),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${snapshot.data.docs[0]['date']}, ${snapshot.data.docs[0]['hour']}  ',
                                    style: GoogleFonts.raleway(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("Booking Date (Start)")
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(FontAwesomeIcons.calendar),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${snapshot.data.docs[0]['end_Date']}, ${snapshot.data.docs[0]['hour_end']}  ',
                                    style: GoogleFonts.raleway(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("Booking Date (End)")
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(FontAwesomeIcons.locationArrow),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.details['Address']} ',
                                    style: GoogleFonts.raleway(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("Location")
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.work),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.details['job_profession']} ',
                                    style: GoogleFonts.raleway(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("Service"),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.person),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.details['full_name']} ',
                                    style: GoogleFonts.raleway(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("Name"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ))),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(3, 0),
                  blurRadius: 6,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dashboard_User(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Go to Dashboard",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
