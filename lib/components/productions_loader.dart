import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class ProductionsLoader extends StatelessWidget {
  const ProductionsLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.5,
      child: ListView(
        children: const [
          RowProductionsLoader(),
          RowProductionsLoader(),
          RowProductionsLoader(),
          RowProductionsLoader(),
          RowProductionsLoader(),
          RowProductionsLoader(),
          RowProductionsLoader(),
          RowProductionsLoader(),
          RowProductionsLoader(),
          RowProductionsLoader(),
          RowProductionsLoader(),
        ],
      ),
    );
  }
}

class RowProductionsLoader extends StatelessWidget {
  const RowProductionsLoader({
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
                  alignment: AlignmentDirectional.center,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SkeletonLine(
                style: SkeletonLineStyle(
                  height: 30,
                  width: 60,
                  borderRadius: BorderRadius.circular(10),
                  alignment: AlignmentDirectional.center,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SkeletonLine(
                style: SkeletonLineStyle(
                  height: 30,
                  width: 60,
                  borderRadius: BorderRadius.circular(10),
                  alignment: AlignmentDirectional.center,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SkeletonLine(
                style: SkeletonLineStyle(
                  height: 30,
                  width: 60,
                  borderRadius: BorderRadius.circular(10),
                  alignment: AlignmentDirectional.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
