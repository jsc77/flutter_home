import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final Function validator;
  final Function onChanged;
  final String name;
  TextEditingController controller;
  MyTextFormField({this.validator, this.name, this.onChanged, this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 55,
        child: TextFormField(
          validator: validator,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            labelText: name,
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
          ),
        ));
  }
}
