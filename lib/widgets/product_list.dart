import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppingapp/utils/colors.dart';
import 'package:shoppingapp/widgets/product_card.dart';
import 'package:shoppingapp/widgets/product_list_titlebar.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    Key? key,
    required this.productListTitleBar,
    required this.productListA,
  }) : super(key: key);

  final ProductListTitleBar productListTitleBar;
  final List productListA;

  @override
  Widget build(BuildContext context) {
    // int length = int.parse(productListGlobal.length);
    // List productList2 = productListGlobal.getRange(11, 20);
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          productListTitleBar,
          Container(
              height: 185.0,
              child: (productListA.length > 0)
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productListA.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return ProductCard(
                          pId: productListA[index]['product_id'].toString(),
                          imageUrl: "prodcut7.png",
                          pName: productListA[index]['product_name'].toString(),
                          pImageNetworkUrl: productListA[index]
                              ['product_banner_image'],
                          pProduct: productListA[index],
                        );
                      })
                  : Padding(
                      padding: const EdgeInsets.only(left: 28.0, top: 10),
                      child: Text(
                        "No Product Available",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: mainColorPrimary.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
          // Container(
          //     height: 285.0,
          //     child: ListView.builder(
          //         scrollDirection: Axis.horizontal,
          //         itemCount: productListB.length,
          //         itemBuilder: (BuildContext ctxt, int index) {
          //           return ProductCard(
          //             themeColor: themeColor,
          //             pId: productListB[index]['product_id'].toString(),
          //             imageUrl: "prodcut7.png",
          //             pName: productListB[index]['product_name'],
          //             pImageNetworkUrl: productListB[index]
          //                 ['product_banner_image'],
          //             pProduct: productListB[index],
          //           );
          //         })),
        ],
      ),
    );
  }
}
