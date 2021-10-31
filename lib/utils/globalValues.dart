import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shoppingapp/pages/login.dart';
import 'package:shoppingapp/utils/colors.dart';
import 'package:mongo_dart/mongo_dart.dart' as dbLib;
import 'package:shared_preferences/shared_preferences.dart';



Db? globaldb;
String globalAPILink = "http://devapi-v2.esindbaad.com/";
String globalImagesLink = "http://devapi-v2.esindbaad.com";
String currencUnit = "PKR";
List listcatagories = [];
List bannerImageList = [];
List<String> imageList = [];
var cartItems;
var wishList;
String userId = "";
String userName = "";
String userEmail = "";
String userPhoneNo = "";
int cartcount = 0;
var spinkitglobal = SpinKitDoubleBounce(
  color: mainColorPrimary,
  size: 50.0,
);
Widget? globalWidgetCatagory;
globaldisplayDialogAskForLogin(BuildContext context, String message) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sindbaad'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(
                'No',
                style: GoogleFonts.poppins(color: mainColorPrimary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: GoogleFonts.poppins(color: mainColorPrimary),
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            )
          ],
        );
      });
}

addToWishList(String id) async {
  var dataAllProducts = await globaldb!
      .collection("productList")
      .findOne(dbLib.where.eq("product_id", int.parse(id)));
  SharedPreferences.getInstance().then((prefs) {
    List wishListTemp = jsonDecode(prefs.getString("wishList") ?? "[]");
    bool alreadyExist = false;
    for (int i = 0; i < wishListTemp.length; i++) {
      if (wishListTemp[i]["product_id"].toString() == id) {
        alreadyExist = true;
      }
    }
    if (!alreadyExist) {
      wishListTemp.add(dataAllProducts);

      prefs.setString("wishList", jsonEncode(wishListTemp));
// print()
      Fluttertoast.showToast(msg: "Product added to WishList");
    } else {
      Fluttertoast.showToast(msg: "Already Exist");
    }
  });
}

addToCart(String id) async {}
