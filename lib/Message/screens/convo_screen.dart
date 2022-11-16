import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpayr/Message/widgets/widget.dart';
import 'package:helpayr/constants/Theme.dart';
import 'package:helpayr/models/models.dart';

class Convo extends StatelessWidget {
  const Convo({Key key, this.messageInfo}) : super(key: key);

  static Route route(MessageInformation data) => MaterialPageRoute(
        builder: ((context) => Convo(
              messageInfo: data,
            )),
      );

  final MessageInformation messageInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      centerTitle: true,
      leadingWidth: 54,
      leading: Align(
        alignment: Alignment.centerRight,
        child: IconBackground(
          size: 17,
          icon: Icons.back_hand,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: AppBarTitle(
        messageInfo: messageInfo,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Center(
            child: IconBorder(
              size: 16,
              icon: FontAwesomeIcons.camera,
              onTap: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Center(
            child: IconBorder(
              size: 16,
              icon: FontAwesomeIcons.phone,
              onTap: () {},
            ),
          ),
        )
      ],
    ),);
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({key, this.messageInfo});
  final MessageInformation messageInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar.small(
          url: messageInfo.dp,
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  messageInfo.sendName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    "Active Now",
                    style: TextStyle(
                        letterSpacing: 0.3,
                        color: HelpayrColors.info,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'arial'),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: HelpayrColors.info,
                      shape: BoxShape.circle,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
