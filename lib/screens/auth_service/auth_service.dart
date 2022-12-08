import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpayr/screens/when_complete.dart';

import '../onboarding/onboarding.dart';

class AuthService extends StatefulWidget {
  const AuthService({key});

  @override
  State<AuthService> createState() => _AuthServiceState();
}

class _AuthServiceState extends State<AuthService> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return WhenCompleted();
        } else if (snapshot.hasError) {
          return Text("Please try again!");
        } else {
          return Onboarding();
        }
      }),
    );
  }
}
