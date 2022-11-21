import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpayr/firebase/appointments.dart';

import 'getData.dart';

class DetailsHelper extends StatelessWidget {
  const DetailsHelper({key, this.widget});
  final ServicePage widget;
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
            widget: widget,
            icon: FontAwesomeIcons.check,
            field: 'avail',
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
                    title: "Set Appointments",
                  ),
                ),
                ElevatedButtonStore(
                  width: MediaQuery.of(context).size.width / 4,
                  icon: Icons.message,
                  title: "Chat",
                ),
                ElevatedButtonStore(
                  width: MediaQuery.of(context).size.width / 8,
                  icon: FontAwesomeIcons.heart,
                  title: "",
                ),
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
