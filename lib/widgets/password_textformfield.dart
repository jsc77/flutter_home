import 'package:flutter/material.dart';

class PasswordTextFormField extends StatelessWidget {
  final bool obserText;
  final Function validator;
  final String name;
  final Function onTap;
  final Function onChanged;
  TextEditingController controller;
  PasswordTextFormField(
      {this.obserText,
      this.validator,
      this.name,
      this.onTap,
      this.onChanged,
      this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 55,
        child: TextFormField(
          controller: controller,
          obscureText: obserText,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: "パスワード...",
            labelStyle: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1.5,
                color: Colors.amber,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey,
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: onTap,
              child: Icon(
                obserText == true ? Icons.visibility : Icons.visibility_off,
                color: Colors.black54,
              ),
            ),
            hintStyle: TextStyle(color: Colors.indigo),
          ),
        ));
  }
}
