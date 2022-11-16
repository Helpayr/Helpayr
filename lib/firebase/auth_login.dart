import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpayr/main.dart';
import 'package:helpayr/screens/home.dart';
import 'package:helpayr/screens/login.dart';
import 'package:helpayr/screens/onboarding/onboarding.dart';

class AuthPageSign extends StatelessWidget {
  AuthPageSign({Key key, this.isSignup = false});
  final bool isSignup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return isSignup
                ? noback(
                    wid: LoginPage(),
                  )
                : noback(wid: Home());
          } else {
            return Onboarding();
          }
        },
      ),
    );
  }
}
