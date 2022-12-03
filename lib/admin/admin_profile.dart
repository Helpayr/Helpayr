import 'package:flutter/material.dart';

import '../firebase/googleSignIn.dart';
import '../main.dart';
import '../screens/googleLogin.dart';
import 'package:provider/provider.dart';

class Admin_Profile extends StatelessWidget {
  const Admin_Profile({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/imgs/register-bg.png"),
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 80.0, left: 30, right: 30, bottom: 80),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Are you sure you want to log-out?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  final provider =
                                      Provider.of<GoogleSignUpProvider>(context,
                                          listen: false);
                                  provider.logout().then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            noback(wid: ChooseLogin()),
                                      ),
                                    );
                                  });
                                },
                                child: Text("Yes"),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("No"))
                            ],
                          );
                        });
                  },
                  child: Icon(Icons.exit_to_app)),
            ),
          ),
        ),
      ),
    );
  }
}
