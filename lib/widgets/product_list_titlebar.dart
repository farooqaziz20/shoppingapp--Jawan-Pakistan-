import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shoppingapp/utils/colors.dart';

class ProductListTitleBar extends StatelessWidget {
  const ProductListTitleBar(
      {Key? key, required this.title, required this.isCountShow, this.onTap})
      : super(key: key);

  final String title;
  final bool isCountShow;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: mainColorPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isCountShow)
            Container(
                padding:
                    EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(.2),
                  //     blurRadius: 5.0, // soften the shadow
                  //     spreadRadius: 0.0, //extend the shadow
                  //     offset: Offset(
                  //       0.0, // Move to right 10  horizontally
                  //       3.0, // Move to bottom 10 Vertically
                  //     ),
                  //   )
                  // ]
                ),
                child: GestureDetector(
                  onTap: (onTap != null) ? onTap : null,
                  child: Text(
                    "See More >",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Color(0xFF5D6A78),
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )

                // CountdownTimer(
                //   endTime: 1594829147719,
                //   defaultDays: "==",
                //   defaultHours: "--",
                //   defaultMin: "**",
                //   defaultSec: "++",
                //   daysSymbol: "",
                //   hoursSymbol: ":",
                //   minSymbol: ":",
                //   secSymbol: "",
                //   textStyle: GoogleFonts.poppins(
                //     fontSize: 12,
                //     color: themeColor.getColor(),
                //     fontWeight: FontWeight.w300,
                //   ),
                // )

                )
        ],
      ),
    );
  }
}
