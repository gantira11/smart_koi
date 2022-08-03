import 'package:flutter/material.dart';

class RefreshData extends StatelessWidget {
  const RefreshData({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              'Muat ulang',
              style: TextStyle(fontFamily: 'Rubik'),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.refresh,
              size: 22,
            )
          ],
        ),
      ),
    );
  }
}
