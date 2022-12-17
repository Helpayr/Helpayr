import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/constants/services_tentative.dart';

import '../constants/Theme.dart';
import 'home.dart';

class signUpContext extends StatefulWidget {
  const signUpContext({
    Key key,
    this.controller,
  }) : super(key: key);
  final ScrollController controller;

  @override
  State<signUpContext> createState() => _signUpContextState();
}

class _signUpContextState extends State<signUpContext> {
  PlatformFile pickedfile;
  UploadTask upload;
  final _emailController = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  final _firstnameEC = TextEditingController();
  final _lastNameEC = TextEditingController();
  bool isElevated = false;
  String profile_picUrl = "";
  bool isSaved = false;

  Future selectImage() async {
    final res_image = await FilePicker.platform.pickFiles();

    setState(() {
      pickedfile = res_image.files.first;
    });
  }

  Future uploadImage() async {
    final path = 'Profile_Pictures/ ${pickedfile.name}';
    final file = File(pickedfile.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      upload = ref.putFile(file);
    });
    await ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        profile_picUrl = value;
      });
    });
    setState(() {
      isSaved = true;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pass.dispose();
    _confirm.dispose();
    _firstnameEC.dispose();
    _lastNameEC.dispose();

    super.dispose();
  }

  Future signUp() async {
    if (passwordConfirmValid != null) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(), password: _pass.text.trim())
          .then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      });

      addUserDetails(
        _firstnameEC.text.trim(),
        _lastNameEC.text.trim(),
        _emailController.text.trim(),
        profile_picUrl,
      );
    }

    if (_emailController.text == "" || _pass == "") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => signUpContext(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: HelpayrColors.info,
          content: Text(
            "All fields are required!",
            style: TextStyle(color: Colors.white),
          )));
    }
  }

  Future addUserDetails(
    String firstnameEC,
    String lastNameEC,
    String email,
    String profilePic,
  ) async {
    await FirebaseFirestore.instance.collection('Users').add({
      'First Name': firstnameEC,
      'Last Name': lastNameEC,
      'Email Address': email,
      'Profile_Pic': profilePic,
    });
  }

  bool passwordConfirmValid() {
    if (_pass.text.trim() == _confirm.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        controller: widget.controller,
        child: Container(
          height: MediaQuery.of(context).size.height * 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Column(children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 6,
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(2, 2),
                                    blurRadius: 1)
                              ],
                              color: HelpayrColors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: RichText(
                          text: TextSpan(
                            text: "Welcome!",
                            style: GoogleFonts.paytoneOne(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.normal,
                                shadows: [
                                  Shadow(
                                    blurRadius: 2,
                                    color: Colors.blue,
                                    offset: Offset(2, 2),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 8),
                        child: Container(
                          width: 150,
                          height: 80,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(repair_img[2]),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.4,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    image: DecorationImage(
                        image: AssetImage("assets/login/background.png"),
                        fit: BoxFit.fill),
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Register",
                      style: GoogleFonts.paytoneOne(
                          color: Colors.blue.withOpacity(.8),
                          letterSpacing: 1.5,
                          fontSize: 40,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(.5),
                              offset: Offset(2, 2),
                              blurRadius: 1,
                            ),
                            Shadow(
                              color: Colors.white,
                              offset: Offset(-2, -2),
                              blurRadius: 1,
                            ),
                          ]),
                    ),
                    GestureDetector(
                      onTap: selectImage,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(alignment: Alignment.center, children: [
                            if (pickedfile != null)
                              Container(
                                child: Image.file(
                                  File(pickedfile.path),
                                  fit: BoxFit.cover,
                                ),
                                width: 59,
                                height: 59,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 3, color: Colors.blue),
                                  color: Colors.transparent,
                                ),
                              ),
                            if (pickedfile == null)
                              Container(
                                child: Icon(Icons.camera),
                                width: 59,
                                height: 59,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 3, color: Colors.blue),
                                  color: Colors.transparent,
                                ),
                              ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 3,
                                    color: Colors.black.withOpacity(.5)),
                                color: Colors.transparent,
                              ),
                            ),
                          ]),
                          SizedBox(
                            height: 5,
                          ),
                          RichText(
                            text: TextSpan(
                              text: "Upload",
                              style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                    text: " Image",
                                    style: TextStyle(color: Colors.blue))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 30.0, left: 30.0, bottom: 20, top: 30),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 20,
                            offset: Offset(4, 4),
                          ),
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 20,
                            offset: Offset(-4, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                            ),
                            child: TextField(
                              controller: _firstnameEC,
                              cursorColor: Colors.blue,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(Icons.person),
                                hintText: "First Name",
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                            ),
                            child: TextField(
                              cursorColor: Colors.blue,
                              controller: _lastNameEC,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(Icons.person),
                                hintText: "Last Name",
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                            ),
                            child: TextField(
                              cursorColor: Colors.blue,
                              controller: _emailController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(Icons.email),
                                hintText: "Email Address",
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                            ),
                            child: TextField(
                              controller: _pass,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(Icons.key),
                                hintText: "Password",
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              controller: _confirm,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(Icons.key_sharp),
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              isSaved
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 10, top: 0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isElevated = !isElevated;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                          );
                        },
                        child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: 50,
                            decoration: BoxDecoration(
                              boxShadow: isElevated
                                  ? [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 20,
                                        offset: Offset(4, 4),
                                      ),
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 20,
                                        offset: Offset(-4, -4),
                                      ),
                                    ]
                                  : null,
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 125, 199, 233),
                                    Color.fromARGB(255, 28, 108, 173),
                                    Color.fromARGB(255, 13, 110, 189),
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight),
                            ),
                            child: const Center(
                              child: Text(
                                "Let's Go!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          left: 80, right: 80, bottom: 10, top: 0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isElevated = !isElevated;
                          });
                          uploadImage();
                        },
                        child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: 50,
                            decoration: BoxDecoration(
                              boxShadow: isElevated
                                  ? [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 20,
                                        offset: Offset(4, 4),
                                      ),
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 20,
                                        offset: Offset(-4, -4),
                                      ),
                                    ]
                                  : null,
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 125, 199, 233),
                                    Color.fromARGB(255, 28, 108, 173),
                                    Color.fromARGB(255, 13, 110, 189),
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight),
                            ),
                            child: const Center(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
