import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpayr/admin/service/data_Listing.dart';

class Service_AdminPanel extends StatefulWidget {
  const Service_AdminPanel({
    key,
    this.isService = false,
    this.helper_type,
    this.service_storeType,
  });

  final bool isService;
  final String helper_type;
  final String service_storeType;
  @override
  State<Service_AdminPanel> createState() => _Service_AdminPanelState();
}

class _Service_AdminPanelState extends State<Service_AdminPanel> {
  List<String> fucking_ids = [];

  Future _fuckingFuture;

  Future getFuckinID() async {
    await FirebaseFirestore.instance
        .collection(widget.service_storeType)
        .get()
        .then((value) => value.docs.forEach((element) {
              fucking_ids.add(element.reference.id);
            }));
  }

  @override
  void initState() {
    _fuckingFuture = getFuckinID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fuckingFuture,
      builder: ((context, snapshot) {
        return Container(
          width: MediaQuery.of(context).size.width / 1.2,
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: fucking_ids.length,
              itemBuilder: ((context, index) => Service_StoreCategory(
                    service_title: [fucking_ids],
                    isService: widget.isService,
                    HelperType: widget.helper_type,
                    Store_ServiceType: fucking_ids[index],
                    DocId: fucking_ids[index],
                  ))),
        );
      }),
    );
  }
}

class Service_StoreCategory extends StatefulWidget {
  const Service_StoreCategory({
    key,
    this.service_title,
    this.isService,
    this.HelperType,
    this.Store_ServiceType,
    this.DocId,
  });
  final List service_title;
  final bool isService;
  final String HelperType;
  final String Store_ServiceType;
  final String DocId;

  @override
  State<Service_StoreCategory> createState() => _Service_StoreCategoryState();
}

class _Service_StoreCategoryState extends State<Service_StoreCategory> {
  @override
  Widget build(BuildContext context) {
    CollectionReference service = FirebaseFirestore.instance
        .collection("Helpers")
        .doc(widget.HelperType)
        .collection(widget.Store_ServiceType);
    return FutureBuilder(
      future: service.doc(widget.DocId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data.data() as Map<String, dynamic>;

          GestureDetector(
            onTap: () {
              return ListDataAdmin(
                  isService: widget.isService,
                  title: widget.Store_ServiceType,
                  userType: "Helpers",
                  service: widget.HelperType,
                  type: widget.Store_ServiceType);
            },
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width / 1.4,
              color: Colors.black,
            ),
          );
        }
        return Container(
          child: Center(child: CircularProgressIndicator()),
        );
      }),
    );
  }
}
