import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key? key,
    this.bgFocusColor,
    required this.iconData,
    required this.drawerItemText,
    required this.itemColor,
    this.onTap,
  }) : super(key: key);

  final String drawerItemText;
  final Color itemColor;
  final IconData iconData;
  final Color? bgFocusColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: bgFocusColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            children: <Widget>[
              Icon(
                iconData,
                color: itemColor,
              ),
              const SizedBox(width: 15),
              Text(
                drawerItemText,
                style: TextStyle(
                  fontFamily: 'Rubik',
                  color: itemColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
