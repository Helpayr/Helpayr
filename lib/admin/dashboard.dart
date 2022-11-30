import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/admin/getData_admin.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

import '../screens/home.dart';

class Admin_Dashboard extends StatefulWidget {
  const Admin_Dashboard({key});

  @override
  State<Admin_Dashboard> createState() => _Admin_DashboardState();
}

class _Admin_DashboardState extends State<Admin_Dashboard> {
  TextEditingController textController = TextEditingController();
  List<AdminData> admin_data_pass;
  TooltipBehavior _tooltipBehavior;
  final user = FirebaseAuth.instance.currentUser;
  List<String> users = [];
  List<String> services = [];
  List<String> stores = [];

  Future getUsers() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .orderBy("last_login", descending: true)
        .get()
        .then((value) => value.docs.forEach((element) {
              users.add(element.reference.id);
            }));
    await FirebaseFirestore.instance
        .collection("Service_Display")
        .get()
        .then((value) => value.docs.forEach((element) {
              services.add(element.reference.id);
            }));
  }

  Future getStores() async {
    await FirebaseFirestore.instance
        .collection("Store_Display")
        .get()
        .then((value) => value.docs.forEach((element) {
              stores.add(element.reference.id);
            }));
  }

  @override
  void initState() {
    getUsers();
    getStores();
    _tooltipBehavior = TooltipBehavior(enable: true, elevation: 5);

    super.initState();
  }

  List<String> header = [
    "Overview",
    "Graph",
    "Details",
    "More",
  ];
  int header_selected = 0;
  final ScrollController _scrollController = ScrollController();
  PageController pagectrl = PageController(initialPage: 0);
  PageController pagectrl_graph = PageController(initialPage: 0);
  String header_appBar = "";
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  void dispose() {
    pagectrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  int currentPage = 0;
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    List<AdminData> getUserdata() {
      final List<AdminData> admin_data = [
        AdminData("Initial", 0),
        AdminData("", 2),
        AdminData("Updated", users.length),
      ];
      return admin_data;
    }

    List<AdminData> getServicedata() {
      final List<AdminData> admin_data = [
        AdminData("Initial", 0),
        AdminData("", 2),
        AdminData("Updated", services.length),
      ];
      return admin_data;
    }

    List<AdminData> getstorecedata() {
      final List<AdminData> admin_data = [
        AdminData("Initial", 0),
        AdminData("", 2),
        AdminData("Updated", stores.length),
      ];
      return admin_data;
    }

    return SafeArea(
        child: Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        title: Column(
          children: [
            Text(
              "Dashboard",
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              header_appBar,
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 12,
              ),
            )
          ],
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: header.length,
                    itemBuilder: ((context, int) => GestureDetector(
                          onTap: (() {
                            setState(() {
                              header_selected = int;
                              header_appBar = header[int];
                            });
                            return pagectrl.animateToPage(int,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          }),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: AnimatedContainer(
                              width: header_selected == int
                                  ? MediaQuery.of(context).size.width / 2.8
                                  : MediaQuery.of(context).size.width / 3,
                              duration: Duration(milliseconds: 200),
                              child: Card(
                                elevation: header_selected == int ? 5 : 2,
                                shadowColor: header_selected == int
                                    ? Colors.blueAccent
                                    : Colors.white,
                                color: header_selected == int
                                    ? Colors.blueAccent
                                    : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          header[int],
                                          style: GoogleFonts.raleway(
                                            fontWeight: header_selected == int
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: header_selected == int
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
                          ),
                        ))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: PageView(
                onPageChanged: (int) {
                  setState(() {
                    header_selected = int;
                  });
                },
                controller: pagectrl,
                children: [
                  Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => DraggableScrollableSheet(
                                  snap: false,
                                  initialChildSize: .90,
                                  minChildSize: .50,
                                  maxChildSize: 1,
                                  builder: (context, myScroll) => Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(24),
                                              topRight: Radius.circular(24),
                                            ),
                                          ),
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 90,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(24),
                                                    bottomRight:
                                                        Radius.circular(24),
                                                  ),
                                                  color: Colors.black,
                                                ),
                                              ),
                                              AnimSearchBar(
                                                width: 400,
                                                textController: textController,
                                                onSuffixTap: () {
                                                  setState(() {
                                                    textController.clear();
                                                  });
                                                },
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                    controller:
                                                        _scrollController,
                                                    itemCount: users.length,
                                                    itemBuilder:
                                                        ((context, index) {
                                                      return GetUsers_Info(
                                                        docId: users[index],
                                                      );
                                                    })),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                            );
                          },
                          child: User(users: users),
                        ),
                        Services(services: services),
                        Stores(stores: stores),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isClicked = !isClicked;
                            });
                            isClicked
                                ? pagectrl_graph.animateTo(1,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease)
                                : pagectrl_graph.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease);
                          },
                          child: Container(
                            width: 130,
                            height: 45,
                            child: Card(
                              child: Row(
                                mainAxisAlignment: isClicked
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    width: 70,
                                    height: 40,
                                    child: Card(
                                      child: Center(
                                        child: isClicked
                                            ? Text(
                                                "Area",
                                                style: GoogleFonts.raleway(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                "Line",
                                                style: GoogleFonts.raleway(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                      ),
                                      elevation: 4,
                                      color: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Data Visualization",
                            style: GoogleFonts.raleway(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 12.0,
                                    left: 12.0,
                                    right: 20.0,
                                    top: 20),
                                child: PageView(
                                    physics: NeverScrollableScrollPhysics(),
                                    controller: pagectrl_graph,
                                    children: [
                                      SfCartesianChart(
                                        tooltipBehavior: _tooltipBehavior,
                                        legend: Legend(
                                            isVisible: true,
                                            textStyle: GoogleFonts.raleway(
                                                fontWeight: FontWeight.bold),
                                            position: LegendPosition.bottom,
                                            alignment: ChartAlignment.center),
                                        series: <ChartSeries>[
                                          StackedAreaSeries<AdminData, String>(
                                            name: "Users",
                                            dataSource: getUserdata(),
                                            xValueMapper: (AdminData data, _) {
                                              return data.category;
                                            },
                                            yValueMapper: (AdminData data, _) {
                                              return data.updated;
                                            },
                                          ),
                                          StackedAreaSeries<AdminData, String>(
                                            name: "Services",
                                            dataSource: getServicedata(),
                                            xValueMapper: (AdminData data, _) {
                                              return data.category;
                                            },
                                            yValueMapper: (AdminData data, _) {
                                              return data.updated;
                                            },
                                          ),
                                          StackedAreaSeries<AdminData, String>(
                                            name: "Stores",
                                            dataSource: getstorecedata(),
                                            xValueMapper: (AdminData data, _) {
                                              return data.category;
                                            },
                                            yValueMapper: (AdminData data, _) {
                                              return data.updated;
                                            },
                                          ),
                                        ],
                                        primaryXAxis: CategoryAxis(),
                                      ),
                                      SfCartesianChart(
                                        tooltipBehavior: _tooltipBehavior,
                                        legend: Legend(
                                            textStyle: GoogleFonts.raleway(
                                                fontWeight: FontWeight.bold),
                                            isVisible: true,
                                            position: LegendPosition.bottom,
                                            alignment: ChartAlignment.center),
                                        series: <ChartSeries>[
                                          StackedLineSeries<AdminData, String>(
                                            name: "Users",
                                            dataSource: getUserdata(),
                                            xValueMapper: (AdminData data, _) {
                                              return data.category;
                                            },
                                            yValueMapper: (AdminData data, _) {
                                              return data.updated;
                                            },
                                          ),
                                          StackedLineSeries<AdminData, String>(
                                            name: "Services",
                                            dataSource: getServicedata(),
                                            xValueMapper: (AdminData data, _) {
                                              return data.category;
                                            },
                                            yValueMapper: (AdminData data, _) {
                                              return data.updated;
                                            },
                                          ),
                                          StackedLineSeries<AdminData, String>(
                                            name: "Stores",
                                            dataSource: getstorecedata(),
                                            xValueMapper: (AdminData data, _) {
                                              return data.category;
                                            },
                                            yValueMapper: (AdminData data, _) {
                                              return data.updated;
                                            },
                                          ),
                                        ],
                                        primaryXAxis: CategoryAxis(),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        key: _bottomNavigationKey,
        index: 0,
        height: 55.0,
        items: [
          bottomNavTiles(
            tileTitle: "Home",
            icon: Icons.home,
          ),
          bottomNavTiles(
            tileTitle: "Message",
            icon: Icons.message,
          ),
        ],
        color: Color.fromARGB(255, 12, 50, 68),
        buttonBackgroundColor: Color.fromARGB(255, 12, 50, 68),
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInToLinear,
        animationDuration: const Duration(milliseconds: 600),
        letIndexChange: (index) => true,
      ),
    ));
  }
}

class Stores extends StatelessWidget {
  const Stores({
    Key key,
    @required this.stores,
  }) : super(key: key);

  final List<String> stores;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${stores.length}',
                    style: GoogleFonts.raleway(
                        fontSize: 50,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Stores Registered',
                    style: GoogleFonts.raleway(
                        fontSize: 15,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                height: 70,
                width: 70,
                child: Center(
                  child: Icon(
                    Icons.store,
                    color: Colors.orange,
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.orangeAccent),
                    color: Colors.orangeAccent.withOpacity(.4),
                    shape: BoxShape.circle),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Services extends StatelessWidget {
  const Services({
    Key key,
    @required this.services,
  }) : super(key: key);

  final List<String> services;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 70,
                width: 70,
                child: Center(
                  child: Icon(
                    Icons.work,
                    color: Colors.deepPurple,
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 4,
                      color: Colors.deepPurple,
                    ),
                    color: Colors.deepPurple.withOpacity(.4),
                    shape: BoxShape.circle),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${services.length}',
                    style: GoogleFonts.raleway(
                        fontSize: 50,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Services Registered',
                    style: GoogleFonts.raleway(
                        fontSize: 15,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class User extends StatelessWidget {
  const User({
    Key key,
    @required this.users,
  }) : super(key: key);

  final List<String> users;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${users.length}',
                    style: GoogleFonts.raleway(
                        fontSize: 50,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Users Registered',
                    style: GoogleFonts.raleway(
                        fontSize: 15,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                height: 70,
                width: 70,
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.user,
                    color: Colors.blueAccent,
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.blueAccent),
                    color: Colors.blue.withOpacity(.4),
                    shape: BoxShape.circle),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AdminData {
  final String category;

  final int updated;

  AdminData(
    this.category,
    this.updated,
  );
}
