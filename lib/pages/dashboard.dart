import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppingapp/pages/cart.dart';
import 'package:shoppingapp/pages/search.dart';

import 'package:shoppingapp/utils/colors.dart';
import 'package:shoppingapp/utils/globalValues.dart';

import 'package:shoppingapp/widgets/category_list_view.dart';
import 'package:shoppingapp/widgets/drawer.dart';
import 'package:shoppingapp/widgets/imageSlider.dart';

import 'package:shoppingapp/widgets/productItem.dart';
import 'package:shoppingapp/widgets/product_list.dart';
import 'package:shoppingapp/widgets/product_list_titlebar.dart';
import 'package:shoppingapp/widgets/search_box.dart';
import 'package:shoppingapp/widgets/slider_dot.dart';
import 'package:mongo_dart/mongo_dart.dart' as dbLib;
import 'package:http/http.dart' as http;

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    // loadHeadLines();
    loadProducts();
    fetchProducts(0);
    super.initState();
  }

  List listNewarrivalsA = [];
  List productList = [];

  bool isLoading = false;
  loadProducts() async {
    var data =
        await globaldb!.collection("productList1").find(dbLib.where.limit(10));
    List templistnewArrivals = await data.toList();

    setState(() {
      listNewarrivalsA = templistnewArrivals;
    });
  }

  fetchProducts(int index) async {
    var dataAllProducts = await globaldb!
        .collection("productList1")
        .find(dbLib.where.sortBy("product_id").skip(index * 18).limit(18));
    List templistproductList = await dataAllProducts.toList();

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

  // loadDetails(String id) async {
  //   final response = await http.get(Uri.parse(
  //       globalAPILink + 'api/products/get-product-detail-customer?id=' + id));
  // }

  int _carouselCurrentPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          drawer: CustomDrawer(),
          appBar: AppBar(
            title: const Text(
              'Shopping App',
              style: TextStyle(color: Color(0xFFCEB214)),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    if (userId == "") {
                      globaldisplayDialogAskForLogin(context,
                          "Please Login before going to the cart.\n\nWould you like to login?");
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Cart()));
                    }
                  },
                  icon: Icon(Icons.shopping_cart, color: mainColorSecondry))
            ],
            leading: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: Icon(Icons.menu_sharp, color: mainColorSecondry)),
            backgroundColor: mainColorPrimary,
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
                SearchBox(),
                CategoryListView(
                  categories: listcatagories,
                ),
                InkWell(
                  onTap: () {
                    //  Nav.route(context, ProductDetailPage());
                  },
                  child: CarouselSlider(
                    items: imageSliders(context),
                    options: CarouselOptions(
                        autoPlay: true,
                        height: 175,
                        autoPlayInterval: Duration(seconds: 6),
                        viewportFraction: 1.0,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _carouselCurrentPage = index;
                          });
                        }),
                  ),
                ),
                SliderDot(current: _carouselCurrentPage),
                ProductList(
                  productListA: listNewarrivalsA,
                  productListTitleBar: ProductListTitleBar(
                    title: "New Arrivals",
                    isCountShow: false,
                    onTap: () {
                      // globalWidgetCatagory = CatagoryProducts(catName: "New Arrivals", catId: "5", catNo: 1);
                      // catNameGlobal = "New Arrivals";
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => CatagoryProducts(
                      //               catName: "New Arrivals",
                      //               catId: "5",
                      //               catNo: 1,
                      //               subCatagories: sindbaadFoodsSubCatagories,
                      //             )));
                    },
                  ),
                ),
                Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(15),
                          color: mainColorPrimary),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Pick Your Favorite",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    StaggeredGridView.
                        // // count(
                        // //     crossAxisCount: 3,
                        // //     physics: NeverScrollableScrollPhysics(),
                        // //     shrinkWrap: true,
                        // //     children: productList
                        // //         .map((e) => productSearchItem(
                        // //             context,
                        // //             themeColor,
                        // //             e['product_name'].toString(),
                        // //             e,
                        // //             updateCartFunction))
                        // //         .toList())

                        countBuilder(
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
                      // mainAxisSpacing: 4.0,
                      // crossAxisSpacing: 4.0,
                    ),
                  ],
                ),
                Container(
                  height: isLoading ? 50.0 : 0,
                  color: Colors.transparent,
                  child: Center(
                    child: SpinKitWave(
                      color: mainColorPrimary,
                      size: 30.0,
                    ),
                  ),
                )
              ],
            )),
          )),
    );
  }
}
