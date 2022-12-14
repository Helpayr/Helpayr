import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class GetUsers_Info extends StatefulWidget {
  const GetUsers_Info({
    key,
    this.docId,
    this.onDelete,
  });
  final String docId;
  final Function onDelete;

  @override
  State<GetUsers_Info> createState() => _GetUsers_InfoState();
}

class _GetUsers_InfoState extends State<GetUsers_Info> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users_info =
        FirebaseFirestore.instance.collection("Users");

    return FutureBuilder(
      future: users_info.doc(widget.docId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data.data() as Map<String, dynamic>;

          DateTime lastLog = (data['last_login'].toDate());
          String lastLog_new = DateFormat.yMMMd().add_jm().format(lastLog);

          return User_info(
              data: data, lastLog_new: lastLog_new, widget: widget);
        }
        return Container(child: Center(child: CircularProgressIndicator()));
      }),
    );
  }
}

class User_info extends StatelessWidget {
  const User_info({
    Key key,
    @required this.data,
    @required this.lastLog_new,
    @required this.widget,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final String lastLog_new;
  final GetUsers_Info widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.35,
                height: 110,
                child: Card(
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['full_name'],
                                        style: GoogleFonts.raleway(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        data['email'],
                                        style: GoogleFonts.raleway(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Last sign in: ${lastLog_new} ',
                                        style: GoogleFonts.raleway(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.edit_note_rounded,
                                color: Colors.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: widget.onDelete,
                                child: Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 1,
              top: 30,
              child: Container(
                  child: Stack(
                    children: [
                      Positioned(
                        right: 15,
                        bottom: 5,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.5, color: Colors.white),
                            shape: BoxShape.circle,
                            color: data['status'] == "Online" &&
                                    data['status_log'] == "Online"
                                ? Colors.green
                                : data['status'] == "Online" &&
                                        data['status_log'] == "Offline"
                                    ? Colors.orange
                                    : data['status'] == "Offline" &&
                                            data['status_log'] == "Online"
                                        ? Colors.yellow
                                        : data['status'] == "Offline" &&
                                                data['status_log'] == "Offline"
                                            ? Colors.grey
                                            : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  width: 120,
                  height: 90,
                  decoration: BoxDecoration(
                      border: Border.all(width: 3, color: Colors.white),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill, image: NetworkImage(data['dp'])))),
            ),
          ],
        ),
      ),
    );
  }
}

class User_info_onSearch extends StatelessWidget {
  const User_info_onSearch({
    Key key,
    @required this.data,
    this.onDelete,
  }) : super(key: key);

  final Map<String, dynamic> data;

  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.4,
                height: 110,
                child: Card(
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data['name'],
                                  style: GoogleFonts.raleway(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  data['email'],
                                  style: GoogleFonts.raleway(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.edit_note_rounded,
                                color: Colors.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: onDelete,
                                child: Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 10,
              child: Container(
                  width: 120,
                  height: 90,
                  decoration: BoxDecoration(
                      border: Border.all(width: 3, color: Colors.white),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill, image: NetworkImage(data['dp'])))),
            ),
          ],
        ),
      ),
    );
  }
}
