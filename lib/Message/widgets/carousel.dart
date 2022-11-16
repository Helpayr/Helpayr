import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Carousel extends StatefulWidget {
  const Carousel({
    this.pic,
  });

  @override
  State<Carousel> createState() => _CarouselState();

  final String pic;
}

class _CarouselState extends State<Carousel> {
  final user = FirebaseAuth.instance.currentUser;
  List<String> images = [];
  Future getImage() async {
    await FirebaseFirestore.instance
        .collection(widget.pic)
        .get()
        .then((value) => value.docs.forEach((element) {
              images.add(element.reference.id);
            }));
  }

  @override
  void initState() {
    getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImage(),
      builder: ((context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Showcarousel(
            pic: widget.pic,
            docId: images[1],
          ),
        );
      }),
    );
  }
}

class Showcarousel extends StatefulWidget {
  const Showcarousel({Key key, this.docId, this.pic});

  final String docId;
  final String pic;

  @override
  State<Showcarousel> createState() => _ShowcarouselState();
}

class _ShowcarouselState extends State<Showcarousel> {
  int currentPage = 0;

  Timer _timer;
  PageController _ctrl = PageController(initialPage: 0, viewportFraction: 0.7);

  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 15), (Timer timer) {
      if (currentPage < 38) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      _ctrl.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference images_carousel =
        FirebaseFirestore.instance.collection(widget.pic);
    return FutureBuilder<DocumentSnapshot>(
      future: images_carousel.doc(widget.docId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data.data() as Map<String, dynamic>;
          return AnimatedContainer(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 1000),
              height: 190,
              child: Swiper(
                autoplay: true,
                itemCount: data['images'].length,
                itemBuilder: (context, index) => Card_CArousel(data, index),
                viewportFraction: 0.9,
                scale: 1,
              ));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  Padding Card_CArousel(Map<String, dynamic> data, int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        elevation: 10,
        child: AnimatedContainer(
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 1000),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(data['images'][index]))),
        ),
      ),
    );
  }
}
