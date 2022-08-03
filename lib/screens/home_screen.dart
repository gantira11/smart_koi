import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletons/skeletons.dart';
import 'package:smart_koi/components/card_informasi_nilai.dart';
import 'package:smart_koi/components/card_informasi_nilai_loader.dart';
import 'package:smart_koi/components/custom_drawer.dart';
import 'package:smart_koi/components/button_icon.dart';
import 'package:smart_koi/components/refresh_data.dart';
import 'package:smart_koi/constant.dart';
import 'package:smart_koi/network/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> fetchProfile() async {
    try {
      final res = await Api().fetchData('profile');
      var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('role', body['data']['role']);

        return body;
      } else if (res.statusCode == 401) {
        EasyLoading.showInfo('Expired Token');
        Navigator.pushNamedAndRemoveUntil(
            context, 'login', (Route<dynamic> route) => false);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fetchStat() async {
    try {
      final res = await Api().fetchData('history-productions/stat');
      var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        Future.delayed(const Duration(seconds: 4));

        return body;
      } else if (res.statusCode == 401) {
        EasyLoading.showInfo('Expired Token');
        Navigator.pushNamedAndRemoveUntil(
            context, 'login', (Route<dynamic> route) => false);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryContent,
        foregroundColor: neutral,
        elevation: 0,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(
            Icons.short_text,
          ),
        ),
      ),
      drawer: CustomDrawer(
        onPressed: () {
          _scaffoldKey.currentState?.openEndDrawer();
        },
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: primaryContent,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 1,
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: FutureBuilder(
                          future: fetchProfile(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: RefreshData(
                                    onTap: () {
                                      setState(() {});
                                    },
                                  ),
                                );
                              }
                              if (snapshot.hasData) {
                                final profile =
                                    snapshot.data as Map<String, dynamic>;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      'Selamat Datang',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        // fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      profile['data']['name'],
                                      style: const TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'AS ${profile['data']['role']}',
                                      style: const TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    width: 110,
                                    height: 14,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    width: 120,
                                    height: 16,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    width: 100,
                                    height: 14,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: size.width * 1,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const <Widget>[
                                Icon(Icons.bubble_chart_outlined),
                                SizedBox(width: 8),
                                Text(
                                  'Fitur',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ButtonIcon(
                                  buttonText: 'Grafik Analisa',
                                  iconData: Icons.bar_chart_rounded,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, 'barchart-produksi');
                                  },
                                ),
                                ButtonIcon(
                                  buttonText: 'Kalkulator Poduksi',
                                  iconData: Icons.calculate_outlined,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, 'kalkulator-produksi');
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Informasi Nilai',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder(
                        future: fetchStat(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Center(
                                child: RefreshData(
                                  onTap: () {
                                    setState(() {});
                                  },
                                ),
                              );
                            }

                            if (snapshot.hasData) {
                              final stat =
                                  snapshot.data as Map<String, dynamic>;

                              return Column(
                                children: [
                                  CardInformasiNilai(
                                    minValue: stat['data']['min_market_demand']
                                        .toString(),
                                    maxValue: stat['data']['max_market_demand']
                                        .toString(),
                                    infoValue: 'Permintaan Pasar',
                                  ),
                                  CardInformasiNilai(
                                    minValue: stat['data']['min_production']
                                        .toString(),
                                    maxValue: stat['data']['max_production']
                                        .toString(),
                                    infoValue: 'Produksi',
                                  ),
                                  CardInformasiNilai(
                                    minValue:
                                        stat['data']['min_stock'].toString(),
                                    maxValue:
                                        stat['data']['max_stock'].toString(),
                                    infoValue: 'Persediaan',
                                  ),
                                ],
                              );
                            }
                          }
                          return Column(
                            children: const <CardInformasiNilaiLoader>[
                              CardInformasiNilaiLoader(),
                              CardInformasiNilaiLoader(),
                              CardInformasiNilaiLoader(),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
