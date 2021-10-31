import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppingapp/pages/productDetails.dart';
import 'package:shoppingapp/utils/colors.dart';
import 'package:shoppingapp/utils/globalValues.dart';

import '../../main.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key,
      required this.imageUrl,
      required this.pName,
      required this.pImageNetworkUrl,
      this.pProduct,
      required this.pId})
      : super(key: key);

  final String pId;
  final String imageUrl;
  final String pName;
  final String pImageNetworkUrl;
  final dynamic pProduct;

  double _getMinimumValue(dynamic minValue) {
    if (!(minValue == null || minValue == "null")) {
      return double.parse(minValue['price'].toString());
    } else {
      return 0;
    }
  }

  double _getMaximumValue(dynamic maxValue) {
    if (!(maxValue == null || maxValue == "null")) {
      return double.parse(maxValue['price'].toString());
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double minPrize = 0.0;
    double maxPrize = 0.0;
    double minPrizeDiscounted = 0.0;
    double maxPrizeDiscounted = 0.0;
    double discount = 0.0;
    bool _flag = false;
    bool _flagDiscount = false;

    if (pProduct['min']['price'].toString() == "null") {
      minPrize = 0;
    } else {
      minPrize = double.parse(pProduct['min']['price'].toString());
    }
    if (pProduct['min']['discounted_price'].toString() == "null") {
      minPrizeDiscounted = 0;
    } else {
      minPrizeDiscounted =
          double.parse(pProduct['min']['discounted_price'].toString());
    }
    if (pProduct['max']['price'].toString() == "null") {
      maxPrize = 0;
    } else {
      maxPrize = double.parse(pProduct['max']['price'].toString());
    }
    if (pProduct['max']['discounted_price'].toString() == "null") {
      maxPrizeDiscounted = 0;
    } else {
      maxPrizeDiscounted =
          double.parse(pProduct['max']['discounted_price'].toString());
    }
    discount = ((minPrize - minPrizeDiscounted) / minPrize) * 100;
    if (!(maxPrize == minPrize)) {
      _flag = true;
    }
    if (discount > 0 && discount < 100) {
      _flagDiscount = true;
    }
    if (minPrizeDiscounted == 0 || minPrizeDiscounted == 0.0) {
      minPrizeDiscounted = minPrize;
    }
    if (maxPrizeDiscounted == 0 || maxPrizeDiscounted == 0.0) {
      maxPrizeDiscounted = maxPrize;
    }
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetailPage(
                          productId: pId,
                          productImage: pImageNetworkUrl,
                          productData: pProduct,
                        )));
          },
          child: Container(
            //  width: ScreenUtil.getWidth(context) / 3,
            margin: EdgeInsets.only(left: 6, right: 6, bottom: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 5.0,
                        spreadRadius: 1,
                        offset: Offset(0.0, 2)),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: 120.0,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: FadeInImage(
                                image: NetworkImage(
                                    globalImagesLink + pImageNetworkUrl),
                                placeholder:
                                    AssetImage("assets/images/sIcon.png"),
                                fit: BoxFit.fitHeight,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: 120.0,
                    padding: EdgeInsets.only(left: 10, top: 7, right: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AutoSizeText(
                          pName.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: mainColorPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          minFontSize: 11,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if ((_flagDiscount))
                              Text(
                                minPrize.toStringAsFixed(3) + " " + currencUnit,
                                style: GoogleFonts.poppins(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w300),
                              ),
                            Text(
                              minPrizeDiscounted.toStringAsFixed(3) +
                                  " " +
                                  currencUnit,
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: mainColorPrimary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 6,
          child: InkWell(
            onTap: () {
              // Scaffold.of(context).showSnackBar(SnackBar(
              //     backgroundColor: themeColor.getColor(),
              //     content: Text('Product added to wishList')));
              // Nav.route(context, ShoppingCartPage());
            },
            child: InkWell(
              onTap: () {
                // if (globalLoginId == "") {
                //   globaldisplayDialogAskForLogin(context, themeColor, InitPage(),
                //       'Dear customer, you must login before adding products to wishlist.\n\nWould you like to login?');
                // } else {
                //   addtoWishlistById(context, pId);
                // }
              },
              child: Container(
                padding: EdgeInsets.only(top: 8, left: 8, bottom: 8, right: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        topLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: Colors.white.withOpacity(0.45),
                    boxShadow: [
                      BoxShadow(
                          color: mainColorPrimary.withOpacity(0.25),
                          blurRadius: 1.0,
                          spreadRadius: 1,
                          offset: Offset(0.0, 1)),
                    ]),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    child: SvgPicture.asset(
                      "assets/icons/ic_hearth.svg",
                      height: 12,
                      color: mainColorPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 7,
          child: ((_flagDiscount))
              ? Container(
                  padding:
                      EdgeInsets.only(top: 5, left: 8, bottom: 5, right: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      color: mainColorPrimary.withOpacity(0.7),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 5.0,
                            spreadRadius: 1,
                            offset: Offset(0.0, 1)),
                      ]),
                  child: Container(
                      child: Text(
                    "- " + discount.toStringAsFixed(1) + "%",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 8),
                  )),
                )
              : Text(""),
        ),
        // Positioned(
        //   bottom: 22,
        //   right: 22,
        //   child: Row(
        //     children: [
        //       IconButton(
        //         onPressed: () {
        //           if (globalLoginId == "") {
        //             globaldisplayDialogAskForLogin(
        //                 context,
        //                 themeColor,
        //                 InitPage(),
        //                 'Dear customer, you must login before adding products to wishlist.\n\nWould you like to login?');
        //           } else {
        //             addtoWishlistById(context, pId);
        //           }

        //           // List<String> wishList = [];
        //           // SharedPreferences.getInstance().then((prefs) {
        //           //   if (prefs.getStringList('wishList') != null) {
        //           //     List temp = prefs.getStringList('wishList');
        //           //     bool flagexit = false;
        //           //     for (int i = 0; i < temp.length; i++) {
        //           //       dynamic item = jsonDecode(temp[i]);
        //           //       if (item['product_id'].toString() ==
        //           //           pProduct['product_id'].toString()) {
        //           //         flagexit = true;
        //           //         break;
        //           //       }
        //           //     }

        //           //     if (flagexit) {
        //           //       Fluttertoast.showToast(
        //           //           msg: "Product already exist in wishlist",
        //           //           toastLength: Toast.LENGTH_SHORT,
        //           //           gravity: ToastGravity.BOTTOM,
        //           //           timeInSecForIosWeb: 1,
        //           //           fontSize: 16.0);
        //           //     } else {
        //           //       wishList = prefs.getStringList('wishList');
        //           //       wishList.add(jsonEncode(pProduct));
        //           //       prefs.setStringList('wishList', wishList);
        //           //       Fluttertoast.showToast(
        //           //           msg: "Product Added to the wishlist",
        //           //           toastLength: Toast.LENGTH_SHORT,
        //           //           gravity: ToastGravity.BOTTOM,
        //           //           timeInSecForIosWeb: 1,
        //           //           fontSize: 16.0);
        //           //     }
        //           //     //  dynamic asd = jsonDecode(abc);

        //           //   } else {
        //           //     wishList.add(jsonEncode(pProduct));
        //           //     prefs.setStringList('wishList', wishList);
        //           //     Fluttertoast.showToast(
        //           //         msg: "Product Added to the wishlist",
        //           //         toastLength: Toast.LENGTH_SHORT,
        //           //         gravity: ToastGravity.BOTTOM,
        //           //         timeInSecForIosWeb: 1,
        //           //         fontSize: 16.0);
        //           //   }
        //           // });
        //         },
        //         icon: Icon(
        //           Icons.favorite_border,
        //           color: Colors.red,
        //           size: 18,
        //         ),
        //       ),
        //       SizedBox(
        //         width: 10,
        //       ),
        //       InkWell(
        //         onTap: () {
        //           // Scaffold.of(context).showSnackBar(SnackBar(
        //           //     backgroundColor: mainColor,
        //           //     content: Text('Product added to cart')));
        //           // Nav.route(context, ShoppingCartPage());

        //           Nav.route(
        //               context,
        //               ProductDetailPage(
        //                 productId: pProduct['product_id'].toString(),
        //                 productData: pProduct,
        //               ));
        //         },
        //         child: Container(
        //           padding:
        //               EdgeInsets.only(top: 8, left: 8, bottom: 8, right: 8),
        //           decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(8),
        //               color: Colors.white,
        //               boxShadow: [
        //                 BoxShadow(
        //                     color: Colors.grey.shade200,
        //                     blurRadius: 5.0,
        //                     spreadRadius: 1,
        //                     offset: Offset(0.0, 1)),
        //               ]),
        //           child: Row(
        //             children: <Widget>[
        //               SvgPicture.asset(
        //                 "assets/icons/ic_product_shopping_cart.svg",
        //                 height: 10,
        //               ),
        //               SizedBox(
        //                 width: 8,
        //               ),
        //               Text(
        //                 "Add to Cart",
        //                 style: GoogleFonts.poppins(
        //                     color: Color(0xFF5D6A78),
        //                     fontSize: 7,
        //                     fontWeight: FontWeight.w400),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // Positioned(
        //   top: 8,
        //   right: 12,
        //   child: ((_flagDiscount))
        //       ? Container(
        //           padding:
        //               EdgeInsets.only(top: 5, left: 8, bottom: 5, right: 8),
        //           decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(8),
        //               color: themeColor.getColor(),
        //               boxShadow: [
        //                 BoxShadow(
        //                     color: Colors.grey.shade200,
        //                     blurRadius: 5.0,
        //                     spreadRadius: 1,
        //                     offset: Offset(0.0, 1)),
        //               ]),
        //           child: Container(
        //               child: Text(
        //             "- " + discount.toStringAsFixed(1) + "%",
        //             style: TextStyle(
        //                 color: Colors.white,
        //                 fontWeight: FontWeight.bold,
        //                 fontSize: 12),
        //           )),
        //         )
        //       : Text(""),
        // )
      ],
    );
  }
}
