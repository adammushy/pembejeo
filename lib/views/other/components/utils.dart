import 'package:flutter/material.dart';

const white = Colors.white;
const secondary = Color(0xffa6a6a6);
const iconGray = Color(0xff767676);
const black = Colors.black;
const primary = Color(0xff262626);
const primaryBg = Color(0xfff5f5fd);
const secondaryBg = Color(0xffececf6);
const barBg = Color(0xffe3e3ee);
const defaultPadding = 16.0;

class TextWidget extends StatelessWidget {
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final String text;

  const TextWidget({
    Key? key,
    required this.size,
    required this.fontWeight,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontFamily: 'Poppins',
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}

