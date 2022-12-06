import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/constants/services_tentative.dart';
import 'package:helpayr/services/freelance/freelance.dart';
import 'package:helpayr/widgets/card-horizontal.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'List_data_page.dart';

class HelperList extends StatefulWidget {
  const HelperList({
    key,
    this.scrollController,
    this.display_type,
    this.helper_type,
    this.isService = false,
    this.isStore = false,
    this.isAdmin = false,
    this.isService_dp = false,
  });
  final ScrollController scrollController;
  final String display_type;
  final String helper_type;
  final bool isService;
  final bool isStore;
  final bool isAdmin;
  final bool isService_dp;

  State<HelperList> createState() => _HelperListState();
}

class _HelperListState extends State<HelperList> {
  List<String> services = [];
  Future getDocs() async {
    await FirebaseFirestore.instance
        .collection(widget.display_type)
        .get()
        .then((value) => value.docs.forEach((element) {
              services.add(element.reference.id);
            }));
  }

  Future _future;

  @override
  void initState() {
    super.initState();
    _future = getDocs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) => Container(
        width: widget.isStore
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width,
        height: widget.isStore ? 230 : MediaQuery.of(context).size.height / 1.5,
        child: ListView.builder(
          physics: widget.isStore
              ? BouncingScrollPhysics()
              : NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          controller: widget.scrollController,
          scrollDirection: widget.isAdmin
              ? Axis.vertical
              : widget.isStore
                  ? Axis.horizontal
                  : Axis.vertical,
          itemCount: services.length,
          itemBuilder: ((context, index) => TypeImageDisplay(
                isAdmin: widget.isAdmin,
                isService_dp: widget.isService_dp,
                isStore: widget.isStore,
                isService: widget.isService,
                display_type: widget.display_type,
                services: services[index],
                DocId: services[index],
                helperType: widget.helper_type,
                colors: colors[index],
                service_title: [services],
              )),
        ),
      ),
    );
  }
}

class TypeImageDisplay extends StatefulWidget {
  const TypeImageDisplay(
      {key,
      this.display_type,
      this.DocId,
      this.services,
      this.helperType,
      this.isService = false,
      this.colors,
      this.service_title,
      this.isStore = false,
      this.isService_dp = false,
      this.isAdmin = false});
  final String display_type;
  final String DocId;
  final String services;
  final String helperType;
  final bool isService;
  final Color colors;
  final List service_title;
  final bool isStore;
  final bool isService_dp;
  final bool isAdmin;
  @override
  State<TypeImageDisplay> createState() => _TypeImageDisplayState();
}

class _TypeImageDisplayState extends State<TypeImageDisplay> {
  @override
  Widget build(BuildContext context) {
    CollectionReference images =
        FirebaseFirestore.instance.collection(widget.display_type);
    return FutureBuilder(
      future: images.doc(widget.DocId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data.data() as Map<String, dynamic>;

          return widget.isStore
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Stack(children: [
                        Column(
                          children: [
                            Flexible(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Swiper(
                                  physics: NeverScrollableScrollPhysics(),
                                  viewportFraction: .9,
                                  autoplay: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: ((context, index) => Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Card(
                                          elevation: 10,
                                          child: Container(
                                            height: 120,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        data['display']
                                                            [index]))),
                                          ),
                                        ),
                                      )),
                                  itemCount: data['display'].length,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${data['store_name']}',
                                          style: GoogleFonts.raleway(
                                              color: Color.fromARGB(
                                                  255, 5, 26, 43),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${data['address']}',
                                          style: GoogleFonts.raleway(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Positioned(
                          right: 4,
                          bottom: 23,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: widget.isService_dp
                                ? Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 5, color: Colors.white),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(3, 0),
                                          blurRadius: 6,
                                        ),
                                      ],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Swiper(
                                        autoplay: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: data['dp'].length,
                                        itemBuilder: ((context, index) {
                                          return Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    data['dp'][index]),
                                              ),
                                            ),
                                          );
                                        })),
                                  )
                                : Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 5, color: Colors.white),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(3, 0),
                                            blurRadius: 6,
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(data['dp']))),
                                  ),
                          ),
                        ),
                        Positioned(
                          left: 4,
                          bottom: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              elevation: 10,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${data['job']}',
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.isAdmin
                                ? showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) =>
                                        DraggableScrollableSheet(
                                          snap: false,
                                          initialChildSize: .70,
                                          minChildSize: .50,
                                          maxChildSize: .80,
                                          builder: (context, myScroll) =>
                                              ListData(
                                            isAdmin: true,
                                            title: data['job'],
                                            isService: widget.isService,
                                            userType: "Helpers",
                                            service: widget.helperType,
                                            type: widget.services,
                                          ),
                                        ))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FreeLanceHome(
                                              img_display_1: data['display'][0],
                                              img_display_2: data['display'][1],
                                              service_title: data['job'],
                                              onTap: () {
                                                showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    builder: (context) =>
                                                        DraggableScrollableSheet(
                                                          snap: false,
                                                          initialChildSize: .90,
                                                          minChildSize: .50,
                                                          maxChildSize: 1,
                                                          builder: (context,
                                                                  myScroll) =>
                                                              ListData(
                                                            title: data['job'],
                                                            isService: widget
                                                                .isService,
                                                            userType: "Helpers",
                                                            service: widget
                                                                .helperType,
                                                            type:
                                                                widget.services,
                                                          ),
                                                        ));
                                                ;
                                              },
                                            )),
                                  );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                widget.isAdmin ? "Manage" : "See More",
                                style: GoogleFonts.raleway(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                )
              : ServiceListCard(
                  widget: widget,
                  data: data,
                );
        }
        return Container();
      }),
    );
  }
}

class ServiceListCard extends StatelessWidget {
  const ServiceListCard({
    Key key,
    @required this.widget,
    @required this.data,
  }) : super(key: key);

  final TypeImageDisplay widget;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 170,
        width: MediaQuery.of(context).size.width,
        child: CardHorizontal(
          color: widget.colors,
          title: data['description'],
          isSvg: true,
          serviceType: widget.services,
          img: data['pic'],
          tap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FreeLanceHome(
                        img_display_1: data['display'][0],
                        img_display_2: data['display'][1],
                        service_title: data['job'],
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => DraggableScrollableSheet(
                                    snap: false,
                                    initialChildSize: .90,
                                    minChildSize: .50,
                                    maxChildSize: 1,
                                    builder: (context, myScroll) => ListData(
                                      title: data['job'],
                                      isService: widget.isService,
                                      userType: "Helpers",
                                      service: widget.helperType,
                                      type: widget.services,
                                    ),
                                  ));
                          ;
                        },
                      )),
            );
          },
        ),
      ),
    );
  }
}
