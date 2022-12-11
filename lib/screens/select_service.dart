import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/constants/services_tentative.dart';
import 'package:helpayr/screens/servicer_dashboard.dart';
import 'package:hidable/hidable.dart';

class Service_ChooseFirst extends StatefulWidget {
  const Service_ChooseFirst({key});

  @override
  State<Service_ChooseFirst> createState() => _Service_ChooseFirstState();
}

class _Service_ChooseFirstState extends State<Service_ChooseFirst> {
  @override
  List<String> services = [];
  Future getService() async {
    FirebaseFirestore.instance
        .collection("Service_Display")
        .get()
        .then((value) => value.docs.forEach((element) {
              services.add(element.reference.id);
            }));
  }

  @override
  void initState() {
    super.initState();
    getService();
  }

  int selected = 0;
  bool isProceed = false;
  String show_service = "";
  ScrollController _scroll = ScrollController();

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection("Service_Display").snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: SafeArea(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Please select the service that you provide",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${show_service}",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            controller: _scroll,
                            itemCount: snapshot.data.docs.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 15,
                            ),
                            itemBuilder: ((context, index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selected = index;
                                      show_service = services[selected];
                                    });
                                  },
                                  child: Container(
                                    child: Column(
                                      children: [
                                        AnimatedContainer(
                                          curve: Curves.easeInOut,
                                          duration: Duration(milliseconds: 300),
                                          height: selected == index ? 130 : 120,
                                          width: selected == index ? 130 : 120,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(3, 0),
                                                blurRadius: 6,
                                              ),
                                            ],
                                            color: selected == index
                                                ? colors[index]
                                                : Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.network(
                                            snapshot.data.docs[index]['pic'],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          '${services[index]}',
                                          style: GoogleFonts.raleway(
                                            color: colors[index],
                                            fontWeight: selected == index
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            bottomSheet: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Servicer_Dashboard(
                      service: services[selected],
                    ),
                  ),
                );
              },
              splashColor: Colors.blue,
              child: Hidable(
                controller: _scroll,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(3, 0),
                            blurRadius: 6,
                          ),
                        ],
                        color: colors[selected],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Proceed to Dashboard",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      }),
    );
  }
}
