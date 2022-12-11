import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignUpProvider extends ChangeNotifier {
  GoogleSignInAccount _user;

  GoogleSignInAccount get user => _user;
  List<String> users = [];
  List lis_login = [];

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

    final uid_docs = FirebaseAuth.instance.currentUser.uid;

    await FirebaseFirestore.instance.collection("Users").doc(uid_docs).set({
      "uid": FirebaseAuth.instance.currentUser.uid,
      "email": FirebaseAuth.instance.currentUser.email,
      "dp": FirebaseAuth.instance.currentUser.photoURL,
      "last_login": FirebaseAuth.instance.currentUser.metadata.lastSignInTime,
      "name": FirebaseAuth.instance.currentUser.displayName,
      "status_log": "Online",
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
    final uid_docs = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection("Helpers")
        .doc("People")
        .collection('Servicers')
        .doc(uid_docs)
        .set({
      "uid": FirebaseAuth.instance.currentUser.uid,
      "email": FirebaseAuth.instance.currentUser.email,
      "dp": FirebaseAuth.instance.currentUser.photoURL,
      "last_login": FirebaseAuth.instance.currentUser.metadata.lastSignInTime,
      "full_name": FirebaseAuth.instance.currentUser.displayName,
      "status_log": "Online",
    });
    notifyListeners();
  }

  Future googleLoginAdmin() async {
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
        .collection("Admin")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set(
      {
        "uid": FirebaseAuth.instance.currentUser.uid,
        "email": FirebaseAuth.instance.currentUser.email,
        "dp": FirebaseAuth.instance.currentUser.photoURL,
        "last_login": FirebaseAuth.instance.currentUser.metadata.lastSignInTime,
        "name": FirebaseAuth.instance.currentUser.displayName,
        "status_log": "Online",
      },
    );

    notifyListeners();
  }

  Future logout() async {
    FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
