import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpayr/screens/onboarding/onboarding.dart';

import '../screens/home.dart';

class HomePageGoogle extends StatelessWidget {
  const HomePageGoogle({Key key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return Home();
              } else {
                return Onboarding();
              }
            }),
      );
}
