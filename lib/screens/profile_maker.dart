import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/screens/when_complete.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class ProfileMaker extends StatefulWidget {
  const ProfileMaker({key});

  @override
  State<ProfileMaker> createState() => _ProfileMakerState();
}

class _ProfileMakerState extends State<ProfileMaker>
    with SingleTickerProviderStateMixin {
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

//Store Methods!

  UploadTask uploadProfile;
  UploadTask uploadBg;
  bool store_loading = false;
  bool service_loading = false;
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
  //ControlsService

  final service_ageEC = TextEditingController();
  final fullNameEC = TextEditingController();
  final service_addressEC = TextEditingController();
  final service_descEC = TextEditingController();
  final service_facebookEc = TextEditingController();
  final service_priceEc = TextEditingController();

  Future addServiceDetails(
      String fullname,
      String service,
      String service_ageEC,
      String service_addressEC,
      String service_descEC,
      String service_facebookEc,
      String service_priceEc,
      String dp_service,
      String bg_service,
      List<String> uploadedImageService) async {
    await FirebaseFirestore.instance
        .collection('Helpers')
        .doc('Service')
        .collection(dropValue)
        .add({
      'full_name': fullname,
      'job_profession': service,
      'Age': service_ageEC,
      'Address': service_addressEC,
      'Description': service_descEC,
      'fb': service_facebookEc,
      'price': service_priceEc,
      'dp': dp_service,
      'bg': bg_service,
      'image': uploadedImageService,
    });
  }

  Future uploadWorks_Service() async {
    await uploadImagesService();
    await uploadImageSingleProfileService();
  }

  String dp_service = "";
  String bg_service = "";

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
        dp_service = value;
      });
    });
    await upload_service();
  }

  Future upload_service() async {
    await addServiceDetails(
        fullNameEC.text.trim(),
        dropValue,
        service_ageEC.text.trim(),
        service_addressEC.text.trim(),
        service_descEC.text.trim(),
        service_facebookEc.text.trim(),
        service_priceEc.text.trim(),
        dp_service,
        bg_service,
        uploadedImageService);
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
        bg_service = value;
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
  List<String> service = [];
  Future getDocs() async {
    await FirebaseFirestore.instance.collection("Service_Display").get().then(
          (value) => value.docs.forEach(
            (element) {
              service.add(element.reference.id);
            },
          ),
        );
  }

  List<String> services = [
    "Academic Writer",
    "Art",
    "Baking",
    "Beautician",
    "Entertainer",
    "Graphic Designer",
    "Photographer",
    "Technician",
  ];

  String dropValue;

  AnimationController _animationctrl;

  @override
  void initState() {
    super.initState();
    _animationctrl = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 20,
      ),
    );
    _animationctrl.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    service_ageEC.dispose();
    fullNameEC.dispose();
    service_addressEC.dispose();
    service_descEC.dispose();
    service_facebookEc.dispose();
    service_priceEc.dispose();

    _animationctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: 0);
    PageController _works = PageController(initialPage: 0);
    PageController _works_service = PageController(initialPage: 0);

    final user = FirebaseAuth.instance.currentUser;
    return FutureBuilder(
      future: getDocs(),
      builder: (context, snapshot) => Scaffold(
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
                      ? AssetImage('assets/onboarding new/bg_wavy.png')
                      : AssetImage('assets/onboarding new/bg_wavy_rotated.png'),
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
                        color: isHelpersSelected ? Colors.white : Colors.black,
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
                                          "Store",
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
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: service_loading
                                      ? () {}
                                      : selectImageBgService,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                    onTap: service_loading
                                        ? () {}
                                        : selectImageDpService,
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
                                                    Icon(
                                                        FontAwesomeIcons.image),
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
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                            width: prof ? 10 : 5,
                                            height: prof ? 10 : 5,
                                            decoration: BoxDecoration(
                                              color: prof
                                                  ? Colors.white
                                                  : Colors.black,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: .1,
                                                  color: Colors.white),
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
                                        color:
                                            works ? Colors.blue : Colors.white,
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
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                            width: works ? 10 : 5,
                                            height: works ? 10 : 5,
                                            decoration: BoxDecoration(
                                              color: works
                                                  ? Colors.white
                                                  : Colors.black,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: .1,
                                                  color: Colors.white),
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
                                                padding:
                                                    const EdgeInsets.all(0),
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
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                        ),
                                                      ),
                                                      child: TextField(
                                                        cursorColor:
                                                            Colors.blue,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        controller: fullNameEC,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          prefixIcon:
                                                              const Icon(
                                                                  Icons.person),
                                                          hintText: "Full Name",
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400],
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
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                        ),
                                                      ),
                                                      child: TextField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        cursorColor:
                                                            Colors.blue,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        controller:
                                                            service_ageEC,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          prefixIcon:
                                                              const Icon(
                                                                  Icons.person),
                                                          hintText: "Age",
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400],
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
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    15.0),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.work,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .6)),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Flexible(
                                                              flex: 1,
                                                              child:
                                                                  DropdownButton(
                                                                iconEnabledColor:
                                                                    Colors.blue,
                                                                hint: Text(
                                                                    "Select a Service",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(.4))),
                                                                value:
                                                                    dropValue,
                                                                items: services
                                                                    .map(
                                                                        (value) {
                                                                  return DropdownMenuItem(
                                                                    value:
                                                                        value,
                                                                    child: Text(
                                                                      value,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    dropValue =
                                                                        value;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ],
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
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                        ),
                                                      ),
                                                      child: TextField(
                                                        cursorColor:
                                                            Colors.blue,
                                                        controller:
                                                            service_addressEC,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          prefixIcon:
                                                              const Icon(
                                                                  Icons.map),
                                                          hintText: "Address",
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400],
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
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                        ),
                                                      ),
                                                      child: TextField(
                                                        controller:
                                                            service_descEC,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          prefixIcon: const Icon(
                                                              FontAwesomeIcons
                                                                  .penFancy),
                                                          hintText:
                                                              "Description",
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400],
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
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                        ),
                                                      ),
                                                      child: TextField(
                                                        controller:
                                                            service_facebookEc,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          prefixIcon: const Icon(
                                                              FontAwesomeIcons
                                                                  .facebook),
                                                          hintText: "Facebook",
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400],
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
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            store_priceEc,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          prefixIcon: const Icon(
                                                              FontAwesomeIcons
                                                                  .moneyBill),
                                                          hintText:
                                                              "Price Range",
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400],
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
                                                              milliseconds:
                                                                  300),
                                                          curve:
                                                              Curves.easeInOut);
                                                },
                                                child: Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                          service_loading
                                              ? Center(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Saving...",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
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
                                                            service_loading =
                                                                true;
                                                          });

                                                          uploadImageSingleBgService();
                                                          uploadWorks_Service()
                                                              .whenComplete(() =>
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        ((context) =>
                                                                            Dialog(
                                                                              backgroundColor: Colors.transparent,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    LottieBuilder.network(
                                                                                      "https://assets4.lottiefiles.com/packages/lf20_3juvcrdk.json",
                                                                                      fit: BoxFit.fill,
                                                                                      repeat: false,
                                                                                      controller: _animationctrl,
                                                                                      onLoaded: ((p0) {
                                                                                        _animationctrl.duration = p0.duration;
                                                                                        return _animationctrl.forward();
                                                                                      }),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )),
                                                                  ));
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
                                          service_loading
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.5,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            3,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Swiper(
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Card(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              elevation: 10,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .blue
                                                                      .withOpacity(
                                                                          .7),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  image:
                                                                      DecorationImage(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    image:
                                                                        FileImage(
                                                                      File(imageListService[
                                                                              index]
                                                                          .path),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          viewportFraction: 0.9,
                                                          scale: 1,
                                                          autoplay: true,
                                                          itemCount:
                                                              imageListService
                                                                  .length,
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: LottieBuilder
                                                            .network(
                                                          "https://assets5.lottiefiles.com/packages/lf20_z7DhMX.json",
                                                          animate: true,
                                                          repeat: true,
                                                          fit: BoxFit.contain,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              4,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    child: GridView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            imageListService
                                                                    .length +
                                                                1,
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    2),
                                                        itemBuilder:
                                                            ((context, index) {
                                                          return index == 0
                                                              ? Card(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                  elevation: 10,
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      border: Border.all(
                                                                          width:
                                                                              3,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          imageListService.length == 1 || imageListService.length == 0
                                                                              ? FittedBox(
                                                                                  fit: BoxFit.fitWidth,
                                                                                  child: Text(
                                                                                    '${imageListService.length} image is selected!',
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : FittedBox(
                                                                                  fit: BoxFit.fitWidth,
                                                                                  child: Text(
                                                                                    '${imageListService.length} images are selected!',
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                          IconButton(
                                                                            onPressed: imageListService.length > 10 || service_loading
                                                                                ? () {}
                                                                                : selectImagesService,
                                                                            icon:
                                                                                Icon(Icons.add),
                                                                            color:
                                                                                Colors.white,
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
                                                                            .circular(5),
                                                                  ),
                                                                  elevation: 10,
                                                                  child: Stack(
                                                                      children: [
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              image: DecorationImage(fit: BoxFit.cover, image: FileImage(File(imageListService[index - 1].path)))),
                                                                        ),
                                                                        Positioned(
                                                                          right:
                                                                              5,
                                                                          top:
                                                                              5,
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                imageListService.removeAt(index - 1);
                                                                              });
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(2),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(2.0),
                                                                                child: Icon(Icons.remove),
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
                        //SERVICE PAGE
                        Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 190,
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                GestureDetector(
                                  onTap:
                                      service_loading ? () {} : selectImageBg,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                    onTap:
                                        store_loading ? () {} : selectImageDp,
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
                                                    Icon(
                                                        FontAwesomeIcons.image),
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
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                            width: prof ? 10 : 5,
                                            height: prof ? 10 : 5,
                                            decoration: BoxDecoration(
                                              color: prof
                                                  ? Colors.white
                                                  : Colors.black,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: .1,
                                                  color: Colors.white),
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
                                        color:
                                            works ? Colors.blue : Colors.white,
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
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                            width: works ? 10 : 5,
                                            height: works ? 10 : 5,
                                            decoration: BoxDecoration(
                                              color: works
                                                  ? Colors.white
                                                  : Colors.black,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: .1,
                                                  color: Colors.white),
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
                                                padding:
                                                    const EdgeInsets.all(0),
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
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                        ),
                                                      ),
                                                      child: DropdownButton(
                                                        isExpanded: true,
                                                        value: dropValue,
                                                        items: services
                                                            .map((value) {
                                                          return DropdownMenuItem(
                                                            value: value,
                                                            child: Text(
                                                              value,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            dropValue = value;
                                                          });
                                                        },
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
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                        ),
                                                      ),
                                                      child: TextField(
                                                        cursorColor:
                                                            Colors.blue,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          prefixIcon:
                                                              const Icon(
                                                                  Icons.person),
                                                          hintText: "Age",
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400],
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
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                        ),
                                                      ),
                                                      child: TextField(
                                                        cursorColor:
                                                            Colors.blue,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          prefixIcon:
                                                              const Icon(
                                                                  Icons.map),
                                                          hintText: "Address",
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400],
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
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                        ),
                                                      ),
                                                      child: TextField(
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          prefixIcon:
                                                              const Icon(
                                                                  Icons.work),
                                                          hintText:
                                                              "Job/Profession",
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400],
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
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                        ),
                                                      ),
                                                      child: TextField(
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          prefixIcon: const Icon(
                                                              FontAwesomeIcons
                                                                  .penFancy),
                                                          hintText:
                                                              "Description",
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400],
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
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                        ),
                                                      ),
                                                      child: TextField(
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          prefixIcon: const Icon(
                                                              FontAwesomeIcons
                                                                  .facebook),
                                                          hintText: "Facebook",
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400],
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
                                                            TextInputAction
                                                                .next,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          prefixIcon: const Icon(
                                                              FontAwesomeIcons
                                                                  .moneyBill),
                                                          hintText:
                                                              "Price Range",
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400],
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
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                                        MainAxisAlignment
                                                            .center,
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
                                                            store_loading =
                                                                true;
                                                          });
                                                          uploadImageSingleBg();
                                                          uploadWorks()
                                                              .whenComplete(
                                                            () =>
                                                                Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        WhenCompleted(),
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
                                                                  imageListStore.length ==
                                                                              1 ||
                                                                          imageListStore.length ==
                                                                              0
                                                                      ? FittedBox(
                                                                          fit: BoxFit
                                                                              .fitWidth,
                                                                          child:
                                                                              Text(
                                                                            '${imageListStore.length} image is selected!',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : FittedBox(
                                                                          fit: BoxFit
                                                                              .fitWidth,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text(
                                                                              '${imageListStore.length} images are selected!',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                  IconButton(
                                                                      onPressed: store_loading
                                                                          ? () {}
                                                                          : selectImagesStore,
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
                                                                              FileImage(File(imageListStore[index - 1].path)))),
                                                                ),
                                                                Positioned(
                                                                  right: 5,
                                                                  top: 5,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        imageListStore.removeAt(
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
                      ],
                    ))
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
