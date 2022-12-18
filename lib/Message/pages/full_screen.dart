import 'package:flutter/material.dart';

class FullScreen extends StatelessWidget {
  const FullScreen({key, this.pic});

  final String pic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(pic),
          ),
        ),
      ),
    );
  }
}
