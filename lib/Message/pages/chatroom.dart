import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/Message/widgets/widget.dart';
import 'package:lottie/lottie.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({key, this.recipient, this.chatroomId});
  final Map<String, dynamic> recipient;
  final String chatroomId;

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  final TextEditingController message_send = TextEditingController();

  void onSend() async {
    if (message_send.text.isNotEmpty) {
      await _firebase
          .collection('chatroom')
          .doc(widget.chatroomId)
          .collection("chats")
          .add({
        "sendby": FirebaseAuth.instance.currentUser.displayName,
        "message": message_send.text,
        "time": FieldValue.serverTimestamp(),
      });
    }
    message_send.clear();
  }

  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
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
          widget.recipient['name'],
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
            width: size.width,
            height: MediaQuery.of(context).size.height / 1.38,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebase
                  .collection("chatroom")
                  .doc(widget.chatroomId)
                  .collection("chats")
                  .orderBy("time", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: ((context, index) {
                        Map<String, dynamic> map =
                            snapshot.data.docs[index].data();
                        return messages_bubble(size, map);
                      }));
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      )),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        height: size.height / 10,
        width: size.width,
        alignment: Alignment.center,
        child: Container(
          height: size.height / 14,
          width: size.width / 1.1,
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
                AutoSizeTextField(
                  maxLines: 4,
                  textAlign: TextAlign.start,
                  controller: message_send,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter message",
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      onSend();
                    },
                    child: LottieBuilder.network(
                      "https://assets6.lottiefiles.com/packages/lf20_txpagpud.json",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget messages_bubble(Size size, Map<String, dynamic> data) {
    return Container(
      width: size.width,
      alignment: data['sendby'] == FirebaseAuth.instance.currentUser.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
              borderRadius: data['sendby'] ==
                      FirebaseAuth.instance.currentUser.displayName
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
                      FirebaseAuth.instance.currentUser.displayName
                  ? Colors.blue
                  : Colors.white,
              boxShadow: data['sendby'] ==
                      FirebaseAuth.instance.currentUser.displayName
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
                      FirebaseAuth.instance.currentUser.displayName
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
