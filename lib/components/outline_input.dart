import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_koi/constant.dart';

class OutlineInput extends StatelessWidget {
  const OutlineInput({
    Key? key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Rubik',
        color: neutral,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        label: Text(
          labelText,
          style: const TextStyle(
            fontFamily: 'Rubik',
            color: neutral,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: neutral,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: neutral,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.redAccent,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon: suffixIcon,
        isDense: true,
      ),
    );
  }
}
