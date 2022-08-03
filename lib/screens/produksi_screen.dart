import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_koi/components/button_block.dart';
import 'package:smart_koi/components/custom_drawer.dart';
import 'package:smart_koi/components/productions_loader.dart';
import 'package:smart_koi/components/refresh_data.dart';
import 'package:smart_koi/constant.dart';
import 'package:smart_koi/network/api.dart';
import 'package:smart_koi/router/router_generator.dart';

class ProduksiScreen extends StatefulWidget {
  const ProduksiScreen({Key? key}) : super(key: key);

  @override
  State<ProduksiScreen> createState() => _ProduksiScreenState();
}

class _ProduksiScreenState extends State<ProduksiScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _tanggalMulai = TextEditingController();
  final TextEditingController _tanggalSelesai = TextEditingController();

  Map<String, String> queryParams = {
    'start_date': '',
    'end_date': '',
    'limit': '999',
    'page': '1',
    'sort': 'id asc'
  };

  Future<void> fetchProduksi() async {
    try {
      final res =
          await Api().fetchDataWithParams('history-productions', queryParams);
      var body = jsonDecode(res.body);
      if (res.statusCode == 200) {
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
        backgroundColor: Colors.white,
        foregroundColor: neutral,
        elevation: 1,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(
            Icons.short_text,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'tambah-produksi');
            },
            icon: const Icon(
              Icons.add_box_outlined,
              size: 28,
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(
        onPressed: () {
          _scaffoldKey.currentState?.openEndDrawer();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                children: [
                  ButtonBlock(
                    buttonText: 'Analisis Produk Anda',
                    buttonColor: primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: primaryContent,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 10),
                  ButtonBlock(
                    buttonText: 'Lihat Grafik Produksi',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    buttonColor: secondary,
                    textColor: secondaryContent,
                    onPressed: () {
                      Navigator.pushNamed(context, 'barchart-produksi');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Text(
                        'History Produksi',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: size.width * 0.35,
                            child: DateTimePicker(
                              controller: _tanggalMulai,
                              dateMask: 'd-MMM-yyyy',
                              style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                              type: DateTimePickerType.date,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              decoration: InputDecoration(
                                hintText: 'Tanggal Mulai',
                                suffixIcon: queryParams['start_date'] != ''
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            queryParams['start_date'] = '';
                                          });
                                          _tanggalMulai.clear();
                                        },
                                        icon: const Icon(
                                          Icons.clear,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : null,
                                suffixIconConstraints:
                                    const BoxConstraints(minWidth: 20),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                isDense: true,
                              ),
                              onChanged: (_) => setState(
                                () {
                                  queryParams['start_date'] =
                                      _tanggalMulai.text;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.35,
                            child: DateTimePicker(
                              controller: _tanggalSelesai,
                              dateMask: 'd-MMM-yyyy',
                              style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                              type: DateTimePickerType.date,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              decoration: InputDecoration(
                                hintText: 'Tanggal Akhir',
                                suffixIcon: queryParams['end_date'] != ''
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            queryParams['end_date'] = '';
                                          });
                                          _tanggalSelesai.clear();
                                        },
                                        icon: const Icon(
                                          Icons.clear,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : null,
                                suffixIconConstraints:
                                    const BoxConstraints(minWidth: 30),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                isDense: true,
                              ),
                              onChanged: (_) => setState(
                                () {
                                  queryParams['end_date'] =
                                      _tanggalSelesai.text;
                                },
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (queryParams['sort'] == 'id asc') {
                                  queryParams['sort'] = 'id desc';
                                } else {
                                  queryParams['sort'] = 'id asc';
                                }
                              });
                            },
                            child: Container(
                              width: size.width * 0.18,
                              height: 45,
                              decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(
                                    Icons.filter_list_rounded,
                                    size: 20,
                                    color: primaryContent,
                                  ),
                                  Text(
                                    'Urutkan',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      color: primaryContent,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Table(
                      children: const <TableRow>[
                        TableRow(
                          decoration: BoxDecoration(
                            color: primaryContent,
                          ),
                          children: <Widget>[
                            Center(
                              heightFactor: 2,
                              child: Text(
                                'Tanggal',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Center(
                              heightFactor: 2,
                              child: Text(
                                'Permintaan',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Center(
                              heightFactor: 2,
                              child: Text(
                                'Persediaan',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Center(
                              heightFactor: 2,
                              child: Text(
                                'Produksi',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.74,
                      child: FutureBuilder(
                        future: fetchProduksi(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return RefreshData(
                                onTap: () {
                                  setState(() {
                                    fetchProduksi();
                                  });
                                },
                              );
                            }

                            if (snapshot.hasData) {
                              final datas =
                                  snapshot.data as Map<String, dynamic>;

                              final produksi =
                                  datas['data']['contents'] == null ||
                                          datas['data']['contents'].isEmpty
                                      ? []
                                      : datas['data']['contents'];

                              return SizedBox(
                                height: size.height * 0.2,
                                child: Material(
                                  child: produksi.isEmpty
                                      ? const Center(
                                          child: Text('data tidak ditemukan'),
                                        )
                                      : ListView.builder(
                                          itemCount: produksi.length,
                                          itemBuilder: (context, i) {
                                            return Table(
                                              children: [
                                                TableRow(
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          'detail-produksi',
                                                          arguments:
                                                              DetailArgument(
                                                            produksi[i]['id'],
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 12,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            formater
                                                                .format(DateTime
                                                                    .parse(produksi[
                                                                            i][
                                                                        'period_date']))
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Rubik',
                                                              color: secondary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 12,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          produksi[i][
                                                                  'market_demand']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontFamily:
                                                                      'Rubik'),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 12,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          produksi[i]['stock']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontFamily:
                                                                      'Rubik'),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 12,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          produksi[i]
                                                                  ['production']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontFamily:
                                                                      'Rubik'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                ),
                              );
                            }
                          }
                          return const ProductionsLoader();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
