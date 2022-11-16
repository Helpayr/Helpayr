import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpayr/firebase/getData.dart';

class SampleHome extends StatefulWidget {
  const SampleHome(
      {Key key,
      this.userType,
      this.service,
      this.type,
      this.isService = false,
      this.isList});
  final String userType;
  final String service;
  final String type;
  final bool isService;
  final bool isList;

  @override
  State<SampleHome> createState() => _SampleHomeState();
}

class _SampleHomeState extends State<SampleHome> {
  final user = FirebaseAuth.instance.currentUser;
  List<String> helpers = [];

  Future getData() async {
    await FirebaseFirestore.instance
        .collection(widget.userType)
        .doc(widget.service)
        .collection(widget.type)
        .get()
        .then((value) => value.docs.forEach((element) {
              helpers.add(element.reference.id);
            }));
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: ((context, snapshot) => Scaffold(
            backgroundColor: Colors.white,
            body: ListView.builder(
                itemCount: 1,
                itemBuilder: ((context, index) => SingleChildScrollView(
                      child: GetData(
                        isService: widget.isService,
                        UserType: widget.userType,
                        HelperType: widget.service,
                        StoreType: widget.type,
                        DocId: helpers[index],
                      ),
                    ))),
          )),
    );
  }
}
