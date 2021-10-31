import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shoppingapp/utils/globalValues.dart';
import 'package:shoppingapp/widgets/productItem.dart';
import 'package:mongo_dart/mongo_dart.dart' as dbLib;

class CatagoryProduct extends StatefulWidget {
  const CatagoryProduct(this.catagoryId, this.catagoryName, {Key? key})
      : super(key: key);
  final String catagoryId;
  final String catagoryName;

  @override
  _CatagoryProductState createState() => _CatagoryProductState();
}

class _CatagoryProductState extends State<CatagoryProduct> {
  @override
  void initState() {
    super.initState();
    fetchProducts(0);
  }

  List productList = [];
  bool isLoading = false;
  fetchProducts(int index) async {
    var dataAllProducts = await globaldb!.collection("productList1").find(dbLib
        .where
        .eq("catagoryId", int.parse(widget.catagoryId))
        .skip(index * 18)
        .limit(18));
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.catagoryName),
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!isLoading &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              if (productList.length < 1000) {
                fetchProducts(
                    int.parse((productList.length / 18).toStringAsFixed(0)));

                // start loading data
                setState(() {
                  isLoading = true;
                });
              }
            }
            ;
            return false;
          },
          child: SingleChildScrollView(
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
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  ),
                if (!(productList.length > 0))
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("No Product Found")),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
