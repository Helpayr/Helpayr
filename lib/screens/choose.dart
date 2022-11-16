import 'package:flutter/material.dart';

class Sample extends StatefulWidget {
  const Sample({key});

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TextButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) => DraggableScrollableSheet(
                  initialChildSize: .64,
                  minChildSize: .2,
                  maxChildSize: 1,
                  builder: (context, scrollController) {
                    return Container(
                      color: Colors.red,
                    );
                  },
                ));
      },
      child: Center(
        child: Text(
          "PressMe",
          style: TextStyle(color: Colors.red),
        ),
      ),
    ));
  }
}
