import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/firebase/getData.dart';
import 'package:lottie/lottie.dart';

class ListDataPage extends StatefulWidget {
  const ListDataPage({
    key,
    this.DocId,
    this.HelperType,
    this.UserType,
    this.Store_ServiceType,
    this.isAdmin = false,
    this.onDelete,
  });
  final String DocId;
  final String HelperType;
  final String Store_ServiceType;
  final String UserType;
  final Function onDelete;

  final bool isAdmin;
  @override
  State<ListDataPage> createState() => _ListDataPageState();
}

class _ListDataPageState extends State<ListDataPage> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance
        .collection(widget.UserType)
        .doc(widget.HelperType)
        .collection(widget.Store_ServiceType);
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.DocId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: 180,
              child: Card(
                elevation: 10,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: widget.isAdmin
                                ? Stack(children: [
                                    Positioned(
                                      right: 10,
                                      child: ElevatedButton.icon(
                                          style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(10),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                          ),
                                          onPressed: widget.onDelete,
                                          icon: Icon(
                                              Icons.delete_forever_rounded,
                                              color: Colors.red),
                                          label: Text(
                                            "Delete",
                                            style: GoogleFonts.raleway(
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ])
                                : Container(),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(2, 3),
                                    blurRadius: 5)
                              ],
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(data['bg']),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.6,
                              child: Text(
                                '${data['full_name']}',
                                style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3, color: Colors.white),
                                    color: data['status'] == "Online" &&
                                            data['status_log'] == "Online"
                                        ? Colors.green
                                        : data['status'] == "Online" &&
                                                data['status_log'] == "Offline"
                                            ? Colors.orange
                                            : data['status'] == "Offline" &&
                                                    data['status_log'] ==
                                                        "Online"
                                                ? Colors.yellow
                                                : data['status'] == "Offline" &&
                                                        data['status_log'] ==
                                                            "Offline"
                                                    ? Colors.grey
                                                    : Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              ]),
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(2, 3),
                                  blurRadius: 5)
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                data['dp'],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return LottieBuilder.network(
            "https://assets10.lottiefiles.com/packages/lf20_usmfx6bp.json");
      }),
    );
  }
}

class ListData extends StatefulWidget {
  const ListData({
    Key key,
    this.userType,
    this.service,
    this.type,
    this.isService,
    this.title,
    this.isAdmin = false,
    this.onDelete,
  });
  final String userType;
  final String service;
  final String type;
  final bool isService;
  final String title;
  final bool isAdmin;
  final Function onDelete;

  @override
  State<ListData> createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  ScrollController _scrollController;
  int isSelected = 0;

  final user = FirebaseAuth.instance.currentUser;
  List<String> helpers = [];
  Future getData() async {
    await FirebaseFirestore.instance
        .collection(widget.userType)
        .doc(widget.service)
        .collection(widget.type)
        .get()
        .then((value) => value.docs.forEach((element) {
              helpers.add(element.reference.id);
            }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: ((context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                      AssetImage('assets/onboarding new/bg_wavy_rotated.png')),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
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
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: helpers.length,
                      itemBuilder: ((context, index) => SingleChildScrollView(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected = index;
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GetData(
                                      isService: widget.isService,
                                      DocId: helpers[isSelected],
                                      UserType: widget.userType,
                                      HelperType: widget.service,
                                      StoreType: widget.type,
                                    ),
                                  ),
                                );
                              },
                              child: ListDataPage(
                                onDelete: () async {
                                  showDialog(
                                      context: context,
                                      builder: ((context) => AlertDialog(
                                            actions: [
                                              TextButton.icon(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            widget.userType)
                                                        .doc(widget.service)
                                                        .collection(widget.type)
                                                        .doc(helpers[index])
                                                        .delete()
                                                        .whenComplete(() {
                                                      Navigator.of(context)
                                                          .pop();
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
                                              "Delete Confirmation",
                                              style: GoogleFonts.raleway(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: Text(
                                              "The selected account will be permanently deleted. Proceed?",
                                              style: GoogleFonts.raleway(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          )));
                                },
                                isAdmin: widget.isAdmin,
                                UserType: widget.userType,
                                HelperType: widget.service,
                                Store_ServiceType: widget.type,
                                DocId: helpers[index],
                              ),
                            ),
                          ))),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
