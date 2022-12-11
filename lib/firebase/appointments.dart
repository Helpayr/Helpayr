import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/firebase/getData.dart';
import 'package:lottie/lottie.dart';

import 'details_appointment.dart';

class Appointment extends StatefulWidget {
  const Appointment({key, this.widget});
  final ServicePage widget;

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment>
    with SingleTickerProviderStateMixin {
  int selected = 0;
  List<String> days = [
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];
  String selected_day = "";
  bool morning = true;

  bool afternoon = false;
  PageController _pageController = PageController(initialPage: 0);
  int hour_morningSelected = 0;
  List<String> hour_morning = [
    "6:00 AM",
    "7:00 AM",
    "8:00 AM",
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
  ];
  int hour_afternoonSelected = 0;
  List<String> hour_afternoon = [
    "1:00 PM",
    "2:00 PM",
    "3:00 PM",
    "4:00 PM",
    "5:00 PM",
    "6:00 PM",
    "7:00 PM",
    "8:00 PM",
    "9:00 PM",
  ];
  AnimationController _animationctrl;
  String selected_halfDay = "";
  String selected_date = "";
  String selected_hour = "";

  @override
  void initState() {
    super.initState();
    _animationctrl = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    _animationctrl.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsBooking(),
          ),
        );
      }
    });
  }

  String Appointment_Id(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    }
    return "$user2$user1";
  }

  void set_appointment(String service, String name) async {
    await FirebaseFirestore.instance
        .collection("Helpers")
        .doc("Service")
        .collection(service)
        .doc(name)
        .collection("Bookings")
        .doc()
        .set({
      "date": selected_date,
      "day": selected_halfDay,
      "hour": selected_hour,
      "servicer": widget.widget.data['full_name'],
      "user": FirebaseAuth.instance.currentUser.displayName,
      "time": FieldValue.serverTimestamp(),
      "servicer_dp": widget.widget.data['dp'],
      "user_dp": FirebaseAuth.instance.currentUser.photoURL,
      "is_accepted": true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: Icon(
          Icons.arrow_left_rounded,
          color: Colors.black,
        ),
        title: Text(
          "Book a Service",
          style: GoogleFonts.manrope(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Select Date",
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = index;
                          selected_day = days[index];
                          selected_date = "December ${index + 1}";
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: selected == index
                              ? MediaQuery.of(context).size.width / 1.7
                              : MediaQuery.of(context).size.width / 2,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: selected == index
                                ? Colors.blueAccent
                                : Colors.white,
                            elevation: selected == index ? 10 : 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selected == index
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(days[index],
                                        style: GoogleFonts.manrope(
                                          color: selected == index
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Text(
                                  "December ${index + 1}",
                                  style: GoogleFonts.manrope(
                                      color: selected == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: selected == index ? 25 : 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                selected == index
                                    ? Text("Proceed ",
                                        style: GoogleFonts.manrope(
                                          color: selected == index
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ))
                                    : Text("Please Select a Date ",
                                        style: GoogleFonts.manrope(
                                          color: selected == index
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  itemCount: 31,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Text(
                      '${selected_day} in the',
                      style: GoogleFonts.manrope(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          morning = true;
                          afternoon = false;
                          hour_afternoonSelected = null;
                          selected_halfDay = "Morning";
                        });
                        return _pageController.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: Flexible(
                        child: Card(
                          color: morning ? Colors.blueAccent : Colors.white,
                          elevation: morning ? 10 : 1,
                          child: Container(
                            height: 40,
                            width: 100,
                            child: Center(
                              child: Text(
                                "Morning",
                                style: GoogleFonts.manrope(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        morning ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          morning = false;
                          afternoon = true;
                          hour_morningSelected = null;
                          selected_halfDay = "Afternoon";
                        });
                        return _pageController.animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: afternoon ? Colors.blueAccent : Colors.white,
                            elevation: afternoon ? 10 : 1,
                            child: Container(
                              height: 40,
                              width: 100,
                              child: Center(
                                child: Text(
                                  "Afternoon",
                                  style: GoogleFonts.manrope(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: afternoon
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 180,
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: hour_morning.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                          itemBuilder: ((context, index) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    hour_morningSelected = index;
                                    selected_hour = hour_morning[index];
                                  });
                                },
                                child: Container(
                                  width: 110,
                                  height: 40,
                                  child: Card(
                                    shadowColor: hour_morningSelected == index
                                        ? Colors.blue
                                        : Colors.grey,
                                    color: hour_morningSelected == index
                                        ? Colors.blue
                                        : Colors.white,
                                    elevation:
                                        hour_morningSelected == index ? 10 : 5,
                                    child: Center(
                                      child: Text(
                                        hour_morning[index],
                                        style: GoogleFonts.manrope(
                                            color: hour_morningSelected == index
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ))),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 160,
                      child: GridView.builder(
                          itemCount: hour_afternoon.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                          itemBuilder: ((context, index) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    hour_afternoonSelected = index;
                                    selected_hour = hour_afternoon[index];
                                  });
                                },
                                child: Container(
                                  width: 110,
                                  height: 20,
                                  child: Card(
                                    shadowColor: hour_afternoonSelected == index
                                        ? Colors.blue
                                        : Colors.grey,
                                    color: hour_afternoonSelected == index
                                        ? Colors.blue
                                        : Colors.white,
                                    elevation: hour_afternoonSelected == index
                                        ? 10
                                        : 5,
                                    child: Center(
                                      child: Text(hour_afternoon[index],
                                          style: GoogleFonts.manrope(
                                              color: hour_afternoonSelected ==
                                                      index
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                              ))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Card(
                      elevation: 10,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: 120,
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: Container(
                                  child: LottieBuilder.network(
                                      "https://assets2.lottiefiles.com/private_files/lf30_8ry7qrbu.json"),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    selected_date,
                                    style: GoogleFonts.manrope(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    selected_halfDay,
                                    style: GoogleFonts.manrope(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    selected_hour,
                                    style: GoogleFonts.manrope(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Card(
                      elevation: 10,
                      child: Card(
                        elevation: 10,
                        child: Container(
                          child: LottieBuilder.network(
                              "https://assets6.lottiefiles.com/packages/lf20_3vbOcw.json"),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Service Info",
                      style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 10,
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      NetworkImage(widget.widget.data['dp']))),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.widget.data['full_name']}',
                              style: GoogleFonts.manrope(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text('${widget.widget.data['job_profession']}'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  set_appointment(widget.widget.data['job_profession'],
                      widget.widget.data['full_name']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsBooking(
                        details: widget.widget.data,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Set Appointment",
                      style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
