import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'getData.dart';

class ProductViewAll extends StatefulWidget {
  const ProductViewAll({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final MainPageReturner widget;

  @override
  State<ProductViewAll> createState() => _ProductViewAllState();
}

class _ProductViewAllState extends State<ProductViewAll> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage('assets/onboarding new/bg_wavy.png')),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 90,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Products",
                style: GoogleFonts.raleway(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: widget.widget.data['image'].length,
                    itemBuilder: ((context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = index;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                duration: Duration(seconds: 3),
                                elevation: 10,
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${widget.widget.data['product_name'][index]}',
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Php. ${widget.widget.data['prices'][index]}',
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 10,
                              child: AnimatedContainer(
                                curve: Curves.easeInOut,
                                duration: Duration(milliseconds: 200),
                                height: selected == index
                                    ? MediaQuery.of(context).size.height / 4
                                    : MediaQuery.of(context).size.height / 4.4,
                                width: selected == index
                                    ? MediaQuery.of(context).size.width
                                    : MediaQuery.of(context).size.width / 1.1,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(children: [
                                    Flexible(
                                      flex: selected == index ? 3 : 2,
                                      child: Card(
                                        elevation: 10,
                                        child: AnimatedContainer(
                                          curve: Curves.ease,
                                          duration: Duration(milliseconds: 500),
                                          width: 200,
                                          height: 180,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                    widget.widget.data['image']
                                                        [index],
                                                  ))),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: selected == index ? 1 : 2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey,
                                                width: 1.5,
                                              ),
                                            )),
                                            child: selected == index
                                                ? Icon(
                                                    FontAwesomeIcons.cartPlus)
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: FittedBox(
                                                      fit: BoxFit.fitWidth,
                                                      child: Text(
                                                        '${widget.widget.data['product_name'][index]}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            selected == index
                                                ? "Purchase"
                                                : 'Php. ${widget.widget.data['prices'][index]}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
