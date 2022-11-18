import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfileMaker extends StatefulWidget {
  const ProfileMaker({key});

  @override
  State<ProfileMaker> createState() => _ProfileMakerState();
}

class _ProfileMakerState extends State<ProfileMaker> {
  PlatformFile pickedfile;
  PlatformFile pickedFileDp;
  PlatformFile pickedFileServiceBg;
  PlatformFile pickedFileServiceDp;

  final ImagePicker imgPicker = ImagePicker();

  String profile_picUrl = "";
  String bg = "";
  bool isSaved = false;

  //ControlsStore

  final store_ageEC = TextEditingController();
  final store_addressEC = TextEditingController();
  final store_descEC = TextEditingController();
  final store_facebookEc = TextEditingController();
  final store_priceEc = TextEditingController();

  //ControlsService

  final service_ageEC = TextEditingController();
  final service_addressEC = TextEditingController();
  final service_descEC = TextEditingController();
  final service_facebookEc = TextEditingController();
  final service_priceEc = TextEditingController();

//Store Methods!

  UploadTask uploadProfile;
  UploadTask uploadBg;
  bool store_loading = false;
  double val = 0;
  List<String> uploadedImage = [];
  List<XFile> imageListStore = [];

  Future selectImagesStore() async {
    final selectedImages = await imgPicker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      setState(() {
        imageListStore.addAll(selectedImages);
      });
    } else if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please Choose Images!"),
      ));
    }
  }

  Future uploadImagesStore() async {
    int i = 1;

    setState(() {
      val = i / imageListStore.length;
    });
    final name = FirebaseAuth.instance.currentUser.displayName;
    for (var img in imageListStore) {
      File file = File(img.path);
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Store/${name}/Products/ ${img.name}');
      await ref.putFile(file).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          uploadedImage.add(value);
          print(uploadedImage);
          i++;
        });
      });
    }
  }

  Future selectImageDp() async {
    final res_image = await FilePicker.platform.pickFiles();

    setState(() {
      pickedFileDp = res_image.files.first;
    });
  }

  Future uploadImageSingleProfile() async {
    final name = FirebaseAuth.instance.currentUser.displayName;
    final path = 'Store/${name}/Profile/${pickedFileDp.name}';
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
  }

  Future selectImageBg() async {
    final res_image = await FilePicker.platform.pickFiles();
    setState(() {
      pickedfile = res_image.files.first;
    });
  }

  Future uploadImageSingleBg() async {
    final name = FirebaseAuth.instance.currentUser.displayName;
    final path = 'Store/${name}/Profile/${pickedfile.name}';
    final file_bg = File(pickedfile.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadBg = ref.putFile(file_bg);
    });
    await ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        bg = value;
      });
    });
  }

  Future uploadWorks() async {
    await uploadImagesStore();
    await uploadImageSingleProfile();
  }

  //Service Methods!

  UploadTask uploadProfileService;
  UploadTask uploadBgService;
  List<String> uploadedImageService = [];
  List<XFile> imageListService = [];

  Future selectImagesService() async {
    final selectedImages = await imgPicker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      setState(() {
        imageListService.addAll(selectedImages);
      });
    } else if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please Choose Images!"),
      ));
    }
  }

  Future uploadImagesService() async {
    final name = FirebaseAuth.instance.currentUser.displayName;
    for (var img in imageListService) {
      File file = File(img.path);
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Service/${name}/Products/ ${img.name}');
      await ref.putFile(file).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          uploadedImageService.add(value);
        });
      });
    }
  }

  Future selectImageBgService() async {
    final res_image = await FilePicker.platform.pickFiles();

    setState(() {
      pickedFileServiceBg = res_image.files.first;
    });
  }

  Future selectImageDpService() async {
    final res_image = await FilePicker.platform.pickFiles();

    setState(() {
      pickedFileServiceDp = res_image.files.first;
    });
  }

  Future uploadImageSingleProfileService() async {
    final name = FirebaseAuth.instance.currentUser.displayName;
    final path = 'Service/${name}/ ${pickedFileServiceDp.name}';
    final file = File(pickedFileServiceDp.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadProfileService = ref.putFile(file);
    });
    await ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        profile_picUrl = value;
      });
    });
  }

  Future uploadWorks_Service() async {
    await uploadImagesService();
    await uploadImageSingleProfileService();
  }

  Future uploadImageSingleBgService() async {
    final name = FirebaseAuth.instance.currentUser.displayName;
    final path = 'Service/${name}/ ${pickedFileServiceBg.name}';
    final file = File(pickedFileServiceBg.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadBgService = ref.putFile(file);
    });
    await ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        bg = value;
      });
    });
    setState(() {
      isSaved = true;
    });
  }

  bool isHelpersSelected = true;
  bool isServiceSelected = false;
  bool works = false;
  bool prof = true;

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: 0);
    PageController _works = PageController(initialPage: 0);
    PageController _works_service = PageController(initialPage: 0);
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: isServiceSelected
                    ? AssetImage('assets/onboarding new/bg_wavy_rotated.png')
                    : AssetImage('assets/onboarding new/bg_wavy.png'),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Register As",
                    style: TextStyle(
                      color: isHelpersSelected ? Colors.black : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color:
                          isServiceSelected ? Colors.blue : Colors.blueAccent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isHelpersSelected = true;
                                isServiceSelected = false;
                              });
                              return _pageController.animateToPage(0,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.blue,
                              ),
                              height: 50,
                              child: Center(
                                child: isHelpersSelected
                                    ? Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        elevation: 10,
                                        child: Center(
                                          child: Text(
                                            "Store",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          "Service",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isHelpersSelected = false;
                                isServiceSelected = true;
                              });
                              return _pageController.nextPage(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.blueAccent,
                              ),
                              child: isServiceSelected
                                  ? Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      elevation: 10,
                                      child: Center(
                                        child: Text(
                                          "Service",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        "Service",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 190,
                                width: MediaQuery.of(context).size.width / 1.1,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              GestureDetector(
                                onTap: selectImageBg,
                                child: Container(
                                  height: 160,
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  decoration: BoxDecoration(
                                    color: pickedfile != null
                                        ? Colors.transparent
                                        : Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: pickedfile != null
                                      ? Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 10,
                                          child: Container(
                                            height: 140,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.transparent,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: FileImage(
                                                      File(pickedfile.path),
                                                    ))),
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.image,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Add Background Image",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 15,
                                right: 20,
                                child: GestureDetector(
                                  onTap: selectImageDp,
                                  child: Container(
                                    height: 90,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 4, color: Colors.white),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: pickedFileDp != null
                                                ? FileImage(
                                                    File(pickedFileDp.path))
                                                : AssetImage('')),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(2, 3),
                                            blurRadius: 6,
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: pickedFileDp != null
                                            ? Container(
                                                color: Colors.transparent,
                                              )
                                            : Column(
                                                children: [
                                                  Icon(FontAwesomeIcons.image),
                                                  Text(
                                                    "Add Profile Image",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Text(
                                  user.displayName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      prof = true;
                                      works = false;
                                    });
                                    return _works.animateTo(0,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut);
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    width: 90,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: prof
                                          ? Colors.blueAccent
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 2,
                                          color: prof
                                              ? Colors.transparent
                                              : Colors.black),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                          width: prof ? 10 : 5,
                                          height: prof ? 10 : 5,
                                          decoration: BoxDecoration(
                                            color: prof
                                                ? Colors.white
                                                : Colors.black,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: .1, color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Info",
                                            style: GoogleFonts.raleway(
                                                color: prof
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: prof
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      works = true;
                                      prof = false;
                                    });
                                    return _works.animateToPage(1,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    width: 90,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: works ? Colors.blue : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 2,
                                          color: works
                                              ? Colors.transparent
                                              : Colors.black),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                          width: works ? 10 : 5,
                                          height: works ? 10 : 5,
                                          decoration: BoxDecoration(
                                            color: works
                                                ? Colors.white
                                                : Colors.black,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: .1, color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Works",
                                          style: GoogleFonts.raleway(
                                              color: works
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: works
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: PageView(
                                physics: NeverScrollableScrollPhysics(),
                                controller: _works,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 20.0,
                                          left: 20.0,
                                          bottom: 20,
                                          top: 10,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.all(0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 10,
                                                    offset: Offset(4, 4),
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 10,
                                                    offset: Offset(-4, -4),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      cursorColor: Colors.blue,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: const Icon(
                                                            Icons.person),
                                                        hintText: "First Name",
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      cursorColor: Colors.blue,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: const Icon(
                                                            Icons.person),
                                                        hintText: "Age",
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      cursorColor: Colors.blue,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: const Icon(
                                                            Icons.map),
                                                        hintText: "Address",
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: const Icon(
                                                            Icons.work),
                                                        hintText:
                                                            "Job/Profession",
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: const Icon(
                                                            FontAwesomeIcons
                                                                .penFancy),
                                                        hintText: "Description",
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: const Icon(
                                                            FontAwesomeIcons
                                                                .facebook),
                                                        hintText: "Facebook",
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: const Icon(
                                                            FontAwesomeIcons
                                                                .moneyBill),
                                                        hintText: "Price Range",
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  works = true;
                                                  prof = false;
                                                });
                                                return _works.animateToPage(1,
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeInOut);
                                              },
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Save Credentials",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.blue),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        store_loading
                                            ? Center(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text("Saving..."),
                                                    CircularProgressIndicator(
                                                      value: val,
                                                    )
                                                  ],
                                                ),
                                              )
                                            : imageListStore.length >= 1
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          store_loading = true;
                                                        });
                                                        uploadImageSingleBg();
                                                        uploadWorks()
                                                            .whenComplete(
                                                          () => Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfileMaker(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color:
                                                                Colors.white),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Center(
                                                              child: Text(
                                                            "Save Images!",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            child: GridView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  imageListStore.length + 1,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2),
                                              itemBuilder: ((context, index) {
                                                return index == 0
                                                    ? Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        color:
                                                            Colors.transparent,
                                                        elevation: 10,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                imageListStore
                                                                            .length ==
                                                                        1
                                                                    ? Text(
                                                                        '${imageListStore.length} image is selected!',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      )
                                                                    : Text(
                                                                        '${imageListStore.length} images are selected!',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                IconButton(
                                                                    onPressed:
                                                                        selectImagesStore,
                                                                    icon: Icon(
                                                                        Icons
                                                                            .add)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        elevation: 10,
                                                        child: Stack(children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                image: DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image: FileImage(File(imageListStore[
                                                                            index -
                                                                                1]
                                                                        .path)))),
                                                          ),
                                                          Positioned(
                                                            right: 5,
                                                            top: 5,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  imageListStore
                                                                      .removeAt(
                                                                          index -
                                                                              1);
                                                                });
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              2),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          2.0),
                                                                  child: Icon(Icons
                                                                      .remove),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                      );
                                              }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                        ],
                      ),
                      //SERVICE PAGE
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 190,
                                width: MediaQuery.of(context).size.width / 1.1,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              GestureDetector(
                                onTap: selectImageBgService,
                                child: Container(
                                  height: 160,
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  decoration: BoxDecoration(
                                    color: pickedFileServiceBg != null
                                        ? Colors.transparent
                                        : Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: pickedFileServiceBg != null
                                      ? Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 10,
                                          child: Container(
                                            height: 160,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.transparent,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: FileImage(
                                                      File(pickedFileServiceBg
                                                          .path),
                                                    ))),
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.image,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Add Background Image",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: selectImageDpService,
                                  child: Container(
                                    height: 90,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 4),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: pickedFileServiceDp != null
                                                ? FileImage(File(
                                                    pickedFileServiceDp.path))
                                                : AssetImage('')),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(2, 3),
                                            blurRadius: 6,
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: pickedFileServiceDp != null
                                            ? Container(
                                                color: Colors.transparent,
                                              )
                                            : Column(
                                                children: [
                                                  Icon(FontAwesomeIcons.image),
                                                  Text(
                                                    "Add Profile Image",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 10,
                                child: Text(
                                  user.displayName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      prof = true;
                                      works = false;
                                    });
                                    return _works_service.animateTo(0,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut);
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    width: 90,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: prof
                                          ? Colors.blueAccent
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 2,
                                          color: prof
                                              ? Colors.transparent
                                              : Colors.black),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                          width: prof ? 10 : 5,
                                          height: prof ? 10 : 5,
                                          decoration: BoxDecoration(
                                            color: prof
                                                ? Colors.white
                                                : Colors.black,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: .1, color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Info",
                                            style: GoogleFonts.raleway(
                                                color: prof
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: prof
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      works = true;
                                      prof = false;
                                    });
                                    return _works_service.animateToPage(1,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    width: 90,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: works ? Colors.blue : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 2,
                                          color: works
                                              ? Colors.transparent
                                              : Colors.black),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                          width: works ? 10 : 5,
                                          height: works ? 10 : 5,
                                          decoration: BoxDecoration(
                                            color: works
                                                ? Colors.white
                                                : Colors.black,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: .1, color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Works",
                                          style: GoogleFonts.raleway(
                                              color: works
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: works
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: PageView(
                                physics: NeverScrollableScrollPhysics(),
                                controller: _works_service,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 20.0,
                                          left: 20.0,
                                          bottom: 10,
                                          top: 10,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.all(0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 10,
                                                    offset: Offset(4, 4),
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 10,
                                                    offset: Offset(-4, -4),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      cursorColor: Colors.blue,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: const Icon(
                                                            Icons.person),
                                                        hintText: "First Name",
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      cursorColor: Colors.blue,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: const Icon(
                                                            Icons.person),
                                                        hintText: "Age",
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      cursorColor: Colors.blue,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: const Icon(
                                                            Icons.map),
                                                        hintText: "Address",
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: const Icon(
                                                            Icons.work),
                                                        hintText:
                                                            "Job/Profession",
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: const Icon(
                                                            FontAwesomeIcons
                                                                .penFancy),
                                                        hintText: "Description",
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: const Icon(
                                                            FontAwesomeIcons
                                                                .facebook),
                                                        hintText: "Facebook",
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: const Icon(
                                                            FontAwesomeIcons
                                                                .moneyBill),
                                                        hintText: "Price Range",
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  works = true;
                                                  prof = false;
                                                });
                                                return _works_service
                                                    .animateToPage(1,
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve:
                                                            Curves.easeInOut);
                                              },
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Save Credentials",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.blue),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        store_loading
                                            ? Center(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text("Saving..."),
                                                    CircularProgressIndicator(
                                                      value: val,
                                                    )
                                                  ],
                                                ),
                                              )
                                            : imageListService.length >= 1
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          store_loading = true;
                                                        });
                                                        uploadImageSingleBgService();
                                                        uploadWorks_Service()
                                                            .whenComplete(
                                                          () => Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfileMaker(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color:
                                                                Colors.white),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Center(
                                                              child: Text(
                                                            "Save Images!",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            child: GridView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    imageListService.length + 1,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2),
                                                itemBuilder: ((context, index) {
                                                  return index == 0
                                                      ? Card(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          color: Colors
                                                              .transparent,
                                                          elevation: 10,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              border: Border.all(
                                                                  width: 3,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            child: Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  imageListService.length ==
                                                                              1 &&
                                                                          imageListService.length ==
                                                                              0
                                                                      ? Text(
                                                                          '${imageListService.length} image is selected!',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        )
                                                                      : Text(
                                                                          '${imageListService.length} images are selected!',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                  IconButton(
                                                                    onPressed:
                                                                        selectImagesService,
                                                                    icon: Icon(
                                                                        Icons
                                                                            .add),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Card(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          elevation: 10,
                                                          child: Stack(
                                                              children: [
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image:
                                                                              FileImage(File(imageListService[index - 1].path)))),
                                                                ),
                                                                Positioned(
                                                                  right: 5,
                                                                  top: 5,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        imageListService.removeAt(
                                                                            index -
                                                                                1);
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(2),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(2.0),
                                                                        child: Icon(
                                                                            Icons.remove),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]),
                                                        );
                                                })),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                        ],
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
