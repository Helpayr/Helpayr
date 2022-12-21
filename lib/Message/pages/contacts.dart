import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpayr/Message/pages/chatroom.dart';

class Contacts extends StatefulWidget {
  const Contacts({key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Users").snapshots(),
      builder: (context, snapshot) => Scaffold(
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Chatroom(
                                recipient: snapshot.data.docs[index].data(),
                                chatroomId: mod_chat(
                                  FirebaseAuth.instance.currentUser.displayName,
                                  snapshot.data.docs[index].data(),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 20),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Row(
                                  children: [
                                    Container(
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            right: 15,
                                            bottom: 5,
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1.5,
                                                    color: Colors.white),
                                                shape: BoxShape.circle,
                                                color: snapshot.data.docs[index]
                                                                ['status'] ==
                                                            "Online" &&
                                                        snapshot.data.docs[index]['status_log'] ==
                                                            "Online"
                                                    ? Colors.green
                                                    : snapshot.data.docs[index]['status'] ==
                                                                "Online" &&
                                                            snapshot.data.docs[index]['status_log'] ==
                                                                "Offline"
                                                        ? Colors.orange
                                                        : snapshot.data.docs[index]['status'] ==
                                                                    "Offline" &&
                                                                snapshot.data.docs[index]['status_log'] ==
                                                                    "Online"
                                                            ? Colors.yellow
                                                            : snapshot.data.docs[index]['status'] == "Offline" &&
                                                                    snapshot.data.docs[index]['status_log'] ==
                                                                        "Offline"
                                                                ? Colors.grey
                                                                : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(snapshot
                                                .data.docs[index]['dp'])),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(3, 0),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${snapshot.data.docs[index]['full_name']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            '${snapshot.data.docs[index]['email']}')
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  String mod_chat(String currentUser, Map<String, dynamic> data) {
    String sendTo = data['full_name'];
    if (currentUser[0].toLowerCase().codeUnits[0] >
        sendTo[0].toLowerCase().codeUnits[0]) {
      return "$currentUser$sendTo";
    }
    return "$sendTo$currentUser";
  }
}
