import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class PenggunaLoader extends StatelessWidget {
  const PenggunaLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.5,
      child: ListView(
        children: const [
          RowPenggunaLoader(),
          RowPenggunaLoader(),
          RowPenggunaLoader(),
          RowPenggunaLoader(),
          RowPenggunaLoader(),
          RowPenggunaLoader(),
        ],
      ),
    );
  }
}

class RowPenggunaLoader extends StatelessWidget {
  const RowPenggunaLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SkeletonLine(
                style: SkeletonLineStyle(
                  height: 30,
                  width: 100,
                  borderRadius: BorderRadius.circular(10),
                  alignment: AlignmentDirectional.centerStart,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SkeletonLine(
                style: SkeletonLineStyle(
                  height: 30,
                  width: 100,
                  borderRadius: BorderRadius.circular(10),
                  alignment: AlignmentDirectional.centerStart,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SkeletonLine(
                style: SkeletonLineStyle(
                  height: 30,
                  width: 120,
                  borderRadius: BorderRadius.circular(10),
                  alignment: AlignmentDirectional.centerStart,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
