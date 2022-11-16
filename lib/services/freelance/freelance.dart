import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helpayr/services/widgets/header.dart';
import 'package:helpayr/services/widgets/title1.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FreeLanceHome extends StatefulWidget {
  const FreeLanceHome(
      {key,
      this.img_display_1,
      this.img_display_2,
      this.service_title,
      this.onTap});

  final String img_display_1;
  final String img_display_2;
  final Function onTap;
  final String service_title;

  @override
  State<FreeLanceHome> createState() => _FreeLanceHomeState();
}

class _FreeLanceHomeState extends State<FreeLanceHome> {
  int currentPage = 0;
  Timer _timer;
  PageController _ctrl = PageController(initialPage: 0);
  bool isFinal = false;

  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (currentPage < 1) {
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: PageView(
          allowImplicitScrolling: true,
          controller: _ctrl,
          onPageChanged: (index) {
            setState(() {
              isFinal = index == 1;
            });
          },
          children: [
            SingleChildScrollView(
              child: IntroductoryPage(
                bubble: false,
                isPage1: true,
                pageTitle: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: TitleWidget1(
                      isFirst: true,
                    )),
                onTap: widget.onTap,
                bgPhoto: widget.img_display_1,
              ),
            ),
            SingleChildScrollView(
              child: IntroductoryPage(
                bubble: true,
                pageTitle: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: TitleWidget1(
                      service_title: widget.service_title,
                      isFirst: false,
                    )),
                onTap: widget.onTap,
                bgPhoto: widget.img_display_2,
              ),
            ),
          ]),
      bottomSheet: Container(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SmoothPageIndicator(
              effect: const SlideEffect(
                  spacing: 16,
                  dotColor: Colors.white,
                  activeDotColor: Colors.blue,
                  dotHeight: 7,
                  dotWidth: 15),
              controller: _ctrl,
              count: 2,
              onDotClicked: ((index) => _ctrl.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut)),
            ),
          ],
        ),
      ),
    );
  }
}

class MainFreeLanceHomePage extends StatefulWidget {
  const MainFreeLanceHomePage({key});

  @override
  State<MainFreeLanceHomePage> createState() => _MainFreeLanceHomePageState();
}

class _MainFreeLanceHomePageState extends State<MainFreeLanceHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
