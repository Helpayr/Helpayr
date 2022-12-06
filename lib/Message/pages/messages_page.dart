import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/Message/theme.dart';
import 'package:helpayr/constants/Theme.dart';
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

  void onSearch() async {
    await FirebaseFirestore.instance
        .collection("Helpers")
        .doc("People")
        .collection("Servicers")
        .where("name", isEqualTo: name_search_controller.text)
        .get()
        .then((value) {
      setState(() {
        userInfo = value.docs[0].data();
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8),
        child: Column(
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
              height: 30,
            ),
            userInfo != null
                ? GestureDetector(
                    onTap: () {
                      String roomId = chatRoomId(
                          FirebaseAuth.instance.currentUser.displayName,
                          userInfo['name']);
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => DraggableScrollableSheet(
                                snap: false,
                                initialChildSize: .90,
                                minChildSize: .50,
                                maxChildSize: .90,
                                builder: (context, myScroll) => Chatroom(
                                  recipient: userInfo,
                                  chatroomId: roomId,
                                ),
                              ));
                    },
                    child: Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 3, color: Colors.black),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(userInfo['dp']))),
                            ),
                            Column(
                              children: [
                                Text(
                                  '${userInfo['name']}',
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  )
                : Container()
          ],
        ),
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
        .then((value) => value.docs.forEach((element) {
              artsDocs.add(element.reference.id);
            }));
  }

  Future _future;
  @override
  void initState() {
    _future = getDocsArt();
    super.initState();
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
                height: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 16),
                      child: Text(
                        'Stories',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: HelpayrColors.black.withOpacity(.5),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: artsDocs.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 60,
                              child: GestureDetector(
                                onTap: () {},
                                child: _StoryCard(
                                  artsDocs[index],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
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
              Avatar.medium(url: data['dp']),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    '${data['name']}'.trimRight(),
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
