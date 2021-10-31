import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/pages/proceedToOrder.dart';
import 'package:shoppingapp/utils/colors.dart';
import 'package:shoppingapp/widgets/cartWishListItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List products = [];
  @override
  void initState() {
    loadProducts();
    super.initState();
  }

  double totalAmount = 0.0;
  loadProducts() {
    SharedPreferences.getInstance().then((prefs) {
      List cartListTemp = jsonDecode(prefs.getString("cartItems") ?? "[]");
      print(cartListTemp);
      double total = 0.0;
      for (int i = 0; i < cartListTemp.length; i++) {
        total += double.parse(
            (cartListTemp[i]["min"]["discounted_price"] ?? "0").toString());
      }
      setState(() {
        totalAmount = total;
        products = cartListTemp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Cart"),
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: mainColorPrimaryLight,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Text(
                      "Total: ",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainColorSecondry),
                    ),
                    Text(totalAmount.toString(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: mainColorSecondry))
                  ],
                )),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlaceOrderScreen(
                                    products, totalAmount.toString())));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                            color: mainColorPrimary,
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "Place Order",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: mainColorSecondry),
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
     
      ),
    );
  }
}
