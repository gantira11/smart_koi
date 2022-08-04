import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_koi/components/barchart.dart';
import 'package:smart_koi/components/custom_drawer.dart';
import 'package:smart_koi/components/legend_chart.dart';
import 'package:smart_koi/components/refresh_data.dart';
import 'package:smart_koi/constant.dart';
import 'package:smart_koi/network/api.dart';

class ProduksiBarchartScreen extends StatefulWidget {
  const ProduksiBarchartScreen({Key? key}) : super(key: key);

  @override
  State<ProduksiBarchartScreen> createState() => _ProduksiBarchartScreenState();
}

class _ProduksiBarchartScreenState extends State<ProduksiBarchartScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List dataChart = [];

  String sort = '';

  Future<void> fetchData() async {
    try {
      final res = await Api().fetchData('history-productions/barchart');
      var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return body['data'];
      } else if (res.statusCode == 401) {
        EasyLoading.showInfo('Expired Token');
        Navigator.pushNamedAndRemoveUntil(
            context, 'login', (Route<dynamic> route) => false);
      } else {
        EasyLoading.showInfo(body['messages'].toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: neutral,
        elevation: 1,
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
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LegendChart(
                  onTap: () => setState(() {
                    sort = 'permintaan';
                  }),
                  title: 'Permintaan',
                  color: primary,
                ),
                LegendChart(
                  onTap: () => setState(() {
                    sort = 'persediaan';
                  }),
                  title: 'Persediaan',
                  color: const Color(0xFFC149AD),
                ),
                LegendChart(
                  onTap: () => setState(() {
                    sort = 'produksi';
                  }),
                  title: 'Produksi',
                  color: secondary,
                ),
                LegendChart(
                  onTap: () => setState(() {
                    sort = '';
                  }),
                  color: Colors.black,
                  title: 'Lihat Semua',
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return RefreshData(
                    onTap: () => setState(() {}),
                  );
                }

                if (snapshot.hasData) {
                  List<dynamic> data = snapshot.data as List<dynamic>;
                  return Expanded(
                    child: Barchart(
                      data: data,
                      sort: sort,
                    ),
                  );
                }
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
