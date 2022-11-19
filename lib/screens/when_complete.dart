import 'package:flutter/material.dart';
import 'package:helpayr/screens/profile_maker.dart';
import 'package:lottie/lottie.dart';

class WhenCompleted extends StatefulWidget {
  const WhenCompleted({key});

  @override
  State<WhenCompleted> createState() => _WhenCompletedState();
}

class _WhenCompletedState extends State<WhenCompleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileMaker(),
            ),
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/imgs/bluescreen.png")),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color.fromARGB(255, 8, 62, 107).withOpacity(.9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.network(
                "https://assets3.lottiefiles.com/datafiles/Wv6eeBslW1APprw/data.json",
                repeat: true,
                animate: true,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
