import 'package:flutter/material.dart';

import '../widgets/thisfreelance.dart';

class HomeFreelance extends StatefulWidget {
  const HomeFreelance({key});

  @override
  State<HomeFreelance> createState() => _HomeFreelanceState();
}

class _HomeFreelanceState extends State<HomeFreelance> {
  final List<String> photos = [
    "https://images.unsplash.com/photo-1575318634028-6a0cfcb60c59?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=386&q=80",
    "https://images.unsplash.com/photo-1575318634026-38fb9e8157d7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=386&q=80",
    "https://images.unsplash.com/photo-1589900283218-4c1ef79fad72?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1374&q=80"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: ThisFreelance(
        title: "Freelancing",
        first_pic: photos[0],
        sec_pic: photos[1],
      ),
    );
  }
}
