import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mongo_dart/mongo_dart.dart' as dbLib;
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

import 'package:http/http.dart' as http;
import 'package:shoppingapp/utils/colors.dart';
import 'package:shoppingapp/utils/globalValues.dart';
import 'package:shoppingapp/widgets/slider_dotProductDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage(
      {Key? key, required this.productId, this.productImage, this.productData})
      : super(key: key);
  final String productId;
  final String? productImage;
  final dynamic productData;
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;
  int _carouselCurrentPage = 0;
  ScrollController tempScroll = ScrollController();
  double radius = 40;
  int piece = 1;

  @override
  void initState() {
    tempScroll = ScrollController()
      ..addListener(() {
        setState(() {
          print(tempScroll.position.viewportDimension);
        });
      });

    fetchData();

    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller!, curve: Curves.easeInToLinear));
    controller!.forward();
  }

  dynamic productDetails = {};

  List productImages = [];
  List<String> productImagesurl = [];
  List listCartItems = [];

  String productPrice = "";
  int productQty = 1;
  String productAvailabeQty = "";

  String productOverview = "";

  bool _flag = false;

  Future<void> fetchData() async {
    var dataAllProducts = await globaldb!
        .collection("productDetails")
        .findOne(dbLib.where.eq("productId", int.parse(widget.productId)));

    if (dataAllProducts != null) {
      print(dataAllProducts["productDetail"]);
      List imagesTemp = dataAllProducts["productImages"];
      List<String> listofImagesLink = [];
      for (int i = 0; i < imagesTemp.length; i++) {
        listofImagesLink.add(imagesTemp[i]["image_url"] ?? "");
      }
      setState(() {
        productDetails = dataAllProducts["productDetail"];
        productImages = dataAllProducts["productImages"];
        productImagesurl = listofImagesLink;
        productOverview =
            dataAllProducts["productDetail"]["overview"].toString();
        productPrice = dataAllProducts["price"]["discounted_price"].toString();
        _flag = true;
      });
    }
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
    );
    List<Widget> imageSliders = productImages.map((item) {
      print(item.toString());
      return Container(
        height: MediaQuery.of(context).size.height / 1.5,
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: ScreenUtil.getHeight(context) / 1.2,
                  color: Colors.white,
                  child: InteractiveViewer(
                    panEnabled: false, // Set it to false
                    boundaryMargin: EdgeInsets.all(100),
                    minScale: 0.5,
                    maxScale: 2,
                    child: FadeInImage(
                      image: NetworkImage(
                          globalImagesLink + item['image_url'].toString()),
                      placeholder: AssetImage("assets/images/sIcon.png"),
                      fit: BoxFit.fitHeight,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                )),
          ],
        ),
      );
    }).toList();

    List<Widget> imageSlidersPlaceHolder = productImages
        .map((item) => Container(
              padding: EdgeInsets.only(bottom: 12),
              height: MediaQuery.of(context).size.height / 1.3,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.3,
                      color: mainColorPrimary,
                      child: Image.asset("assets/images/sIcon.png",
                          fit: BoxFit.fitHeight, width: 220.0),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 20),
                    Container(
                        child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              if (userId == "") {
                                globaldisplayDialogAskForLogin(context,
                                    'Dear customer, you must login before adding products to wishlist.\n\nWould you like to login?');
                              } else {
                                await addToWishList(widget.productId);
                              }
                            })),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(width: 5),
                    Container(
                      child: TextButton(
                        onPressed: () async {
                          if (userId == "") {
                            globaldisplayDialogAskForLogin(context,
                                "Please Login before adding product to the cart.\n\nWould you like to login?");
                          } else {
                            var dataAllProducts = await globaldb!
                                .collection("productList1")
                                .findOne(dbLib.where.eq(
                                    "product_id", int.parse(widget.productId)));
                            await SharedPreferences.getInstance().then((prefs) {
                              List cartListTemp = jsonDecode(
                                  prefs.getString("cartList") ?? "[]");
                              cartListTemp.add(dataAllProducts);

                              prefs.setString(
                                  "cartItems", jsonEncode(cartListTemp));
                              setState(() {
                                cartcount = cartListTemp.length;
                              });

                              Fluttertoast.showToast(
                                  msg: "Product added to Cart");
                            });
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(mainColorPrimary)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Add to Cart",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: mainColorSecondry,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                //  controller: scrollController,
                child: ((_flag))
                    ? Column(
                        children: <Widget>[
                          CarouselSlider(
                            items: ((imageSliders.length > 0))
                                ? imageSliders
                                : imageSlidersPlaceHolder,
                            options: CarouselOptions(
                                autoPlay: false,
                                enableInfiniteScroll: false,
                                height:
                                    MediaQuery.of(context).size.height / 2.5,
                                viewportFraction: 1.0,
                                enlargeCenterPage: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _carouselCurrentPage = index;
                                  });
                                }),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.2),
                                    blurRadius: 6.0, // soften the shadow
                                    spreadRadius: 0.0, //extend the shadow
                                    offset: Offset(
                                      0.0, // Move to right 10  horizontally
                                      1.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(26)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SliderDotProductDetail2(
                                      current: _carouselCurrentPage,
                                      imageUrl: productImagesurl),
                                ),
                                Text(productDetails['product_name'].toString(),
                                    style: GoogleFonts.poppins(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF5D6A78))),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              "Price: ",
                                              style: GoogleFonts.poppins(
                                                  color: mainColorPrimary,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              productPrice,
                                              style: GoogleFonts.poppins(
                                                  color: mainColorPrimary,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              " " + currencUnit,
                                              style: GoogleFonts.poppins(
                                                  color: mainColorPrimary,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),

                                        SizedBox(
                                          height: 6,
                                        ),
                                        // Text(
                                        //   "Free cargo",
                                        //   style: GoogleFonts.poppins(
                                        //       color: Color(0xFF5D6A78),
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.w400),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.2),
                                    blurRadius: 6.0, // soften the shadow
                                    spreadRadius: 0.0, //extend the shadow
                                    offset: Offset(
                                      0.0, // Move to right 10  horizontally
                                      1.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(26)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Product Overview:",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Html(
                                    data: Uri.decodeComponent(productOverview),
                                    // defaultTextStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: SpinKitWave(
                          color: mainColorPrimary,
                          size: 30.0,
                        ),
                      ),
              ),
              Positioned(
                left: 9,
                top: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.chevron_left,
                      color: mainColorPrimary,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 24,
                top: 0,
                child: Container(
                  height: 42,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: mainColorPrimaryLight.withOpacity(0.8),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (userId == "") {
                        globaldisplayDialogAskForLogin(context,
                            'Dear customer, you must login before viewing the cart.\n\nWould you like to login?');
                      } else {}
                    },
                    child: Badge(
                      animationDuration: Duration(milliseconds: 1500),
                      badgeColor: mainColorPrimary,
                      alignment: Alignment(0, 0),
                      position: BadgePosition.bottomEnd(),
                      padding: EdgeInsets.all(8),
                      badgeContent: Text(
                        cartcount.toString(),
                        // globalcartTotal.toString(),
                        //  calculateTotalQty(listCartItems)
                        //       .toStringAsFixed(0),
                        //  listCartItems.length.toString(),
                        style:
                            TextStyle(color: mainColorSecondry, fontSize: 10),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/ic_shopping_cart.svg",
                        color: Colors.white,
                        height: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displayDialogAskForLogin(
    BuildContext context,
  ) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sindbaad'),
            content: Text(
                'Dear customer, you must login before asking any question.\n\nWould you like to login?'),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  'No',
                  style: GoogleFonts.poppins(color: mainColorPrimary),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text(
                  'Yes',
                  style: GoogleFonts.poppins(color: mainColorPrimary),
                ),
                onPressed: () {
                  // globalLoginStatus = true;
                  // globalassignWidgetAfterLogin = ProductDetailPage(
                  //   productId: widget.productId,
                  //   productImage: globalAPILink +
                  //       "/UploadedFiles/20-208593_samsung-mobile-charger-png-mobile-charger-png-clipart_2021-02-08_11-58-07-PM.png",
                  // );
                  // Navigator.of(context)
                  //     .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                },
              )
            ],
          );
        });
  }

  _displayDialogAskForLoginASk(BuildContext context, Widget widget) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sindbaad'),
            content: Text(
                'Dear customer, you must login before requesting for the quotation\n\nWould you like to login?'),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  'No',
                  style: GoogleFonts.poppins(color: mainColorPrimary),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text(
                  'Yes',
                  style: GoogleFonts.poppins(color: mainColorPrimary),
                ),
                onPressed: () {
                  // globalLoginStatus = true;
                  // globalassignWidgetAfterLogin = widget;
                  // Navigator.of(context)
                  //     .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                },
              )
            ],
          );
        });
  }
}
