import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/screens/home.dart';
import 'package:helpayr/screens/messaging.dart';
import 'package:helpayr/screens/profile_maker.dart';
import 'package:helpayr/widgets/navbar.dart';
import 'package:lottie/lottie.dart';

class WhenCompleted extends StatefulWidget {
  const WhenCompleted({key});

  @override
  State<WhenCompleted> createState() => _WhenCompletedState();
}

class _WhenCompletedState extends State<WhenCompleted>
    with TickerProviderStateMixin {
  AnimationController _animationctrl;
  AnimationController _yes;

  @override
  void initState() {
    super.initState();
    _yes = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    _yes.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          showCalendar = true;
        });
      }
    });

    _animationctrl = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 20,
      ),
    );
    _animationctrl.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          isIntro = false;
        });
      }
    });
  }

  bool showCalendar = false;

  bool isIntro = true;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  int currentPage = 0;
  int selected = 0;
  List<String> days = [
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    List<Widget> screens = [
      Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/imgs/bluescreen.png")),
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 8, 62, 107).withOpacity(.9),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "My Appointments",
                            style: GoogleFonts.raleway(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: showCalendar ? 170 : 200,
                      child: Card(
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 10,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Cresilda Ibabao",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_right_alt,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 90,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: LottieBuilder.network(
                                          "https://assets2.lottiefiles.com/private_files/lf30_8ry7qrbu.json"),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "December 8",
                                            style: GoogleFonts.manrope(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "Morning",
                                            style: GoogleFonts.manrope(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "7:00AM",
                                            style: GoogleFonts.manrope(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            showCalendar
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Do You want to accept this appointment?",
                                          style: GoogleFonts.manrope(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                            showCalendar
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: ((context) => Dialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          LottieBuilder.network(
                                                            "https://assets4.lottiefiles.com/packages/lf20_3juvcrdk.json",
                                                            fit: BoxFit.fill,
                                                            repeat: false,
                                                            controller: _yes,
                                                            onLoaded: ((p0) {
                                                              return _yes
                                                                  .forward();
                                                            }),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            );
                                          },
                                          child: Card(
                                            elevation: 10,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("Yes"),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Card(
                                          elevation: 10,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("No"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    showCalendar
                        ? Column(
                            children: [
                              Text(
                                "Calendar",
                                style: GoogleFonts.raleway(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 170,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: ((context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selected = index;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: selected == index
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.7
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            color: selected == index
                                                ? Colors.blue
                                                : Colors.white,
                                            elevation:
                                                selected == index ? 10 : 5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: selected == index
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(days[index],
                                                        style:
                                                            GoogleFonts.manrope(
                                                          color: selected ==
                                                                  index
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                  ],
                                                ),
                                                Text(
                                                  "December ${index + 1}",
                                                  style: GoogleFonts.manrope(
                                                      color: selected == index
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize:
                                                          selected == index
                                                              ? 25
                                                              : 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  itemCount: 31,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            )),
      ]),
      Messaging(),
    ];

    return isIntro
        ? Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileMaker(),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Stack(children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/imgs/bluescreen.png")),
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(255, 8, 62, 107).withOpacity(.9),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LottieBuilder.network(
                          "https://assets8.lottiefiles.com/packages/lf20_JT7eJlHqgH.json",
                          controller: _animationctrl,
                          repeat: false,
                          onLoaded: ((p0) {
                            return _animationctrl.forward();
                          }),
                        ),
                        Text(
                          "Fetching Data from the Database.",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
              ]),
            ),
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: Navbar(
              title: "Dashboard",
              name: user.displayName,
              url: user.photoURL,
              greetings: true,
              isProfile: false,
            ),
            body: SingleChildScrollView(
              child: screens[currentPage],
            ),
            bottomSheet: CurvedNavigationBar(
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
          );
  }
}
