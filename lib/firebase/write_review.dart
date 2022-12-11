import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/firebase/getData.dart';

class Write_Review extends StatefulWidget {
  const Write_Review({key, this.data});

  final ServicePage data;

  @override
  State<Write_Review> createState() => _Write_ReviewState();
}

class _Write_ReviewState extends State<Write_Review> {
  TextEditingController controller;
  TextEditingController rating_number;
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
      "user_rating": rating_number.text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              height: 10,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 400),
              height: 120,
              width: MediaQuery.of(context).size.width / 1.1,
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
                                  image: NetworkImage(widget.data.data['dp']))),
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
                                '${widget.data.data['full_name']}',
                                style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.bold),
                              ),
                              fit: BoxFit.fitWidth,
                            ),
                            Text('${widget.data.data['job_profession']}'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Text(
                    "Write your Review",
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 90,
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: Colors.black),
              ),
              child: AutoSizeTextField(
                minFontSize: 18,
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
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 2, color: Colors.black),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: rating_number,
                decoration: InputDecoration(
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
                  itemCount: widget.data.data['image'].length,
                  itemBuilder: ((context, index) => Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                        child: Container(
                          height: 140,
                          width: MediaQuery.of(context).size.width / 1.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      widget.data.data['image'][index]))),
                        ),
                      ))),
            ),
            ElevatedButton(
              onPressed: () {
                addReview(widget.data.data['job_profession'],
                    widget.data.data['full_name']);
              },
              child: Text("Submit"),
            ),
          ],
        )),
      ),
    );
  }
}
