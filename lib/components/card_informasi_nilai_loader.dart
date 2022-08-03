import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class CardInformasiNilaiLoader extends StatelessWidget {
  const CardInformasiNilaiLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 1,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: const [
                      SkeletonLine(
                        style: SkeletonLineStyle(width: 25),
                      ),
                      SizedBox(height: 5),
                      SkeletonLine(
                        style: SkeletonLineStyle(width: 40),
                      )
                    ],
                  ),
                  Container(
                    width: 1,
                    color: Colors.grey,
                    height: 30,
                  ),
                  Column(
                    children: const [
                      SkeletonLine(
                        style: SkeletonLineStyle(width: 25),
                      ),
                      SizedBox(height: 5),
                      SkeletonLine(
                        style: SkeletonLineStyle(width: 40),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              const SkeletonLine(),
            ],
          ),
        ),
      ),
    );
  }
}
