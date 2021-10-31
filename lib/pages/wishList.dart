import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoppingapp/widgets/cartWishListItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  List products = [];
  @override
  void initState() {
    loadProducts();
    super.initState();
  }

  loadProducts() {
    SharedPreferences.getInstance().then((prefs) {
      List wishListTemp = jsonDecode(prefs.getString("wishList") ?? "[]");
      print(wishListTemp);
      setState(() {
        products = wishListTemp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Wish List"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    dynamic e = products[index];
                    return cartproduct(
                        context, e['product_name'].toString(), e);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
