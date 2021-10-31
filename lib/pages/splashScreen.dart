import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as dbLib;
import 'package:shoppingapp/pages/dashboard.dart';
import 'package:shoppingapp/utils/colors.dart';
import 'package:shoppingapp/utils/globalValues.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    coneectDb();
    super.initState();
  }

  coneectDb() async {
    var db = await dbLib.Db.create(
        "mongodb+srv://farooqaziz20:Aspire20@cluster0.xbz1t.mongodb.net/shoppingApp?retryWrites=true&w=majority");
    await db.open();
    globaldb = db;
    print(globaldb!.isConnected);
    loadCatagories();
  }

  loadCatagories() async {
    var data = await globaldb!.collection("catagories").find();
    List templistcatagories = await data.toList();

    var databanner = await globaldb!.collection("banners").find();
    List templistbanners = await databanner.toList();
    List<String> tempList = [];
    for (int i = 0; i < templistbanners.length; i++) {
      tempList.add(templistbanners[i]["banner_mobile_url"]);
    }

    setState(() {
      listcatagories = templistcatagories;
      imageList = tempList;

      bannerImageList = templistbanners;
    });

    // print(listcatagories);
    // print(listcatagories.first);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => DashBoard()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mainColorPrimary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/sIcon.png',
                height: 100,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Shopping App",
                style: TextStyle(
                    color: mainColorPrimaryLight,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
