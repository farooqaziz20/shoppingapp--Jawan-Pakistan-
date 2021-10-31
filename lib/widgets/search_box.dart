import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppingapp/pages/search.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Search()));
      },
      child: Container(
        margin: EdgeInsets.only(left: 18, right: 18, top: 14),
        padding: EdgeInsets.only(left: 18, right: 18),
        height: 44,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color(0xFFA1B1C2).withOpacity(0.2),
                blurRadius: 9.0,
                offset: Offset(0.0, 6))
          ],
          color: Theme.of(context).bottomAppBarColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              "assets/icons/ic_search.svg",
              color: Color(0xFFA1B1C2),
              height: 12,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "Product, category search..",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Color(0xFFA1B1C2),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
