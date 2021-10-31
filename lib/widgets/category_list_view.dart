import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppingapp/pages/catagoryProducts.dart';
import 'package:shoppingapp/utils/colors.dart';
import 'package:shoppingapp/utils/globalValues.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({
    required this.categories,
    Key? key,
  }) : super(key: key);
  final List categories;
  @override
  Widget build(BuildContext context) {
    return CategoriesListView(
      title: "YOUR TITLES",
      categories: categories,
    );
  }
}

class CategoriesListView extends StatelessWidget {
  final String title;
  final List categories;
  const CategoriesListView(
      {Key? key, required this.title, required this.categories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 4),
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CatagoryProduct(
                        categories[index]["p_cat1_id"].toString(),
                        categories[index]["p_cat1_name"].toString())),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 55,
                  height: 56,
                  margin:
                      EdgeInsets.only(top: 4, bottom: 4, left: 12, right: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 5.0,
                          spreadRadius: 1,
                          offset: Offset(0.0, 1)),
                    ],
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Container(
                      width: 50,
                      height: 50,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child:

                          // FadeInImage(
                          //   image: NetworkImage(
                          //       "http://esindbaad-api.genial365.com/UploadedFiles/Asset 17.svg"),
                          //   placeholder:
                          //       AssetImage("assets/images/sindbaadPlaceHolder.png"),
                          //   fit: BoxFit.fitHeight,
                          // ),

                          SvgPicture.network(
                              globalImagesLink +
                                  categories[index]["icon_class"].toString(),
                              color: mainColorPrimary)
                      // .network("http://esindbaad-api.genial365.com/UploadedFiles/Asset 17.svg")
                      // .asset(
                      //   "http://esindbaad-api.genial365.com/UploadedFiles/Asset 17.svg",
                      //   color: categoryIconColor,
                      // ),
                      ),
                ),
                // SizedBox(
                //   height: 4,
                // ),
                SizedBox(
                  width: 55,
                  child: AutoSizeText(
                    categories[index]["p_cat1_name"].toString(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 7,
                      color: mainColorPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    minFontSize: 6,
                    maxLines: 2,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
