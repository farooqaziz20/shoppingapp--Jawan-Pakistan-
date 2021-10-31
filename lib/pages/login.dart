import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppingapp/pages/signUp.dart';
import 'package:shoppingapp/utils/colors.dart';
import 'package:shoppingapp/utils/globalValues.dart';
import 'package:shoppingapp/widgets/auth_header.dart';
import 'package:shoppingapp/widgets/custom_textfield.dart';
import 'package:validators/validators.dart' as validator;
import 'package:mongo_dart/mongo_dart.dart' as dbLib;

import 'dashboard.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool passwordVisible = true;
  TextEditingController textEditingControllerEmail =
      TextEditingController(text: "farooqaziz2211@gmail.com");
  TextEditingController textEditingControllerPassword =
      TextEditingController(text: "12345678");

  Future login(String email, String password) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      var data = await globaldb!
          .collection("users")
          .findOne(dbLib.where.eq("userId", user.user!.uid));
      // print(data!["firstName"]);
      if (data != null) {
        userId = user.user!.uid;

        userName = data["firstName"].toString() + " " + data["LastName"];
        userEmail = data["email"];
        userPhoneNo = data["phoneno"];
        Fluttertoast.showToast(msg: "User Successfully registered");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashBoard()));
      } else {
        Fluttertoast.showToast(msg: "Invalid Username or Password");
      }

      return null;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: "Invalid Username or Password");
      return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AuthHeader(
                    headerTitle: "",
                    headerBigTitle: "Login",
                    isLoginHeader: true),
                const SizedBox(
                  height: 36,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 24, right: 42, left: 42),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        MyTextFormField(
                          controller: textEditingControllerEmail,
                          labelText: "Email",
                          hintText: 'Enter Email',
                          isEmail: true,
                          validator: (value) {
                            if (!validator.isEmail(value.toString())) {
                              return 'Please enter a valid email';
                            }

                            return null;
                          },
                        ),
                        MyTextFormField(
                          controller: textEditingControllerPassword,
                          labelText: "Password",
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: mainColorPrimary,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                          isPassword: passwordVisible,
                          validator: (value) {
                            if (value!.length < 7) {
                              return 'Password should be minimum 7 characters';
                            }

                            return null;
                          },
                        ),
                        Container(
                          height: 42,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 32, bottom: 12),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                            color: mainColorPrimaryLight,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                login(textEditingControllerEmail.text,
                                    textEditingControllerPassword.text);
//
                              }
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 8,
                ),
                routeRegisterWidget(context),
                // SocialLoginButtons(themeColor: themeColor)
              ],
            ),
          ),
          Positioned(
              top: 15,
              left: 15,
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )),
        ]),
      ),
    );
  }

  routeRegisterWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 30, left: 30, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don’t have an account?",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w200,
            ),
          ),
          TextButton(
            child: Text(
              "Register",
              style: TextStyle(
                fontSize: 12,
                color: mainColorPrimaryLight,
                fontWeight: FontWeight.w300,
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            },
          )
        ],
      ),
    );
  }
}
