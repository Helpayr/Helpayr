import 'package:flutter/material.dart';
import 'package:helpayr/firebase/googleSignIn.dart';
import 'package:helpayr/helpayrapp.dart';
import 'package:helpayr/screens/articles.dart';
import 'package:helpayr/screens/login.dart';
import 'package:helpayr/screens/messaging.dart';
import 'package:helpayr/screens/onboarding/onboarding.dart';
import 'package:helpayr/screens/home.dart';
import 'package:helpayr/screens/onboarding/slide_onboarding.dart';
import 'package:helpayr/screens/profile.dart';
import 'package:helpayr/screens/settings.dart';
import 'package:helpayr/screens/register.dart';
import 'package:helpayr/screens/stores.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final client = StreamChatClient(StreamKey);
  ErrorWidget.builder = (error) => Container(
        color: Colors.transparent,
      );
  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key, this.client});
  final StreamChatClient client;
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignUpProvider(),
        child: MaterialApp(
            builder: (context, child) {
              return StreamChatCore(client: client, child: child);
            },
            title: 'Helpayr',
            darkTheme: ThemeData.dark(useMaterial3: true),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                fontFamily: 'Montserrat',
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: Colors.black.withOpacity(0)),
                bottomSheetTheme: BottomSheetThemeData(
                    backgroundColor: Colors.black.withOpacity(0))),
            home: SlideOnboarding(),
            routes: <String, WidgetBuilder>{
              '/home': (BuildContext context) => noback(
                    wid: new Home(),
                  ),
              '/stores': (BuildContext context) => noback(
                    wid: new Stores(),
                  ),
              '/settings': (BuildContext context) => noback(
                    wid: new Settings(
                      isHome: false,
                    ),
                  ),
              "/onboarding": (BuildContext context) => noback(
                    wid: new Onboarding(),
                  ),
              "/messaging": (BuildContext context) => noback(
                    wid: new Messaging(),
                  ),
              "/profile": (BuildContext context) => new Profile(),
              "/services": (BuildContext context) => new Services(),
              "/account": (BuildContext context) => new Register(),
              "/login": (BuildContext context) => noback(
                    wid: new LoginPage(),
                  ),
            }),
      );
}

class noback extends StatelessWidget {
  const noback({
    Key key,
    this.wid,
  }) : super(key: key);
  final Widget wid;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: wid,
      onWillPop: () async {
        return false;
      },
    );
  }
}
