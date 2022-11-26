import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Admin_Dashboard extends StatefulWidget {
  const Admin_Dashboard({key});

  @override
  State<Admin_Dashboard> createState() => _Admin_DashboardState();
}

class _Admin_DashboardState extends State<Admin_Dashboard> {
  final user = FirebaseAuth.instance.currentUser;

  Future getCredentials() async {}

  List<String> header = [
    "Overview",
    "Graph",
    "Details",
    "More",
  ];
  int header_selected = 0;
  PageController pagectrl = PageController(initialPage: 0);
  @override
  void dispose() {
    pagectrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Dashboard",
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          leading: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                children: [
                  Text(
                    user.displayName,
                    style: GoogleFonts.raleway(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: GoogleFonts.raleway(
                      color: Colors.black,
                      fontSize: 5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: header.length,
                    itemBuilder: ((context, index) => GestureDetector(
                          onTap: (() {
                            setState(() {
                              header_selected = index;
                            });
                            return pagectrl.animateToPage(index,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          }),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: AnimatedContainer(
                              width: header_selected == index
                                  ? MediaQuery.of(context).size.width / 2
                                  : MediaQuery.of(context).size.width / 2.5,
                              duration: Duration(milliseconds: 200),
                              child: Card(
                                elevation: header_selected == index ? 5 : 2,
                                shadowColor: header_selected == index
                                    ? Colors.blueAccent
                                    : Colors.white,
                                color: header_selected == index
                                    ? Colors.blueAccent
                                    : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/designing/graphic",
                                        fit: BoxFit.fill,
                                        width: 20,
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        header[index],
                                        style: GoogleFonts.raleway(
                                          fontWeight: header_selected == index
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: header_selected == index
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: PageView(
                  controller: pagectrl,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      color: Colors.blue,
                    ),
                    Container(
                      color: Colors.red,
                    ),
                    Container(
                      color: Colors.green,
                    ),
                    Container(
                      color: Colors.pink,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
