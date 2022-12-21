import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/firebase/appointments.dart';

import '../Message/pages/chatroom.dart';
import 'getData.dart';

class DetailsHelper extends StatelessWidget {
  const DetailsHelper({key, this.widget});
  final ServicePage widget;
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    }
    return "$user2$user1";
  }

  Future addFave(
      String address,
      String age,
      String des,
      String bg,
      String dp,
      String fb,
      String full_name,
      List<dynamic> image,
      String job,
      String price) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("favs")
        .doc(full_name)
        .set({
      "Address": address,
      "Age": age,
      "Description": des,
      "bg": bg,
      "dp": dp,
      "fb": fb,
      "full_name": full_name,
      "image": image,
      "job_profession": job,
      "prices": price,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: 90,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.facebook,
                color: Colors.white,
                shadows: [
                  Shadow(
                      color: Colors.black, offset: Offset(2, 2), blurRadius: 5)
                ],
                size: 30,
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                FontAwesomeIcons.googlePlus,
                color: Colors.white,
                shadows: [
                  Shadow(
                      color: Colors.black, offset: Offset(2, 2), blurRadius: 5)
                ],
                size: 30,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Field(
            widget: widget,
            icon: FontAwesomeIcons.mapMarked,
            field: 'Address',
          ),
          Field(
            widget: widget,
            icon: Icons.person,
            field: 'Age',
          ),
          Field(
            isArray: true,
            widget: widget,
            icon: FontAwesomeIcons.moneyBill,
            field: 'prices',
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              indent: 1,
              height: 5,
              thickness: 2,
              color: Colors.white.withOpacity(.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Appointment(
                          widget: widget,
                        ),
                      ),
                    );
                  },
                  child: ElevatedButtonStore(
                    width: MediaQuery.of(context).size.width / 2,
                    icon: FontAwesomeIcons.check,
                    title: "Book Now",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chatroom(
                          recipient: widget.data,
                          chatroomId: chatRoomId(
                              FirebaseAuth.instance.currentUser.displayName,
                              widget.data['full_name']),
                        ),
                      ),
                    );
                  },
                  child: ElevatedButtonStore(
                    width: MediaQuery.of(context).size.width / 4,
                    icon: Icons.message,
                    title: "Chat",
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: ((context) => AlertDialog(
                                actions: [
                                  TextButton.icon(
                                      onPressed: () async {
                                        addFave(
                                                widget.data['Address'],
                                                widget.data['Age'],
                                                widget.data['Description'],
                                                widget.data['bg'],
                                                widget.data['dp'],
                                                widget.data['fb'],
                                                widget.data['full_name'],
                                                widget.data['image'],
                                                widget.data['job_profession'],
                                                widget.data['prices'][0])
                                            .whenComplete(() {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              duration: Duration(seconds: 4),
                                              content: Text(
                                                  "The service has been added to your Favorites!"),
                                            ),
                                          );

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
                                  "Add to My Favorites",
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  "The selected service will be added to your Favorites. Proceed?",
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.normal),
                                ),
                              )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(3, 0),
                            blurRadius: 6,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          FontAwesomeIcons.heart,
                          color: Colors.blue,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 113, 199, 238),
          Colors.lightBlue,
          Colors.lightBlue,
          Colors.lightBlue,
          Colors.blue,
          Colors.blue,
          Colors.blueAccent,
          Colors.blueAccent,
          Colors.blueAccent,
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 1.5,
    );
  }
}
