import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignUpProvider extends ChangeNotifier {
  GoogleSignInAccount _user;

  GoogleSignInAccount get user => _user;

  Future googleLoginUser() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    await FirebaseFirestore.instance.collection("Users").add({
      "uid": FirebaseAuth.instance.currentUser.uid,
      "email": FirebaseAuth.instance.currentUser.email,
    });
    notifyListeners();
  }

  Future googleLoginHelper() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    await FirebaseFirestore.instance
        .collection("Helpers")
        .doc("People")
        .collection('Servicers')
        .add({
      "uid": FirebaseAuth.instance.currentUser.uid,
      "email": FirebaseAuth.instance.currentUser.email,
    });
    notifyListeners();
  }

  Future logout() async {
    FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
