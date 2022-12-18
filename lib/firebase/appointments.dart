import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/firebase/getData.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
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

  String selected_day = "";
  bool morning = true;

  bool afternoon = false;

  bool morning_end = false;
  bool afternoon_end = false;
  PageController _pageController = PageController(initialPage: 0);
  PageController _pageController_end = PageController(initialPage: 0);

  List<String> hour_morning = [
    "6:00 AM",
    "7:00 AM",
    "8:00 AM",
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
  ];

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

  int hour_afternoonSelected = 0;
  int hour_morningSelected = 0;
  int hour_morning_endSelected = 0;
  int hour_afternoon_endSelected = 0;

  //These shits are what I need!

  @override
  void initState() {
    final DateTime today = DateTime.now();

    selected_date = DateFormat('MMMM dd, yyyy').format(today).toString();
    selected_endDate = DateFormat('MMMM dd, yyyy')
        .format(today.add(Duration(days: 3)))
        .toString();
    _dateRangePickerController.selectedRange =
        PickerDateRange(today, today.add(Duration(days: 3)));
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

  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();
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
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
      "date": selected_date,
      "end_Date": selected_endDate,
      "hour": selected_hour,
      "hour_end": selected_hour_end,
      "servicer": widget.widget.data['full_name'],
      "user": FirebaseAuth.instance.currentUser.displayName,
      "time": FieldValue.serverTimestamp(),
      "servicer_dp": widget.widget.data['dp'],
      "user_dp": FirebaseAuth.instance.currentUser.photoURL,
      "is_accepted": false,
      "notes": _notes.text,
      "uid": FirebaseAuth.instance.currentUser.uid,
      'is_pending': true,
      "location": _location.text,
      "phone_number_user": FirebaseAuth.instance.currentUser.phoneNumber,
    });
  }

  TextEditingController _location = TextEditingController();

  void set_appointment_user(String service) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("Bookings")
        .doc(widget.widget.data['full_name'])
        .set({
      "date": selected_date,
      "end_Date": selected_endDate,
      "hour": selected_hour,
      "hour_end": selected_hour_end,
      "servicer": widget.widget.data['full_name'],
      "user": FirebaseAuth.instance.currentUser.displayName,
      "time": FieldValue.serverTimestamp(),
      "servicer_dp": widget.widget.data['dp'],
      "user_dp": FirebaseAuth.instance.currentUser.photoURL,
      "is_accepted": false,
      "notes": _notes.text,
      "service": service,
      "uid": FirebaseAuth.instance.currentUser.uid,
      'is_pending': true,
      "location": _location.text,
      "phone_number_user": FirebaseAuth.instance.currentUser.phoneNumber,
    });
  }

  String selected_hour = "";
  String selected_date = "";
  String selected_endDate = '';
  String selected_hour_end = '';
  TextEditingController _notes = TextEditingController();

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
              height: 350,
              child: SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.range,
                showActionButtons: true,
                onSelectionChanged: _onselectChange,
                controller: _dateRangePickerController,
                onSubmit: (dates) {
                  print(dates);
                },
                onCancel: () {
                  _dateRangePickerController.selectedRange = null;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Starts in',
                        style: GoogleFonts.manrope(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${selected_date} in the',
                        style: GoogleFonts.manrope(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
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
                                  color: morning ? Colors.white : Colors.black),
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                  elevation:
                                      hour_afternoonSelected == index ? 10 : 5,
                                  child: Center(
                                    child: Text(hour_afternoon[index],
                                        style: GoogleFonts.manrope(
                                            color:
                                                hour_afternoonSelected == index
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
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ends in',
                        style: GoogleFonts.manrope(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${selected_endDate} in the',
                        style: GoogleFonts.manrope(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
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
                        morning_end = true;
                        afternoon_end = false;
                        hour_afternoon_endSelected = null;
                        selected_halfDay = "Morning";
                      });
                      return _pageController_end.animateToPage(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    child: Flexible(
                      child: Card(
                        color: morning_end ? Colors.blueAccent : Colors.white,
                        elevation: morning_end ? 10 : 1,
                        child: Container(
                          height: 40,
                          width: 100,
                          child: Center(
                            child: Text(
                              "Morning",
                              style: GoogleFonts.manrope(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: morning_end
                                      ? Colors.white
                                      : Colors.black),
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
                        morning_end = false;
                        afternoon_end = true;
                        hour_morning_endSelected = null;
                        selected_halfDay = "Afternoon";
                      });
                      return _pageController_end.animateToPage(1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    child: Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color:
                              afternoon_end ? Colors.blueAccent : Colors.white,
                          elevation: afternoon_end ? 10 : 1,
                          child: Container(
                            height: 40,
                            width: 100,
                            child: Center(
                              child: Text(
                                "Afternoon",
                                style: GoogleFonts.manrope(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: afternoon_end
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
                controller: _pageController_end,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: hour_morning.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        itemBuilder: ((context, index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  hour_morning_endSelected = index;
                                  selected_hour_end = hour_morning[index];
                                });
                              },
                              child: Container(
                                width: 110,
                                height: 40,
                                child: Card(
                                  shadowColor: hour_morning_endSelected == index
                                      ? Colors.blue
                                      : Colors.grey,
                                  color: hour_morning_endSelected == index
                                      ? Colors.blue
                                      : Colors.white,
                                  elevation:
                                      hour_morningSelected == index ? 10 : 5,
                                  child: Center(
                                    child: Text(
                                      hour_morning[index],
                                      style: GoogleFonts.manrope(
                                          color:
                                              hour_morning_endSelected == index
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        itemBuilder: ((context, index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  hour_afternoon_endSelected = index;
                                  selected_hour_end = hour_afternoon[index];
                                });
                              },
                              child: Container(
                                width: 110,
                                height: 20,
                                child: Card(
                                  shadowColor:
                                      hour_afternoon_endSelected == index
                                          ? Colors.blue
                                          : Colors.grey,
                                  color: hour_afternoon_endSelected == index
                                      ? Colors.blue
                                      : Colors.white,
                                  elevation: hour_afternoon_endSelected == index
                                      ? 10
                                      : 5,
                                  child: Center(
                                    child: Text(hour_afternoon[index],
                                        style: GoogleFonts.manrope(
                                            color: hour_afternoon_endSelected ==
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
            Text(
              "Summary",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Card(
              elevation: 10,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
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
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Starts in  $selected_date',
                            style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                          Text(
                            selected_hour,
                            style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              height: 1,
                              thickness: 2,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Ends in  $selected_endDate',
                            style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          Text(
                            selected_hour_end,
                            style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(3, 0),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _notes,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Add some notes",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(3, 0),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _location,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Add specific location",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 30,
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
                                image: NetworkImage(widget.widget.data['dp']))),
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
                set_appointment_user(widget.widget.data['job_profession']);
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
    );
  }

  void _onselectChange(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      selected_date =
          DateFormat('MMMM dd, yyyy').format(args.value.startDate).toString();
      selected_endDate = DateFormat('MMMM dd, yyyy')
          .format(args.value.endDate ?? args.value.startDate)
          .toString();
    });
  }
}
