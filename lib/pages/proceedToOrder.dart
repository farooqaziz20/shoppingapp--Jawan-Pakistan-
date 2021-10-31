import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppingapp/pages/myOrders.dart';
import 'package:shoppingapp/utils/colors.dart';
import 'package:shoppingapp/utils/globalValues.dart';
import 'package:shoppingapp/widgets/cartWishListItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen(this.listItem, this.total, {Key? key})
      : super(key: key);
  final List listItem;
  final String total;
  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Confirm Order"),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        await SharedPreferences.getInstance().then((prefs) {
                          prefs.setString("cartItems", jsonEncode([]));
                          setState(() {
                            cartcount = 0;
                          });

                          Fluttertoast.showToast(msg: "Order Placed");
                        });
                        dynamic orderDetails = {
                          "userId": userId,
                          "products": widget.listItem,
                          "totalAmount": widget.total
                        };
                        await globaldb!
                            .collection("userOrders")
                            .insert(orderDetails);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyOrders()));
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
        body: SingleChildScrollView(
          child: Expanded(
            child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: mainColorPrimaryLight,
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.listItem.length,
                      itemBuilder: (context, index) {
                        dynamic e = widget.listItem[index];
                        return cartproduct(
                            context, e['product_name'].toString(), e);
                      }),
                  Divider(
                    height: 5,
                    color: mainColorPrimary,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Qty: ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: mainColorPrimary),
                                  ),
                                  Text(widget.listItem.length.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: mainColorPrimary))
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Total: ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: mainColorPrimary),
                                  ),
                                  Text(widget.total.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: mainColorPrimary))
                                ],
                              ),
                            ],
                          )
                        ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
