import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpayr/widgets/drawer.dart';

import '../Message/widgets/carousel.dart';
import '../constants/Theme.dart';
import '../firebase/services_list_firebase.dart';
import '../widgets/navbar.dart';

class Stores extends StatefulWidget {
  const Stores({Key key});

  @override
  State<Stores> createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  final user = FirebaseAuth.instance.currentUser;
  ScrollController _scrollController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HelpayrColors.bgColorScreen,
      appBar: Navbar(
        greetings: true,
        isProfile: false,
        name: user.displayName,
        url: user.photoURL,
        title: "Stores",
        searchBar: true,
        isOnSearch: true,
      ),
      drawer: NowDrawer(
        currentPage: "Stores",
      ),
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height * 2,
        child: Column(
          children: [
            Carousel(pic: 'store_random_pic_store'),
            Expanded(
              child: HelperList(
                scrollController: _scrollController,
                display_type: 'Store_Display',
                helper_type: 'Store',
                isService: false,
              ),
            )
          ],
        ),
      )),
    );
  }
}
