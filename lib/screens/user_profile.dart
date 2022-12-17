import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class User_Profile extends StatefulWidget {
  const User_Profile({key, this.ontap});
  final Function ontap;

  @override
  State<User_Profile> createState() => _User_ProfileState();
}

class _User_ProfileState extends State<User_Profile> {
  final _fullname = TextEditingController();
  final _location = TextEditingController();
  @override
  void dispose() {
    _fullname.dispose();
    _location.dispose();
    super.dispose();
  }

  PlatformFile pickedFileDp;
  bool isSaved = false;
  String profile_picUrl = "";
  UploadTask uploadProfile;

  Future selectImageDp() async {
    final res_image = await FilePicker.platform.pickFiles();

    setState(() {
      pickedFileDp = res_image.files.first;
    });
  }

  Future uploadImageSingleProfile() async {
    final name = FirebaseAuth.instance.currentUser.displayName;
    final path = 'User/${name}/Profile/${pickedFileDp.name}';
    final file_dp = File(pickedFileDp.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadProfile = ref.putFile(file_dp);
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

  update() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      'dp': profile_picUrl,
      'full_name': _fullname.text,
      'location': _location.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) => Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/imgs/onboarding-bg.png"))),
          child: Center(
            child: Container(
              height: 260,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0),
                      child: Container(
                        height: 230,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(children: [
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
                            Text(
                              '${snapshot.data['full_name']}',
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              FirebaseAuth.instance.currentUser.email,
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Bookings',
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser.uid)
                                        .collection("Bookings")
                                        .snapshots(),
                                    builder: (context, snapshot) => Column(
                                      children: [
                                        Text(
                                          "Pending",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${snapshot.data.docs.length}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser.uid)
                                        .collection("Bookings")
                                        .where('is_accepted ', isEqualTo: true)
                                        .snapshots(),
                                    builder: (context, snapshot) => Column(
                                      children: [
                                        Text(
                                          "Accepted",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${snapshot.data.docs.length}",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser.uid)
                                        .collection("Bookings")
                                        .where('is_accepted ', isEqualTo: false)
                                        .snapshots(),
                                    builder: (context, snapshot) => Column(
                                      children: [
                                        Text(
                                          "Declined ",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${snapshot.data.docs.length}",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(3, 0),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return DraggableScrollableSheet(
                                                initialChildSize: 1,
                                                maxChildSize: 1,
                                                minChildSize: 1,
                                                builder:
                                                    ((context,
                                                            scrollController) =>
                                                        Container(
                                                          height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height,
                                                          child: Card(
                                                            elevation: 10,
                                                            child: Column(
                                                                children: [
                                                                  Container(
                                                                    height: 10,
                                                                    width: 100,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        bottomLeft:
                                                                            Radius.circular(24),
                                                                        bottomRight:
                                                                            Radius.circular(24),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "Edit Details",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        border:
                                                                            Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey,
                                                                              width: 2),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            _fullname,
                                                                        cursorColor:
                                                                            Colors.blue,
                                                                        textInputAction:
                                                                            TextInputAction.next,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          border:
                                                                              InputBorder.none,
                                                                          prefixIcon:
                                                                              const Icon(Icons.person),
                                                                          hintText:
                                                                              "Full Name",
                                                                          hintStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.grey[400],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        border:
                                                                            Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey,
                                                                              width: 2),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            _location,
                                                                        cursorColor:
                                                                            Colors.blue,
                                                                        textInputAction:
                                                                            TextInputAction.next,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          border:
                                                                              InputBorder.none,
                                                                          prefixIcon:
                                                                              const Icon(Icons.person),
                                                                          hintText:
                                                                              "Location",
                                                                          hintStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.grey[400],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 50,
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.bottomRight,
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                selectImageDp,
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                color: Colors.white,
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Colors.black26,
                                                                                    offset: Offset(3, 0),
                                                                                    blurRadius: 6,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Icon(Icons.edit, color: Colors.black),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    height: 100,
                                                                    width: 100,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color:
                                                                              Colors.black26,
                                                                          offset: Offset(
                                                                              3,
                                                                              0),
                                                                          blurRadius:
                                                                              6,
                                                                        ),
                                                                      ],
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image: pickedFileDp != null
                                                                              ? FileImage(File(pickedFileDp.path))
                                                                              : NetworkImage(FirebaseAuth.instance.currentUser.photoURL)),
                                                                    ),
                                                                  ),
                                                                  isSaved
                                                                      ? ElevatedButton(
                                                                          onPressed:
                                                                              () async {
                                                                            await update();
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text("Update"),
                                                                          ))
                                                                      : ElevatedButton(
                                                                          onPressed:
                                                                              () async {
                                                                            await uploadImageSingleProfile();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text("Save"),
                                                                          ))
                                                                ]),
                                                          ),
                                                        )),
                                              );
                                            });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit_attributes,
                                                color: Colors.white),
                                            Text(
                                              "Edit",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(3, 0),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: widget.ontap,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.exit_to_app,
                                                color: Colors.white),
                                            Text(
                                              "Log-out",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(3, 0),
                                blurRadius: 6,
                              ),
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(snapshot.data['dp']))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
