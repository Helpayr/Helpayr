import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Get_Service extends StatefulWidget {
  const Get_Service(
      {key,
      this.DocId,
      this.HelperType,
      this.UserType,
      this.isService,
      this.Store_ServiceType});

  @override
  State<Get_Service> createState() => _Get_ServiceState();
  final String DocId;
  final String HelperType;
  final String Store_ServiceType;
  final String UserType;
  final bool isService;
}

class _Get_ServiceState extends State<Get_Service> {
  @override
  Widget build(BuildContext context) {
    CollectionReference services_stores = FirebaseFirestore.instance
        .collection(widget.UserType)
        .doc(widget.HelperType)
        .collection(widget.Store_ServiceType);
    return FutureBuilder<DocumentSnapshot>(
      future: services_stores.doc(widget.DocId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.isService
              ? Scaffold(
                  body: Container(
                    color: Colors.red,
                  ),
                )
              : Scaffold();
        }
        return Scaffold(
          body: Container(
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }),
    );
  }
}
