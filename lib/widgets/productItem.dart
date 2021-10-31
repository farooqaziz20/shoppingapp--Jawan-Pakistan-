import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppingapp/pages/productDetails.dart';
import 'package:shoppingapp/utils/colors.dart';
import 'package:shoppingapp/utils/globalValues.dart';

Stack productSearchItem(BuildContext context, String name, dynamic item) {
  bool isLiked = false;
  String imageLink = item['product_banner_image'];
  String productId = item['product_id'].toString();
  double minPrize = 0.0;
  double maxPrize = 0.0;
  double minPrizeDiscounted = 0.0;
  double maxPrizeDiscounted = 0.0;
  double discount = 0.0;
  bool _flag = false;
  bool _flagDiscount = false;

  if (item['min']['price'].toString() == "null") {
    minPrize = 0;
  } else {
    minPrize = double.parse(item['min']['price'].toString());
  }
  if (item['min']['discounted_price'].toString() == "null") {
    minPrizeDiscounted = 0;
  } else {
    minPrizeDiscounted =
        double.parse(item['min']['discounted_price'].toString());
  }
  if (item['max']['price'].toString() == "null") {
    maxPrize = 0;
  } else {
    maxPrize = double.parse(item['max']['price'].toString());
  }
  if (item['max']['discounted_price'].toString() == "null") {
    maxPrizeDiscounted = 0;
  } else {
    maxPrizeDiscounted =
        double.parse(item['max']['discounted_price'].toString());
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
                        productId: productId,
                        productData: item,
                      )));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 3,
          height: 185,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            child: FadeInImage(
                              image: NetworkImage(globalImagesLink + imageLink),
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
                  padding: EdgeInsets.only(left: 4, top: 4, right: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AutoSizeText(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: mainColorPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        minFontSize: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // SizedBox(
                                //   height: 6,
                                // ),
                                if ((_flagDiscount))
                                  Text(
                                    minPrize.toStringAsFixed(3) +
                                        " " +
                                        currencUnit,
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
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: mainColorPrimaryLight),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 5,
        left: 6,
        child: InkWell(
          onTap: () {},
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
              onTap: () {
                if (userId == "") {
                  globaldisplayDialogAskForLogin(context,
                      'Dear customer, you must login before adding products to wishlist.\n\nWould you like to login?');
                } else {
                  addToWishList(productId);
                }
              },
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
      Positioned(
        top: 5,
        right: 7,
        child: ((_flagDiscount))
            ? Container(
                padding: EdgeInsets.only(top: 5, left: 8, bottom: 5, right: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: mainColorPrimaryLight.withOpacity(0.7),
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
      )
    ],
  );
}
