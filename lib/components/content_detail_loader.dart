import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class ContentDetailLoader extends StatelessWidget {
  const ContentDetailLoader({
    Key? key,
    required this.labelText,
  }) : super(key: key);

  final String labelText;

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
          SkeletonLine(
            style: SkeletonLineStyle(
              width: 80,
              height: 10,
              borderRadius: BorderRadius.circular(20),
            ),
          )
        ],
      ),
    );
  }
}
