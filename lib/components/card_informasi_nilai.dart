import 'package:flutter/material.dart';

class CardInformasiNilai extends StatelessWidget {
  const CardInformasiNilai({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.infoValue,
  }) : super(key: key);

  final String minValue;
  final String maxValue;
  final String infoValue;

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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Min',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        minValue,
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    color: Colors.grey,
                    height: 30,
                  ),
                  Column(
                    children: [
                      const Text(
                        'Max',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        maxValue,
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              Text(
                infoValue,
                style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
