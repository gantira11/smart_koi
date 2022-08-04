import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:smart_koi/constant.dart';

class StatButtonLoader extends StatelessWidget {
  const StatButtonLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SkeletonLine(
              style: SkeletonLineStyle(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Divider(
            thickness: 2,
            indent: 10,
            endIndent: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      width: 80,
                      height: 15,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(height: 5),
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      width: 50,
                      height: 15,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
              Container(
                height: 30,
                width: 1,
                color: Colors.grey,
              ),
              Column(
                children: [
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      width: 80,
                      height: 15,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(height: 5),
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      width: 50,
                      height: 15,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'barchart-produksi');
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lihat Grafik Analisis',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w500,
                      color: secondaryContent,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 22,
                    color: secondaryContent,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
