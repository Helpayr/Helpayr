import 'dart:io';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/Message/pages/full_screen.dart';
import 'package:helpayr/Message/widgets/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({
    key,
    this.recipient,
    this.chatroomId,
  });
  final Map<String, dynamic> recipient;
  final String chatroomId;

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  final TextEditingController message_send = TextEditingController();
  ScrollController _automaticScrollDown = ScrollController();

  void _scrollDown() {
    _automaticScrollDown.animateTo(
      _automaticScrollDown.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  File imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        imageFile = File(value.path);
        upload(widget.recipient['dp'], widget.recipient['full_name']);
      }
    });
  }

  Future upload(
    String url,
    String sentTo,
  ) async {
    int status = 1;
    String filename = Uuid().v1();
    await _firebase
        .collection('chatroom')
        .doc(widget.chatroomId)
        .collection("chats")
        .doc(filename)
        .set({
      "sendby": FirebaseAuth.instance.currentUser.displayName,
      "message": message_send.text,
      "time": FieldValue.serverTimestamp(),
      "sendToPic": url,
      'type': 'img',
      "sentTo": sentTo,
    });

    var ref =
        FirebaseStorage.instance.ref().child("Chat Images").child("$filename");
    var uploadTak = await ref.putFile(imageFile).catchError((onError) async {
      await _firebase
          .collection('chatroom')
          .doc(widget.chatroomId)
          .collection("chats")
          .doc(filename)
          .delete();
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTak.ref.getDownloadURL();
      await _firebase
          .collection('chatroom')
          .doc(widget.chatroomId)
          .collection("chats")
          .doc(filename)
          .update({
        'message': imageUrl,
      });
    }
  }

  void onSend(
    String url,
    String sentTo,
  ) async {
    if (message_send.text.isNotEmpty) {
      await _firebase
          .collection('chatroom')
          .doc(widget.chatroomId)
          .collection("chats")
          .add({
        "sendby": FirebaseAuth.instance.currentUser.displayName,
        "message": message_send.text,
        "time": FieldValue.serverTimestamp(),
        "sendToPic": url,
        'type': 'text',
        "sentTo": sentTo,
      });
    }
    message_send.clear();
  }

  List<String> chat_sorted = [];

  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: false,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Avatar.small(
              url: widget.recipient['dp'],
            ),
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          widget.recipient['full_name'],
          style: GoogleFonts.raleway(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            width: size.width,
            height: MediaQuery.of(context).size.height / 1.25,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebase
                  .collection("chatroom")
                  .doc(widget.chatroomId)
                  .collection("chats")
                  .orderBy("time", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data.docs.isEmpty) {
                  return Column(
                    children: [
                      LottieBuilder.network(
                          "https://assets8.lottiefiles.com/packages/lf20_q1g5qcgm.json"),
                    ],
                  );
                }
                if (snapshot.data != null) {
                  return ListView.builder(
                      controller: _automaticScrollDown,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: ((context, index) {
                        Map<String, dynamic> map =
                            snapshot.data.docs[index].data();

                        delete() async {
                          await FirebaseFirestore.instance
                              .collection("chatroom")
                              .doc(widget.chatroomId)
                              .collection("chats")
                              .orderBy("time", descending: false)
                              .get()
                              .then((value) {
                            value.docs.forEach((element) {
                              chat_sorted.add(element.reference.id);
                            });
                          });
                          await FirebaseFirestore.instance
                              .collection("chatroom")
                              .doc(widget.chatroomId)
                              .collection("chats")
                              .doc(chat_sorted[index])
                              .delete();
                        }

                        return messages_bubble(size, map, delete);
                      }));
                } else {
                  return Container();
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            height: size.height / 10,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(3, 0),
                    blurRadius: 6,
                  ),
                ],
              ),
              height: size.height / 14,
              width: size.width / 1.1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Stack(children: [
                  GestureDetector(
                    onTap: _scrollDown,
                    child: AutoSizeTextField(
                      maxLines: 4,
                      textAlign: TextAlign.start,
                      controller: message_send,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter message",
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: LottieBuilder.network(
                              "https://assets5.lottiefiles.com/packages/lf20_urbk83vw.json"),
                        ),
                        GestureDetector(
                          onTap: () async {
                            onSend(widget.recipient['dp'],
                                widget.recipient['full_name']);
                            await _scrollDown();
                          },
                          child: LottieBuilder.network(
                            "https://assets6.lottiefiles.com/packages/lf20_txpagpud.json",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget messages_bubble(
      Size size, Map<String, dynamic> data, Function onDelete) {
    return data['type'] == "text"
        ? GestureDetector(
            onLongPress: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(
                children: [
                  TextButton.icon(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete_forever),
                      label: Text("Delete"))
                ],
              )));
            },
            child: Container(
              width: size.width / 2,
              alignment: data['sendby'] ==
                      FirebaseAuth.instance.currentUser.displayName
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: data['sendby'] ==
                            FirebaseAuth.instance.currentUser.displayName
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: data['sendby'] ==
                            FirebaseAuth.instance.currentUser.displayName
                        ? [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              margin: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              decoration: BoxDecoration(
                                  borderRadius: data['sendby'] ==
                                          FirebaseAuth
                                              .instance.currentUser.displayName
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          topRight: Radius.circular(25),
                                          bottomLeft: Radius.circular(25),
                                        )
                                      : BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          topRight: Radius.circular(25),
                                          bottomRight: Radius.circular(25),
                                        ),
                                  color: data['sendby'] ==
                                          FirebaseAuth
                                              .instance.currentUser.displayName
                                      ? Colors.blue
                                      : Colors.white,
                                  boxShadow: data['sendby'] ==
                                          FirebaseAuth
                                              .instance.currentUser.displayName
                                      ? [
                                          BoxShadow(
                                            color: Colors.lightBlue,
                                            offset: Offset(2, 3),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(3, 0),
                                            blurRadius: 6,
                                          ),
                                        ]),
                              child: Text(
                                data['message'],
                                style: GoogleFonts.raleway(
                                  color: data['sendby'] ==
                                          FirebaseAuth
                                              .instance.currentUser.displayName
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Avatar.small(
                              url: FirebaseAuth.instance.currentUser.photoURL,
                            ),
                          ]
                        : [
                            Avatar.small(
                              url: widget.recipient['dp'],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              margin: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              decoration: BoxDecoration(
                                  borderRadius: data['sendby'] ==
                                          FirebaseAuth
                                              .instance.currentUser.displayName
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          topRight: Radius.circular(25),
                                          bottomLeft: Radius.circular(25),
                                        )
                                      : BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          topRight: Radius.circular(25),
                                          bottomRight: Radius.circular(25),
                                        ),
                                  color: data['sendby'] ==
                                          FirebaseAuth
                                              .instance.currentUser.displayName
                                      ? Colors.blue
                                      : Colors.white,
                                  boxShadow: data['sendby'] ==
                                          FirebaseAuth
                                              .instance.currentUser.displayName
                                      ? [
                                          BoxShadow(
                                            color: Colors.lightBlue,
                                            offset: Offset(2, 3),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(3, 0),
                                            blurRadius: 6,
                                          ),
                                        ]),
                              child: Text(
                                data['message'],
                                style: GoogleFonts.raleway(
                                  color: data['sendby'] ==
                                          FirebaseAuth
                                              .instance.currentUser.displayName
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: size.height / 2.5,
              width: size.width,
              alignment: data['sendby'] ==
                      FirebaseAuth.instance.currentUser.displayName
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: data['sendby'] ==
                        FirebaseAuth.instance.currentUser.displayName
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisAlignment: data['sendby'] ==
                        FirebaseAuth.instance.currentUser.displayName
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: data['sendby'] ==
                        FirebaseAuth.instance.currentUser.displayName
                    ? [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FullScreen(pic: data['message']),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: size.height / 2.5,
                            width: size.width / 2,
                            alignment: Alignment.center,
                            child: data['message'] != ""
                                ? Image.network(
                                    data['message'],
                                    fit: BoxFit.cover,
                                  )
                                : CircularProgressIndicator(),
                          ),
                        ),
                        Avatar.small(
                          url: FirebaseAuth.instance.currentUser.photoURL,
                        ),
                      ]
                    : [
                        Avatar.small(
                          url: widget.recipient['dp'],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FullScreen(pic: data['message']),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: size.height / 2.5,
                            width: size.width / 2,
                            alignment: Alignment.center,
                            child: data['message'] != ""
                                ? Image.network(
                                    data['message'],
                                    fit: BoxFit.cover,
                                  )
                                : CircularProgressIndicator(),
                          ),
                        ),
                      ],
              ),
            ),
          );
  }
}
