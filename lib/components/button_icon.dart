import 'package:flutter/material.dart';
import 'package:smart_koi/constant.dart';

class ButtonIcon extends StatelessWidget {
  const ButtonIcon({
    Key? key,
    required this.buttonText,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  final String buttonText;
  final IconData iconData;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: primary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    iconData,
                    size: 30,
                    color: primaryContent,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                buttonText,
                style: const TextStyle(
                  fontFamily: 'Rubik',
                  color: neutral,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
