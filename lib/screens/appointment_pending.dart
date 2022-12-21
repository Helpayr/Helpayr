import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentDetails_User extends StatefulWidget {
  const AppointmentDetails_User(
      {key,
      this.start,
      this.end,
      this.start_hour,
      this.end_hour,
      this.pic_servicer,
      this.name_servicer,
      this.notes,
      this.location,
      this.isUser = false,
      this.onMessage,
      this.onDelete,
      this.user_Complete = false});

  final String start;
  final String end;
  final String start_hour;
  final String end_hour;
  final String pic_servicer;
  final String name_servicer;
  final String notes;
  final String location;
  final bool isUser;
  final Function onMessage;
  final Function onDelete;
  final bool user_Complete;

  @override
  State<AppointmentDetails_User> createState() =>
      _AppointmentDetails_UserState();
}

class _AppointmentDetails_UserState extends State<AppointmentDetails_User> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        title: Text("Booking Report"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue,
                Colors.blueAccent,
                Color.fromARGB(255, 28, 98, 219),
                Color.fromARGB(255, 9, 64, 160),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(140),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(3, 0),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    children: [
                      Text(
                        'Starting Date: ${widget.start}',
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white),
                      ),
                      Row(
                        children: [
                          Text(
                            '${widget.start_hour}',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    children: [
                      Text(
                        'Ending Date: ${widget.end}',
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white),
                      ),
                      Row(
                        children: [
                          Text(
                            '${widget.end_hour}',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${widget.location}',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(widget.pic_servicer)),
                          border: Border.all(width: 8, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: widget.onMessage,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.message_rounded,
                              color: Colors.white,
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 5, color: Colors.white),
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    children: [
                      Text(
                        widget.name_servicer,
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Notes:",
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.notes,
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ]),
      ),
      bottomSheet: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: widget.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.spaceBetween,
            children: widget.isUser
                ? [
                    InkWell(
                      onTap: widget.onDelete,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Delete",
                            style: GoogleFonts.raleway(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(3, 0),
                              blurRadius: 6,
                            ),
                          ],
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ]
                : [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Accept",
                          style: GoogleFonts.raleway(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(3, 0),
                            blurRadius: 6,
                          ),
                        ],
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Delete",
                          style: GoogleFonts.raleway(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(3, 0),
                            blurRadius: 6,
                          ),
                        ],
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
