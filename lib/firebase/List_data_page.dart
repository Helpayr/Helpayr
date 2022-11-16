import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/firebase/getData.dart';
import 'package:helpayr/widgets/navbar.dart';

class ListDataPage extends StatefulWidget {
  const ListDataPage({
    key,
    this.DocId,
    this.HelperType,
    this.UserType,
    this.Store_ServiceType,
  });
  final String DocId;
  final String HelperType;
  final String Store_ServiceType;
  final String UserType;

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
              height: 200,
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
                          height: 100,
                          width: 100,
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
        return Text("Loading");
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
  });
  final String userType;
  final String service;
  final String type;
  final bool isService;

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
    getData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: ((context, snapshot) => Scaffold(
            appBar: Navbar(
              greetings: true,
              isProfile: false,
              name: user.displayName,
              url: user.photoURL,
              title: "Home",
              searchBar: true,
              isOnSearch: true,
              category1_icon: FontAwesomeIcons.arrowUp,
              category2_icon: FontAwesomeIcons.heart,
              categoryOne: "Trending",
              categoryTwo: "Favorites",
            ),
            backgroundColor: Colors.white,
            body: ListView.builder(
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
                          UserType: widget.userType,
                          HelperType: widget.service,
                          Store_ServiceType: widget.type,
                          DocId: helpers[index],
                        ),
                      ),
                    ))),
          )),
    );
  }
}
