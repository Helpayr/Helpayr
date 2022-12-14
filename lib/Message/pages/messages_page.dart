import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/Message/theme.dart';
import 'package:helpayr/constants/Theme.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/message_data.dart';
import '../helpers.dart';
import '../screens/convo_screen.dart';
import '../widgets/avatar.dart';
import 'chatroom.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    }
    return "$user2$user1";
  }

  TextEditingController name_search_controller = TextEditingController();
  Map<String, dynamic> userInfo;
  Future _future;

  Future _lastchat() async {
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId(
            FirebaseAuth.instance.currentUser.displayName, userInfo['name']))
        .collection("chats")
        .orderBy("time", descending: false)
        .get();
  }

  @override
  void initState() {
    _future = _lastchat();
    super.initState();
  }

  void onSearch() async {
    await FirebaseFirestore.instance
        .collection("Helpers")
        .doc("People")
        .collection("Servicers")
        .where("full_name", isEqualTo: name_search_controller.text)
        .get()
        .then((value) {
      setState(() {
        userInfo = value.docs[0].data();
      });
    });
  }

  int chatSelected = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: AnimSearchBar(
                  autoFocus: true,
                  closeSearchOnSuffixTap: false,
                  suffixIcon: Icon(Icons.search_rounded),
                  width: 250,
                  textController: name_search_controller,
                  onSuffixTap: () {},
                ),
              ),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.white,
                    ),
                  ),
                  onPressed: () {
                    onSearch();
                  },
                  child: Text(
                    "Search",
                    style: GoogleFonts.raleway(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          _Stories(),
          SizedBox(
            height: 10,
          ),
          userInfo != null
              ? GestureDetector(
                  onTap: () {
                    String roomId = chatRoomId(
                        FirebaseAuth.instance.currentUser.displayName,
                        userInfo['full_name']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Chatroom(
                                recipient: userInfo,
                                chatroomId: roomId,
                              )),
                    );
                  },
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chatroom')
                        .doc(chatRoomId(
                            FirebaseAuth.instance.currentUser.displayName,
                            userInfo['full_name']))
                        .collection("chats")
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (context, snapshot) => Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 3, color: Colors.black),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(userInfo['dp']))),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${userInfo['full_name']}',
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${snapshot.data.docs[snapshot.data.docs.length - 1]['message']}',
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Helpers")
                        .doc("People")
                        .collection("Servicers")
                        .snapshots(),
                    builder: (context, snapshot_user) {
                      return ListView.builder(
                        itemCount: snapshot_user.data.docs.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('chatroom')
                                .doc(chatRoomId(
                                    FirebaseAuth
                                        .instance.currentUser.displayName,
                                    snapshot_user.data.docs[index]
                                        ['full_name']))
                                .collection("chats")
                                .orderBy("time", descending: false)
                                .snapshots(),
                            builder: (context, snapshot) {
                              DateTime lastLog =
                                  (snapshot.data.docs[index]['time'].toDate());
                              String time_sent =
                                  DateFormat.yMMMd().add_jm().format(lastLog);

                              return InkWell(
                                onTap: () {
                                  chatSelected = index;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Chatroom(
                                        recipient: snapshot_user
                                            .data.docs[chatSelected]
                                            .data(),
                                        chatroomId: mod_chat(
                                          FirebaseAuth
                                              .instance.currentUser.displayName,
                                          snapshot_user.data.docs[chatSelected]
                                              .data(),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 120,
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Row(
                                          children: [
                                            Avatar.large(
                                              url: snapshot_user
                                                  .data.docs[index]['dp'],
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${snapshot_user.data.docs[index]['full_name']}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Text(
                                                  '${snapshot.data.docs[snapshot.data.docs.length - 1]['message']}',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: snapshot.data
                                                                          .docs[
                                                                      index]
                                                                  ['sendby'] !=
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  .displayName
                                                          ? FontWeight.bold
                                                          : FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${time_sent}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        width: 40,
        height: 40,
        child: FloatingActionButton(
          child: Center(
              child: Icon(
            FontAwesomeIcons.pen,
            size: 20,
          )),
          backgroundColor: HelpayrColors.info,
          elevation: 1,
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _delegate(BuildContext context, int index) {
    final Faker faker = Faker();
    final time = DateTime.now();

    return Slidable(
      endActionPane: ActionPane(motion: StretchMotion(), children: [
        SlidableAction(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          spacing: 2,
          backgroundColor: Colors.red,
          icon: Icons.delete,
          label: 'Delete',
          onPressed: ((context) => {}),
        ),
      ]),
      child: MainMessages(
        messageInfo: MessageInformation(
            faker.person.name(),
            faker.lorem.sentence(),
            time,
            Jiffy(time).fromNow(),
            Helpers.randomPictureUrl()),
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

class MainMessages extends StatelessWidget {
  const MainMessages({key, this.messageInfo});
  final MessageInformation messageInfo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.lightBlue.withOpacity(.5),
      hoverColor: Colors.blue.withOpacity(.07),
      onTap: () {
        Navigator.of(context).push(Convo.route(messageInfo));
      },
      onLongPress: () {
        print("working");
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: .2),
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Avatar.medium(
                url: messageInfo.dp,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      messageInfo.sendName,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    messageInfo.message,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    messageInfo.dateMessage.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.textFaded,
                      fontSize: 8,
                      letterSpacing: -.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 13,
                      width: 13,
                      decoration: BoxDecoration(
                        color: HelpayrColors.info,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(
                            "1",
                            style: TextStyle(
                              color: HelpayrColors.white,
                              fontSize: 7,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Stories extends StatefulWidget {
  const _Stories({Key key}) : super(key: key);

  @override
  State<_Stories> createState() => _StoriesState();
}

class _StoriesState extends State<_Stories> {
  List<String> artsDocs = [];
  List<String> serviceId = [];
  Future getDocsArt() async {
    await FirebaseFirestore.instance
        .collection("Helpers")
        .doc("People")
        .collection("Servicers")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        artsDocs.add(element.reference.id);
      });
    });
  }

  Future _future;
  @override
  void initState() {
    _future = getDocsArt();
    super.initState();
  }

  int isChat_selected = 0;
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    }
    return "$user2$user1";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: ((context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              color: Colors.grey.withOpacity(0.03),
              elevation: 0,
              shadowColor: Colors.grey.withOpacity(.7),
              child: SizedBox(
                height: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 16),
                      child: Text(
                        'Stories',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: HelpayrColors.black.withOpacity(.5),
                        ),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Helpers")
                            .doc("People")
                            .collection("Servicers")
                            .snapshots(),
                        builder: (context, snapshot) => ListView.builder(
                          itemCount: artsDocs.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 60,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isChat_selected = index;
                                    });
                                    Map<String, dynamic> map =
                                        snapshot.data.docs[index].data();

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Chatroom(
                                              recipient: snapshot
                                                  .data.docs[isChat_selected]
                                                  .data(),
                                              chatroomId: mod_chat(
                                                  FirebaseAuth.instance
                                                      .currentUser.displayName,
                                                  map)),
                                        ));
                                  },
                                  child: _StoryCard(
                                    artsDocs[index],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
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

class _StoryCard extends StatefulWidget {
  const _StoryCard(
    this.docArt,
  );
  final String docArt;

  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard> {
  @override
  Widget build(BuildContext context) {
    CollectionReference art = FirebaseFirestore.instance
        .collection("Helpers")
        .doc("People")
        .collection("Servicers");

    return FutureBuilder(
      future: art.doc(widget.docArt).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data.data() as Map<String, dynamic>;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(3, 0),
                        blurRadius: 6,
                      ),
                    ],
                    shape: BoxShape.circle,
                    border: Border.all(width: 4, color: Colors.white),
                    image: DecorationImage(image: NetworkImage(data['dp']))),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    '${data['full_name']}'.trimRight(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return Container();
      }),
    );
  }
}
