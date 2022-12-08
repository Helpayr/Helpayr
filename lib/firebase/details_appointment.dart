import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/Message/widgets/widget.dart';
import 'package:lottie/lottie.dart';

class DetailsBooking extends StatefulWidget {
  const DetailsBooking({
    key,
    this.details,
  });
  final Map<String, dynamic> details;

  @override
  State<DetailsBooking> createState() => _DetailsBookingState();
}

class _DetailsBookingState extends State<DetailsBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/imgs/onboarding-bg.png"),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 60, bottom: 60),
              child: Container(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  child: Column(
                    children: [
                      Container(
                        height: 10,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 12, 103, 179),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Booking Details",
                          style: GoogleFonts.raleway(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              height: 100,
                              width: 150,
                              child: Column(
                                children: [
                                  Text(
                                    "User",
                                    style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Avatar.small(
                                      url: FirebaseAuth
                                          .instance.currentUser.photoURL),
                                  Text(
                                    FirebaseAuth
                                        .instance.currentUser.displayName,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            child: LottieBuilder.network(
                                "https://assets4.lottiefiles.com/packages/lf20_bqUlAq.json"),
                          ),
                          Flexible(
                            child: Container(
                              height: 100,
                              width: 150,
                              child: Column(
                                children: [
                                  Text(
                                    'Service',
                                    style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Avatar.small(url: widget.details['dp']),
                                  Text(
                                    '${widget.details['full_name']}',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 150,
                        child: Swiper(
                            autoplay: true,
                            itemCount: widget.details['image'].length,
                            itemBuilder: ((context, index) => Card(
                                  elevation: 5,
                                  child: Container(
                                    height: 140,
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(widget
                                                .details['image'][index]))),
                                  ),
                                ))),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
