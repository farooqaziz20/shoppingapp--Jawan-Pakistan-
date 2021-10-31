import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/colors.dart';
import 'package:shoppingapp/utils/globalValues.dart';
import 'package:shoppingapp/widgets/cartWishListItem.dart';
import 'package:mongo_dart/mongo_dart.dart' as dbLib;

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List allOrders = [];
  Future<void> fetchData() async {
    var dataAllOrders = await globaldb!
        .collection("userOrders")
        .find(dbLib.where.eq("userId", userId));

    if (dataAllOrders != null) {
      List templistproductList = await dataAllOrders.toList();
      setState(() {
        allOrders = templistproductList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Orders"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: allOrders.length,
                  itemBuilder: (context, index) {
                    return orderDetails(
                        allOrders[index]["products"],
                        allOrders[index]["totalAmount"],
                        allOrders[index]["_id"].toString());
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget orderDetails(List listItem, String total, String orderId) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: mainColorPrimaryLight,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "Order Id: ",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainColorPrimary),
                ),
                Text(listItem.length.toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: mainColorPrimary))
              ],
            ),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listItem.length,
              itemBuilder: (context, index) {
                dynamic e = listItem[index];
                return cartproduct(context, e['product_name'].toString(), e);
              }),
          Divider(
            height: 5,
            color: mainColorPrimary,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                      Text(listItem.length.toString(),
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
                      Text(total.toString(),
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
    );
  }
}
