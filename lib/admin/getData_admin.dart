import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUsers_Info extends StatefulWidget {
  const GetUsers_Info({
    key,
    this.docId,
  });
  final String docId;

  @override
  State<GetUsers_Info> createState() => _GetUsers_InfoState();
}

class _GetUsers_InfoState extends State<GetUsers_Info> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users_info =
        FirebaseFirestore.instance.collection("Users");

    return FutureBuilder(
      future: users_info.doc(widget.docId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data.data() as Map<String, dynamic>;
          return Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: 130,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 120,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(data['dp']))))
                  ],
                ),
              ),
            ),
          );
        }
        return Container(child: Center(child: CircularProgressIndicator()));
      }),
    );
  }
}
