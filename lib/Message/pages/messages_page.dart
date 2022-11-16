import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpayr/Message/theme.dart';
import 'package:helpayr/constants/Theme.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/message_data.dart';
import '../../models/story_data.dart';
import '../helpers.dart';
import '../screens/convo_screen.dart';
import '../widgets/avatar.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _Stories(),
            ),
            SliverList(delegate: SliverChildBuilderDelegate(_delegate))
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

class _Stories extends StatelessWidget {
  const _Stories({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final faker = Faker();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 60,
                        child: _StoryCard(
                          storyData: StoryData(
                            name: faker.person.firstName(),
                            url: Helpers.randomPictureUrl(),
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
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    Key key,
    this.storyData,
  }) : super(key: key);

  final StoryData storyData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Avatar.medium(url: storyData.url),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              storyData.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                letterSpacing: 0.3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
