import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:helpayr/constants/Theme.dart';
import 'package:helpayr/constants/services_tentative.dart';
import 'package:helpayr/firebase/services_list_firebase.dart';
import 'package:helpayr/screens/settings.dart';
import 'package:helpayr/services/construction/home.dart';
import 'package:helpayr/services/construction/repair.dart';

//widgets
import 'package:helpayr/widgets/navbar.dart';
import 'package:helpayr/widgets/card-horizontal.dart';
import 'package:helpayr/widgets/drawer.dart';
import 'package:hidable/hidable.dart';

import '../Message/widgets/carousel.dart';
import '../firebase/List_data_page.dart';
import '../services/designing/list_services.dart';
import '../services/editing/editing_main.dart';
import '../services/foodandother/foodAndOther.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:helpayr/screens/product.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPage = 0;
  bool selected = false;

  int isSelected = 0;

  final user = FirebaseAuth.instance.currentUser;

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController(initialPage: 0);
  final ScrollController listviewctrl = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    listviewctrl.dispose();
    super.dispose();
  }

  List<String> header = [
    "Frequents",
    "Designing",
    "Multimedia",
  ];

  CurvedNavigationBar navbar() {
    return CurvedNavigationBar(
      onTap: (index) {
        setState(() {
          currentPage = index;
          selected = !selected;
        });
      },
      key: _bottomNavigationKey,
      index: 0,
      height: 55.0,
      items: <Widget>[
        bottomNavTiles(
          tileTitle: "Media",
          icon: Icons.play_arrow_outlined,
        ),
        bottomNavTiles(
          tileTitle: "Utility",
          icon: FontAwesomeIcons.tools,
        ),
        bottomNavTiles(
          tileTitle: "Food",
          icon: Icons.food_bank,
        ),
        bottomNavTiles(
          tileTitle: "Others",
          icon: Icons.music_note,
        ),
        bottomNavTiles(
          tileTitle: "Settings",
          icon: Icons.settings,
        ),
      ],
      color: Color.fromARGB(255, 12, 50, 68),
      buttonBackgroundColor: Color.fromARGB(255, 12, 50, 68),
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInToLinear,
      animationDuration: const Duration(milliseconds: 600),
      letIndexChange: (index) => true,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> service_screen = [
      Column(
        children: <Widget>[
          Carousel(pic: 'store_random_pic_service'),
          Text("Featured Stores",
              style: GoogleFonts.raleway(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          HelperList(
            isStore: true,
            isService: false,
            display_type: 'Store_Display',
            helper_type: 'Store',
            scrollController: listviewctrl,
          ),
          Container(
            height: 67,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected = index;
                    });
                    _pageController.animateToPage(index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 50),
                    curve: Curves.easeInCirc,
                    height: isSelected == index ? 67 : 65,
                    width: isSelected == index
                        ? MediaQuery.of(context).size.width / 2.6
                        : MediaQuery.of(context).size.width / 3.8,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: isSelected == index ? Colors.blue : Colors.white,
                      elevation: isSelected == index ? 10 : 3,
                      child: Padding(
                        padding: isSelected == index
                            ? const EdgeInsets.all(5)
                            : const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Flexible(
                            flex: 1,
                            child: SvgPicture.asset(
                              editor_img[index],
                              fit: BoxFit.fill,
                            ),
                          ),
                          isSelected == index
                              ? SizedBox(width: 3)
                              : SizedBox(
                                  width: 5,
                                ),
                          Flexible(
                            flex: 3,
                            child: Text(
                              header[index],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected == index
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: isSelected == index ? 13 : 8,
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1.8,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                HelperList(
                  isService: true,
                  display_type: 'Service_Display',
                  helper_type: 'Service',
                  scrollController: listviewctrl,
                ),
                Designing(),
                Editing(),
              ],
            ),
          )
        ],
      ),
      Column(
        children: [
          Repair(),
          Construction(),
        ],
      ),
      Column(
        children: <Widget>[
          Food(),
          Others(),
        ],
      ),
      Others(),
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Settings(
            isHome: false,
          ),
        ),
      ),
    ];
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: currentPage == 4
            ? null
            : Hidable(
                wOpacity: true,
                preferredWidgetSize: Size.fromHeight(195),
                controller: _scrollController,
                child: Navbar(
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
              ),
        backgroundColor: HelpayrColors.bgColorScreen,
        // key: _scaffoldKey,
        drawer: NowDrawer(currentPage: "Home"),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: service_screen[currentPage],
        ),
        bottomSheet: Hidable(
          controller: _scrollController,
          wOpacity: true,
          child: navbar(),
        ),
      ),
    );
  }
}

class bottomNavTiles extends StatelessWidget {
  const bottomNavTiles({
    Key key,
    this.icon,
    this.tileTitle,
  }) : super(key: key);

  final IconData icon;
  final String tileTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.white,
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              tileTitle,
              softWrap: true,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Baking extends StatelessWidget {
  const Baking({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: CardHorizontal(
          serviceType: "Baking",
          img: food_img[0],
          title: " Bakes and designs cakes for events.",
          cta: "See More",
          tap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListData(
                  isService: true,
                  userType: "Helpers",
                  service: "Service",
                  type: "Baking",
                ),
              ),
            );
          }),
    );
  }
}

class Photographer extends StatelessWidget {
  const Photographer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: CardHorizontal(
          isSvg: true,
          serviceType: "Photographer",
          img: editor_img[2],
          title: " Bakes and designs cakes for events.",
          cta: "See More",
          tap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListData(
                  isService: true,
                  userType: "Helpers",
                  service: "Service",
                  type: "Photographer",
                ),
              ),
            );
          }),
    );
  }
}
