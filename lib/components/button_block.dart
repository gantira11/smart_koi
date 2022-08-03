import 'package:flutter/material.dart';

class ButtonBlock extends StatelessWidget {
  const ButtonBlock({
    Key? key,
    required this.buttonText,
    this.onPressed,
    this.textColor,
    this.buttonColor,
    this.fontWeight,
    this.fontSize,
  }) : super(key: key);

  final String buttonText;
  final Color? textColor;
  final Function()? onPressed;
  final Color? buttonColor;
  final FontWeight? fontWeight;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 1,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            fontFamily: 'Rubik',
            color: textColor,
            fontWeight: fontWeight,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
