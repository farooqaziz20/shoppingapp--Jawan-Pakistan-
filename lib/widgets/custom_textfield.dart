import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? intialValue;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final IconButton? suffixIcon;
  final bool isPassword;
  final bool isEmail;
  final bool isEnabled;
  final TextEditingController? controller;

  MyTextFormField(
      {this.hintText,
      this.validator,
      this.onSaved,
      this.isPassword = false,
      this.isEmail = false,
      this.isEnabled = true,
      this.labelText,
      this.suffixIcon,
      this.intialValue,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: controller,
        enabled: isEnabled,
        decoration: InputDecoration(
        
          hintText: hintText,
          contentPadding: EdgeInsets.all(15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:const BorderSide(
              width: 1,
              style: BorderStyle.none,
            ),
          ),
          labelText: labelText,
          filled: true,
          suffixIcon: this.suffixIcon,
          fillColor: Color(0xFFEEEEF3),
        ),
        obscureText: isPassword ? true : false,
        validator: validator,
        onSaved: onSaved,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      ),
    );
  }
}
