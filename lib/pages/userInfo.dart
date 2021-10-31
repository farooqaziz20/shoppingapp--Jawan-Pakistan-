import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/colors.dart';
import 'package:shoppingapp/utils/globalValues.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  Widget _infoWidget(String heading, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: mainColorPrimary),
        ),
        Text(
          // listDetails[0]["account_name"] ??
          info,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: mainColorPrimary),
        ),
        Container(
            width: 88,
            child: Divider(
              // color: themeColor.getColor(),
              height: 18,
              thickness: 1,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "User Info",
            style: TextStyle(color: mainColorSecondry),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoWidget("Name", userName),
              _infoWidget("Email", userEmail),
              _infoWidget("Phone No", userPhoneNo),
            ],
          ),
        ));
  }
}
