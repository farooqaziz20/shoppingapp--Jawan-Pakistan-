import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppingapp/utils/colors.dart';
import 'package:shoppingapp/utils/globalValues.dart';

import 'package:mongo_dart/mongo_dart.dart' as dbLib;
import 'package:http/http.dart' as http;
import 'package:shoppingapp/widgets/productItem.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController textEditingControllerSearch = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // loadProducts();
    super.initState();
  }

  List productList = [];
  bool isLoading = false;
  fetchProducts(int index) async {
    var dataAllProducts = await globaldb!.collection("productList1").find(dbLib
        .where
        .match("product_name", textEditingControllerSearch.text)
        .limit(100));
    List templistproductList = await dataAllProducts.toList();
    print(templistproductList);
    if (index == 0) {
      setState(() {
        productList = templistproductList;
        isLoading = false;
      });
    } else {
      setState(() {
        productList.addAll(templistproductList);
        isLoading = false;
      });
    }
  }

  // // List listNewarrivalsA = [];

  // loadProducts() async {
  //   var data = await globaldb!.collection("productDetails1").find();
  //   List templistnewArrivals = await data.toList();
  //   // print(templistnewArrivals);
  //   for (int i = 0; i < templistnewArrivals.length; i++) {
  //     dynamic product = templistnewArrivals[i];
  //     product["productId"] = product["productDetail"]["product_id"];
  //     await globaldb!.collection("productDetails").insert(product);
  //     print(product["_id"].toString() + "updated");
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: mainColorPrimary,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: mainColorSecondry)),
                  Expanded(
                    child: Container(
                      height: 35,
                      child: TextField(
                        controller: textEditingControllerSearch,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {},
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          if (textEditingControllerSearch.text.trim().isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please enter some keyword to search");
                          } else {
                            fetchProducts(0);
                          }
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          hintText: "Search",
                          fillColor: Color(0xfff3f3f4),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (textEditingControllerSearch.text.trim().isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please enter some keyword to search");
                        } else {
                          fetchProducts(0);
                        }
                      },
                      icon: Icon(Icons.search, color: mainColorSecondry)),
                ],
              ),
            ),
            Expanded(
              child: (!isLoading)
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          if (productList.length > 0)
                            StaggeredGridView.countBuilder(
                              crossAxisCount: 3,
                              itemCount: productList.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                dynamic e = productList[index];
                                return productSearchItem(
                                    context, e['product_name'].toString(), e);
                              },
                              staggeredTileBuilder: (int index) =>
                                  StaggeredTile.fit(1),
                            ),
                          if (!(productList.length > 0))
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text("No Product Found")),
                            )
                        ],
                      ),
                    )
                  : spinkitglobal,
            )
          ],
        ),
      ),
    );
  }
}
