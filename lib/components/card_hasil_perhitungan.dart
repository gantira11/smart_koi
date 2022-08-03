import 'package:flutter/material.dart';

class CardHasilPerhitungan extends StatelessWidget {
  const CardHasilPerhitungan({
    Key? key,
    required this.labelText,
    required this.produksi,
    required this.persediaan,
    required this.permintaan,
    required this.periodDate,
  }) : super(key: key);

  final String labelText;
  final String produksi;
  final String persediaan;
  final String permintaan;
  final String periodDate;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.45,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labelText,
                style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                periodDate,
                style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Produksi',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 14,
                ),
              ),
              Text(
                produksi,
                style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Persediaan',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 14,
                ),
              ),
              Text(
                persediaan,
                style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Permintaan',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 14,
                ),
              ),
              Text(
                permintaan,
                style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
