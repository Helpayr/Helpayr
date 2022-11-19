import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpayr/constants/services_tentative.dart';
import 'package:helpayr/services/freelance/freelance.dart';
import 'package:helpayr/widgets/card-horizontal.dart';

import 'List_data_page.dart';

class HelperList extends StatefulWidget {
  const HelperList(
      {key,
      this.scrollController,
      this.display_type,
      this.helper_type,
      this.isService = false});
  final ScrollController scrollController;
  final String display_type;
  final String helper_type;
  final bool isService;
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDocs(),
      builder: (context, snapshot) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.5,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          controller: widget.scrollController,
          scrollDirection: Axis.vertical,
          itemCount: services.length,
          itemBuilder: ((context, index) => TypeImageDisplay(
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
      this.service_title});
  final String display_type;
  final String DocId;
  final String services;
  final String helperType;
  final bool isService;
  final Color colors;
  final List service_title;
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

          return ServiceListCard(
            widget: widget,
            data: data,
          );
        }
        return Container(
          child: Center(child: CircularProgressIndicator()),
        );
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
        height: 150,
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
