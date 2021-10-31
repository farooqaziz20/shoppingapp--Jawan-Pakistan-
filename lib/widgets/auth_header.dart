import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/colors.dart';

class AuthHeader extends StatelessWidget {
  final String? headerTitle;
  final String? headerBigTitle;
  final bool? isLoginHeader;

  AuthHeader({this.headerTitle, this.headerBigTitle, this.isLoginHeader});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: mainColorPrimary.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 0),
            ),
          ],
          color: mainColorPrimary,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24))),
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              headerTitle!,
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          isLoginHeader!
              ? Container()
              : Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      // Nav.routeReplacement(context, LoginPage());
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    headerBigTitle!,
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
