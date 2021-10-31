import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/globalValues.dart';

List<Widget> imageSliders(BuildContext context) {
  return bannerImageList
      .map((item) => GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 5.0,
                      spreadRadius: 1,
                      offset: Offset(0.0, 1)),
                ],
              ),
              margin:
                  EdgeInsets.only(left: 12.0, right: 16, top: 16, bottom: 16),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                            color: Colors.white,
                            height: 155,
                            child: FadeInImage(
                              image: NetworkImage(
                                  item['banner_mobile_url'].toString()),
                              placeholder:
                                  AssetImage("assets/images/sIcon.png"),
                              fit: BoxFit.cover,
                              // height: 115,
                            ),
                          )),
//                   Align(
//                     alignment: Alignment.centerLeft,
// //                    child:Point(
// //                      triangleHeight: 70.0,
// //                      edge: Edge.RIGHT,
// //                      child: Container(
// //                        color: Colors.white,
// //                        width: 225.0,
// //                        height: 175.0,
// //                        padding: EdgeInsets.only(left: 16, top: 54, right: 72),
// //                        child: Text(
// //                          "Kadın kıyafetlerinde bu aya degil bu yıla özel fırsatlar",
// //                          overflow: TextOverflow.ellipsis,
// //                          maxLines: 5,
// //                          style: GoogleFonts.poppins(
// //                            fontSize: 13,
// //                            color: Color(0xFF5D6A78),
// //                            fontWeight: FontWeight.w300,
// //                          ),
// //                        ),
// //                      ),
// //                    ),
//                     child: Diagonal(
//                       clipHeight: 70.0,
//                       axis: Axis.vertical,
//                       position: DiagonalPosition.BOTTOM_RIGHT,
//                       child: Container(
//                         color: Colors.white,
//                         width: 200.0,
//                         height: 175.0,
//                         child: Align(
//                           alignment: Alignment.center,
//                           child: Container(
//                             width: 150,
//                             margin: EdgeInsets.only(right: 54, left: 12),
//                             child: Text(
//                               "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed",
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 5,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 13,
//                                 color: Color(0xFF5D6A78),
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
                    ],
                  )),
            ),
          ))
      .toList();
}
