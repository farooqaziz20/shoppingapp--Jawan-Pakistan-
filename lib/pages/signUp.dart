import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppingapp/utils/colors.dart';
import 'package:shoppingapp/utils/globalValues.dart';
import 'package:shoppingapp/widgets/auth_header.dart';
import 'package:shoppingapp/widgets/custom_textfield.dart';
import 'package:validators/validators.dart' as validator;
import 'package:mongo_dart/mongo_dart.dart' as dbLib;

import 'dashboard.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = true;

  TextEditingController textEditingControllerFirstName =
      TextEditingController();
  TextEditingController textEditingControllerLastName = TextEditingController();
  TextEditingController textEditingControllerUserName = TextEditingController();
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();
  TextEditingController textEditingControllerMobileNo = TextEditingController();
  Future signUp(String email, String password) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await globaldb!.collection("users").insert({
        "userId": user.user!.uid,
        "firstName": textEditingControllerFirstName.text,
        "LastName": textEditingControllerLastName.text,
        "email": textEditingControllerEmail.text,
        "username": textEditingControllerUserName.text,
        "phoneno": textEditingControllerPassword.text,
        "password": textEditingControllerPassword.text,
      });
      userId = user.user!.uid;
      userName = textEditingControllerFirstName.text +
          " " +
          textEditingControllerLastName.text;
      userEmail = textEditingControllerEmail.text;
      userPhoneNo = textEditingControllerMobileNo.text;
      Fluttertoast.showToast(msg: "User Successfully registered");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashBoard()));

      return null;
    } on FirebaseAuthException catch (e) {
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
          Column(
            children: [
              AuthHeader(
                  headerTitle: "",
                  headerBigTitle: "Sign Up",
                  isLoginHeader: true),
              // const SizedBox(
              //   height: 36,
              // ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:
                            const EdgeInsets.only(top: 14, right: 42, left: 42),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: MyTextFormField(
                                    controller: textEditingControllerFirstName,
                                    labelText: "First Name*",
                                    hintText: 'First Name',
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter your first name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: MyTextFormField(
                                    controller: textEditingControllerLastName,
                                    labelText: "Last Name*",
                                    hintText: 'Last Name',
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter your last name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: MyTextFormField(
                                    controller: textEditingControllerUserName,
                                    labelText: "User Name*",
                                    hintText: 'User Name',
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter a valid username';
                                      }

                                      return null;
                                    },
                                    // onSaved: (String value) {
                                    //   model.lastName = value;
                                    // },
                                  ),
                                ),
                                MyTextFormField(
                                  controller: textEditingControllerEmail,
                                  labelText: "Email*",
                                  hintText: 'Enter Your Email',
                                  isEmail: true,
                                  validator: (value) {
                                    if (!validator.isEmail(value!)) {
                                      return 'Please enter a valid email';
                                    }

                                    return null;
                                  },
                                ),
                                MyTextFormField(
                                  controller: textEditingControllerMobileNo,
                                  labelText: "Phone No*",
                                  hintText: '03311234567',
                                  validator: (value) {
                                    if (value!.length != 11) {
                                      return 'Please enter 11 digit phone no';
                                    }

                                    return null;
                                  },
                                  onSaved: (value) {},
                                ),
                                MyTextFormField(
                                  controller: textEditingControllerPassword,
                                  labelText: "Password*",
                                  hintText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: mainColorPrimary,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
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
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 48,
                                  width: MediaQuery.of(context).size.width,
                                  margin:
                                      const EdgeInsets.only(top: 12, bottom: 0),
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    color: mainColorPrimary,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        signUp(textEditingControllerEmail.text,
                                            textEditingControllerPassword.text);
                                      }
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                              ],
                            )),
                      ),

                      SizedBox(
                        height: 8,
                      ),
                      routeRegisterWidget(context),
                      const SizedBox(
                        height: 150,
                      ),
                      // SocialLoginButtons(themeColor: themeColor)
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              top: 15,
              left: 15,
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: mainColorPrimaryLight,
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
            "Already Have an Account?",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w200,
            ),
          ),
          TextButton(
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: 12,
                color: mainColorPrimaryLight,
                fontWeight: FontWeight.w300,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
