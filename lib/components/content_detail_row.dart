import 'package:flutter/material.dart';

class ContentDetailRow extends StatelessWidget {
  const ContentDetailRow({
    Key? key,
    required this.labelText,
    required this.value,
  }) : super(key: key);

  final String labelText;
  final String value;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.4,
            color: Colors.grey,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: size.width * 0.3,
            child: Text(
              labelText,
              style: const TextStyle(
                fontFamily: 'Rubik',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
