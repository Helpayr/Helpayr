import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidable/hidable.dart';
import '../widgets/drawer.dart';
import '../widgets/navbar.dart';

class History extends StatefulWidget {
  const History({key});

  @override
  State<History> createState() => _HistoryState();
}

ScrollController _scrollController = ScrollController();

class _HistoryState extends State<History> {
  List<String> history_list = [];
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NowDrawer(currentPage: "History"),
      appBar: Hidable(
        wOpacity: true,
        preferredWidgetSize: Size.fromHeight(100),
        controller: _scrollController,
        child: Navbar(
          greetings: true,
          isProfile: false,
          name: user.displayName,
          url: user.photoURL,
          title: "History",
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "History",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .collection("History")
                    .snapshots(),
                builder: (context, snapshot) {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Container(
                                      child: Stack(children: [
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Success",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                      ]),
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(snapshot.data
                                                .docs[index]['servicer_dp'])),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(3, 0),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Column(
                                      children: [
                                        Text(
                                          '${snapshot.data.docs[index]['servicer']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${snapshot.data.docs[index]['service']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await FirebaseFirestore.instance
                                                .collection("Users")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser.uid)
                                                .collection("History")
                                                .get()
                                                .then((value) => value.docs
                                                        .forEach((element) {
                                                      history_list.add(
                                                          element.reference.id);
                                                    }));

                                            showDialog(
                                                context: context,
                                                builder: ((context) =>
                                                    AlertDialog(
                                                      actions: [
                                                        TextButton.icon(
                                                            onPressed:
                                                                () async {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "Users")
                                                                  .doc(FirebaseAuth
                                                                      .instance
                                                                      .currentUser
                                                                      .uid)
                                                                  .collection(
                                                                      "History")
                                                                  .doc(history_list[
                                                                      index])
                                                                  .delete();
                                                            },
                                                            icon: Icon(
                                                                Icons.check),
                                                            label: Text("Yes")),
                                                        TextButton.icon(
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            icon: Icon(
                                                                Icons.deselect),
                                                            label: Text("No"))
                                                      ],
                                                      title: Text(
                                                        "Delete Confirmation",
                                                        style:
                                                            GoogleFonts.raleway(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      content: Text(
                                                        "The selected history file will be permanently deleted. Proceed?",
                                                        style:
                                                            GoogleFonts.raleway(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                    )));
                                          },
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.trash,
                                                    color: Colors.red,
                                                  ),
                                                  Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          )
        ],
      ),
    );
  }
}
