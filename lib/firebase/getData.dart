import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/Message/pages/chatroom.dart';
import 'package:helpayr/Message/widgets/widget.dart';
import 'package:helpayr/firebase/details.dart';
import 'package:helpayr/firebase/products.dart';
import 'package:hidable/hidable.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../constants/Theme.dart';
import '../screens/home.dart';

final List<String> headerTitle = [
  "Details",
  "Products",
];

class GetData extends StatefulWidget {
  const GetData(
      {Key key,
      this.DocId,
      this.UserType,
      this.HelperType,
      this.StoreType,
      this.isService = false});

  final String DocId;
  final String HelperType;
  final String StoreType;
  final String UserType;
  final bool isService;

  @override
  State<GetData> createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  int currentPage = 0;
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance
        .collection(widget.UserType)
        .doc(widget.HelperType)
        .collection(widget.StoreType);
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.DocId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data.data() as Map<String, dynamic>;

          return widget.isService
              ? ServicePage(data, widget)
              : MainPageReturner(data: data, widget: widget);
        }
        return Scaffold(
          body: Container(
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }),
    );
  }
}

class ServicePage extends StatefulWidget {
  const ServicePage(
    this.data,
    this.widget,
  );

  final Map<String, dynamic> data;
  final GetData widget;

  @override
  State<ServicePage> createState() => _ServicePageState();
}

List<String> title = [
  "Works",
  "Ratings",
];
List<String> title_selected = [
  "Works and Products",
  "Ratings and Reviews",
];

List<IconData> icons = [
  FontAwesomeIcons.dollarSign,
  Icons.message,
  Icons.person,
];
final reviewEC = TextEditingController();
ScrollController _scroll = ScrollController();

class _ServicePageState extends State<ServicePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isPressed = false;
  int selected = 0;

  PageController _pagectrller = PageController(initialPage: 0);
  TextEditingController controller = TextEditingController();
  TextEditingController rating_number = TextEditingController();

  Future addReview(String service, String name) async {
    await FirebaseFirestore.instance
        .collection("Helpers")
        .doc("Service")
        .collection(service)
        .doc(name)
        .collection("Ratings")
        .add({
      "review": controller.text,
      "time": FieldValue.serverTimestamp(),
      "user": FirebaseAuth.instance.currentUser.displayName,
      "user_rating": double.parse(rating_number.text),
      "user_pic": FirebaseAuth.instance.currentUser.photoURL,
    });
  }

  @override
  void dispose() {
    controller;
    _pagectrller;
    rating_number;
    scaffoldKey;
    reviewEC;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                },
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              );
            },
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 1.1,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.5,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.data['bg'],
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(2, 4),
                            blurRadius: 35),
                      ],
                      borderRadius: isPressed
                          ? BorderRadius.only(
                              bottomLeft: Radius.circular(100),
                              bottomRight: Radius.circular(100),
                            )
                          : BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            )),
                ),
                Positioned(
                  left: isPressed ? 35 : 40,
                  top: 150,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isPressed = !isPressed;
                          });
                        },
                        child: AnimatedContainer(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 400),
                          height: isPressed ? 130 : 120,
                          width: isPressed
                              ? MediaQuery.of(context).size.width / 1.25
                              : MediaQuery.of(context).size.width / 1.3,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 15,
                            child: Row(
                              children: [
                                Flexible(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  widget.data['dp']))),
                                    )),
                                Flexible(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FittedBox(
                                          child: Text(
                                            '${widget.data['full_name']}',
                                            style: GoogleFonts.raleway(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          fit: BoxFit.fitWidth,
                                        ),
                                        Text(
                                            '${widget.data['job_profession']}'),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 90,
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DefaultTextStyle(
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.raleway(
                                color: Colors.black.withOpacity(.7),
                                fontWeight: FontWeight.bold,
                              ),
                              child: AnimatedTextKit(
                                  totalRepeatCount: 1,
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                        widget.data['Description'],
                                        speed: Duration(milliseconds: 100))
                                  ])),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 2.45,
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 85,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: title.length,
                              itemBuilder: ((context, index) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selected = index;
                                      });

                                      return _pagectrller.animateToPage(index,
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.easeInOut);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: AnimatedContainer(
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.easeInOut,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          height: 70,
                                          width: selected == index
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2
                                              : 150,
                                          child: Card(
                                            shadowColor: selected == index
                                                ? Colors.lightBlue
                                                : Colors.grey,
                                            elevation:
                                                selected == index ? 10 : 5,
                                            color: selected == index
                                                ? Colors.blue
                                                : Colors.white,
                                            child: selected == index
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: FittedBox(
                                                      fit: BoxFit.fitWidth,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            icons[index],
                                                            color: Colors.white,
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            title_selected[
                                                                index],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(icons[index]),
                                                          Text(title[index])
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                          )),
                                    ),
                                  ))),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 1.5,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: PageView(
                              controller: _pagectrller,
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              widget.data['image'].length,
                                          itemBuilder: ((context, index) =>
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.5,
                                                  height: 50,
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    color: Colors.white,
                                                    elevation: 10,
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Card(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            elevation: 10,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                image:
                                                                    DecorationImage(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  image:
                                                                      NetworkImage(
                                                                    widget.data[
                                                                            'image']
                                                                        [index],
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
                                              )),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: SizedBox(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      context: context,
                                                      builder: (context) =>
                                                          DraggableScrollableSheet(
                                                              initialChildSize:
                                                                  .40,
                                                              minChildSize: .20,
                                                              maxChildSize: 1,
                                                              builder: (context,
                                                                      myScroll) =>
                                                                  DetailsHelper(
                                                                    widget:
                                                                        widget,
                                                                  )));
                                                },
                                                child: Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "More Information",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    /* RatingBar.builder(
                                      initialRating: 3,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    */
                                    GestureDetector(
                                      onTap: () {
                                        /*Write_review();*/
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Show_reviews(context),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 2, color: Colors.blue),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Write and Read Real-time Reviews!",
                                              style: GoogleFonts.raleway(
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    LottieBuilder.network(
                                        "https://assets4.lottiefiles.com/packages/lf20_ao823ilv.json"),
                                  ],
                                ),
                              ],
                              physics: NeverScrollableScrollPhysics(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Scaffold Show_reviews(BuildContext context) {
    ScrollController _scroll = ScrollController();
    double total_review = 0;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Ratings and Reviews",
          style: GoogleFonts.raleway(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(3, 0),
                    blurRadius: 6,
                  ),
                ],
              ),
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 400),
              height: 150,
              width: MediaQuery.of(context).size.width / 1.3,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 15,
                child: Row(
                  children: [
                    Flexible(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(widget.data['dp']))),
                        )),
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              child: Text(
                                '${widget.data['full_name']}',
                                style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.bold),
                              ),
                              fit: BoxFit.fitWidth,
                            ),
                            Text('${widget.data['job_profession']}'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Helpers")
                      .doc("Service")
                      .collection(widget.data['job_profession'])
                      .doc(widget.data['full_name'])
                      .collection("Ratings")
                      .orderBy("time", descending: true)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scroll,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: ((context, index) {
                        total_review +=
                            snapshot.data.docs[index]['user_rating'];

                        DateTime lastLog =
                            (snapshot.data.docs[index]['time'].toDate());
                        String time_review =
                            DateFormat.yMMMd().add_jm().format(lastLog);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Card(
                                elevation: 10,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Avatar.medium(
                                                url: snapshot.data.docs[index]
                                                    ['user_pic']),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${snapshot.data.docs[index]['user']}',
                                                  style: GoogleFonts.raleway(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                RatingBarIndicator(
                                                  rating:
                                                      snapshot.data.docs[index]
                                                          ['user_rating'],
                                                  itemBuilder:
                                                      (context, index) => Icon(
                                                    Icons.star,
                                                    color: Colors.blue,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 20.0,
                                                  direction: Axis.horizontal,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              '${time_review}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 15),
                                      child: Text(
                                        '${snapshot.data.docs[index]['review']}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      }),
                    );
                  })),
            ),
          ],
        ),
      ),
      bottomSheet: Hidable(
        controller: _scroll,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(3, 0),
                blurRadius: 6,
              ),
            ],
          ),
          child: ElevatedButton(
              onPressed: () {
                Write_review().whenComplete(() {
                  Navigator.of(context).pop();
                });
              },
              child: Text(
                "Write a review",
                style: GoogleFonts.raleway(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }

  Future<dynamic> Write_review() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: scaffoldKey.currentContext,
      builder: (context) => DraggableScrollableSheet(
        snap: false,
        initialChildSize: .90,
        minChildSize: .30,
        maxChildSize: .90,
        builder: (context, myScroll) => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Write Reviews",
                      style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AnimatedContainer(
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 400),
                      height: 120,
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 15,
                        child: Row(
                          children: [
                            Flexible(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image:
                                              NetworkImage(widget.data['dp']))),
                                )),
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        '${widget.data['full_name']}',
                                        style: GoogleFonts.raleway(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      fit: BoxFit.fitWidth,
                                    ),
                                    Text('${widget.data['job_profession']}'),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: Row(
                        children: [
                          Text(
                            "Write your Review",
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 130,
                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(3, 0),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: TextField(
                        style: GoogleFonts.raleway(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 18),
                        maxLines: 4,
                        textAlign: TextAlign.center,
                        controller: controller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "   Write a review for this service :)"),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RatingBarIndicator(
                      rating: 5,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.blue,
                      ),
                      itemCount: 5,
                      itemSize: 30.0,
                      direction: Axis.horizontal,
                    ),
                    Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(3, 0),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: TextField(
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: rating_number,
                        decoration: InputDecoration(
                          hintText: "1-5",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Row(
                        children: [
                          Text(
                            "Works",
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 190,
                      child: Swiper(
                          autoplay: true,
                          itemCount: widget.data['image'].length,
                          itemBuilder: ((context, index) => Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 5,
                                child: Container(
                                  height: 140,
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              widget.data['image'][index]))),
                                ),
                              ))),
                    ),
                  ],
                )),
          ),
          bottomSheet: GestureDetector(
            onTap: () {
              addReview(
                  widget.data['job_profession'], widget.data['full_name']);
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(3, 0),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Submit",
                    style: GoogleFonts.raleway(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class Field extends StatelessWidget {
  const Field({
    Key key,
    @required this.widget,
    this.icon,
    this.field,
  }) : super(key: key);

  final String field;
  final IconData icon;
  final ServicePage widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 15,
                color: Colors.white,
                shadows: [Shadow(color: Colors.grey, offset: Offset(2, 3))],
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              '${widget.data[field]}',
              style: TextStyle(
                shadows: [
                  Shadow(
                      color: Colors.black.withOpacity(.7),
                      offset: Offset(2, 3),
                      blurRadius: 5),
                ],
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MainPageReturner extends StatefulWidget {
  const MainPageReturner({
    Key key,
    @required this.data,
    @required this.widget,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final GetData widget;

  @override
  State<MainPageReturner> createState() => _MainPageReturnerState();
}

class _MainPageReturnerState extends State<MainPageReturner> {
  int product_isSelected = 0;
  bool product_selected = true;
  bool rev_selected = false;

  PageController _pageController = PageController(initialPage: 0);
  ScrollController _scrollController;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    }
    return "$user2$user1";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2.8,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          colorFilter: ColorFilter.linearToSrgbGamma(),
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            widget.data['bg'],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 2.8,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent.withOpacity(.9),
                          Colors.blueAccent.withOpacity(.8),
                          Colors.blueAccent.withOpacity(.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      )),
                    ),
                    Positioned(
                      top: 55,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 4,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child:
                                          Text('${widget.data['store_name']}',
                                              style: GoogleFonts.raleway(
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black,
                                                      offset: Offset(2, 2),
                                                    )
                                                  ],
                                                  fontSize: 25,
                                                  color: HelpayrColors.white)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 3,
                                                  color: Colors.white),
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  widget.data['dp'],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Info(
                                                icon: Icons.person,
                                                data: widget.data,
                                                field: 'full_name',
                                              ),
                                              Info(
                                                icon: Icons.directions,
                                                data: widget.data,
                                                field: 'Address',
                                              ),
                                              Info(
                                                data: widget.data,
                                                icon: Icons.calendar_month,
                                                field: 'avail',
                                              ),
                                              Info(
                                                data: widget.data,
                                                icon: FontAwesomeIcons.facebook,
                                                field: 'fb',
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ElevatedButtonStore(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    icon: FontAwesomeIcons.check,
                                    title: "Set Appointments",
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Chatroom(
                                            recipient: widget.data,
                                            chatroomId: chatRoomId(
                                                FirebaseAuth.instance
                                                    .currentUser.displayName,
                                                widget.data['full_name']),
                                          ),
                                        ),
                                      );
                                    },
                                    child: ElevatedButtonStore(
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      icon: Icons.message,
                                      title: "Chat",
                                    ),
                                  ),
                                  ElevatedButtonStore(
                                    width:
                                        MediaQuery.of(context).size.width / 8,
                                    icon: FontAwesomeIcons.heart,
                                    title: "",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            HeaderTitle(
                              title: "Description",
                              isProduct: false,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DefaultTextStyle(
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      TypewriterAnimatedText(
                                        '${widget.data['Description']}',
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                    totalRepeatCount: 1,
                                  ),
                                  style: GoogleFonts.raleway(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.linear,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          product_selected = true;
                                          rev_selected = false;
                                        });
                                        _pageController.animateToPage(0,
                                            duration:
                                                Duration(milliseconds: 200),
                                            curve: Curves.easeInOut);
                                      },
                                      child: Text(
                                        "Products",
                                        style: GoogleFonts.racingSansOne(
                                            color: product_selected
                                                ? HelpayrColors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 20,
                                            shadows: [
                                              Shadow(
                                                color: product_selected
                                                    ? Colors.black
                                                    : Colors.white,
                                                offset: Offset(2, 2),
                                              )
                                            ]),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          rev_selected = true;
                                          product_selected = false;
                                        });
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) =>
                                                DraggableScrollableSheet(
                                                  initialChildSize: .80,
                                                  minChildSize: .20,
                                                  maxChildSize: 1,
                                                  builder:
                                                      (context, myScroll) =>
                                                          ProductViewAll(
                                                    widget: widget,
                                                  ),
                                                ));
                                      },
                                      child: Text(
                                        "See All",
                                        style: GoogleFonts.racingSansOne(
                                            color: rev_selected
                                                ? HelpayrColors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 20,
                                            shadows: [
                                              Shadow(
                                                color: rev_selected
                                                    ? Colors.black
                                                    : Colors.white,
                                                offset: Offset(2, 2),
                                              )
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              height: 35,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  end: rev_selected
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  begin: rev_selected
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  colors: [
                                    Colors.blueAccent,
                                    Colors.blue,
                                    Colors.blueAccent.withOpacity(.7),
                                    Colors.blueAccent.withOpacity(.4),
                                    Colors.blueAccent.withOpacity(.1),
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width,
                              child: PageView(
                                  controller: _pageController,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: ListView.builder(
                                          controller: _scrollController,
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              widget.data['image'].length,
                                          itemBuilder: ((context, index) =>
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Card(
                                                  elevation: 10,
                                                  child: AnimatedContainer(
                                                    curve: Curves.easeInOut,
                                                    duration: Duration(
                                                        milliseconds: 200),
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            4.4,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Row(children: [
                                                        Flexible(
                                                          flex: 1,
                                                          child:
                                                              AnimatedContainer(
                                                            curve: Curves
                                                                .easeInOut,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    200),
                                                            width: 200,
                                                            height: 180,
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    image: DecorationImage(
                                                                        fit: BoxFit.fill,
                                                                        image: NetworkImage(
                                                                          widget.data['image']
                                                                              [
                                                                              index],
                                                                        ))),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border:
                                                                            Border(
                                                                  bottom:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.5,
                                                                  ),
                                                                )),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  child: Text(
                                                                    '${widget.data['product_name'][index]}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts.montserrat(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                'Php. ${widget.data['prices'][index]}',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ]),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.transparent,
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({
    Key key,
    this.title,
    this.isProduct = false,
  }) : super(key: key);

  final bool isProduct;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent,
            Colors.blue,
            Colors.blueAccent.withOpacity(.7),
            Colors.blueAccent.withOpacity(.4),
            Colors.blueAccent.withOpacity(.1),
            Colors.transparent,
            Colors.transparent,
            Colors.transparent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30),
        child: Row(
          mainAxisAlignment: isProduct
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          children: isProduct
              ? [
                  Text(
                    title,
                    style: GoogleFonts.racingSansOne(
                        color: HelpayrColors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(2, 2),
                          )
                        ]),
                  ),
                ]
              : [
                  Text(
                    title,
                    style: GoogleFonts.racingSansOne(
                        color: HelpayrColors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(2, 2),
                          )
                        ]),
                  ),
                  Container(
                    height: 25,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.blue),
                    ),
                    child: Center(
                        child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Read More",
                          style: TextStyle(
                            color: HelpayrColors.info,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                  )
                ],
        ),
      ),
    );
  }
}

class ElevatedButtonStore extends StatefulWidget {
  const ElevatedButtonStore({
    Key key,
    this.width,
    this.icon,
    this.title,
    this.isHeart = false,
  }) : super(key: key);

  final IconData icon;
  final bool isHeart;
  final String title;
  final double width;

  @override
  State<ElevatedButtonStore> createState() => _ElevatedButtonStoreState();
}

class _ElevatedButtonStoreState extends State<ElevatedButtonStore> {
  bool isElevated = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: widget.width,
        height: 40,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black, offset: Offset(2, 3))],
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.isHeart
              ? Icon(
                  widget.icon,
                  color: Colors.white,
                )
              : [
                  Icon(
                    widget.icon,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    Key key,
    @required this.data,
    this.field,
    this.icon,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final String field;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          '${data[field]}',
          style: GoogleFonts.raleway(
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.blue,
                offset: Offset(2, 2),
              )
            ],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class Products extends StatelessWidget {
  const Products({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data['image'].length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 250,
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          data['image'][index],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
