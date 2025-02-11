// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  final String? hinttext;
  final bool isPassword;
  final String? lableText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const MyTextfield({
    super.key,
    this.hinttext,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.lableText,
  });

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  bool isPassVisible = false;
  var height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Container(
        height: height * 0.07,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? !isPassVisible : false,
          style: const TextStyle(fontSize: 14),
          validator: widget.validator,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            fillColor: Colors.grey.shade200,
            filled: true,
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            hintText: widget.hinttext ?? "",
            labelText: widget.lableText ?? "",
            labelStyle: const TextStyle(color: Colors.black),
            hintStyle: const TextStyle(fontSize: 13),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isPassVisible = !isPassVisible;
                      });
                    },
                    icon: Icon(isPassVisible
                        ? Icons.visibility
                        : Icons.visibility_off))
                : null,
          ),
        ),
      ),
    );
  }
}
