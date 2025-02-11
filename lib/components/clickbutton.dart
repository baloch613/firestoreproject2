// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class CustomdButton extends StatefulWidget {
  final String text;
  final Color bgColor;
  final VoidCallback onPressed;
  const CustomdButton(
      {super.key,
      required this.text,
      this.bgColor = Colors.blue,
      required this.onPressed});

  @override
  State<CustomdButton> createState() => _CustomdButtonState();
}

class _CustomdButtonState extends State<CustomdButton> {
  var height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.07,
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: widget.bgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Center(
              child: Text(
            widget.text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
        ),
      ),
    );
  }
}
