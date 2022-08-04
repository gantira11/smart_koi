import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_koi/components/content_detail_loader.dart';
import 'package:smart_koi/components/content_detail_row.dart';
import 'package:smart_koi/components/custom_drawer.dart';
import 'package:smart_koi/components/refresh_data.dart';
import 'package:smart_koi/constant.dart';
import 'package:smart_koi/network/api.dart';
import 'package:smart_koi/router/router_generator.dart';

class ProduksiDetailScreen extends StatefulWidget {
  const ProduksiDetailScreen({Key? key, this.id}) : super(key: key);

  final id;

  @override
  State<ProduksiDetailScreen> createState() => _ProduksiDetailScreenState();
}

class _ProduksiDetailScreenState extends State<ProduksiDetailScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> fetchDetail() async {
    try {
      final res = await Api().fetchData('history-productions/${widget.id}');
      var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return body['data'];
      } else {
        EasyLoading.showInfo(body['messages'].toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void _deleteData() async {
    try {
      final res = await Api().delete('history-productions/${widget.id}');
      var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        Navigator.pushReplacementNamed(context, 'produksi');
        EasyLoading.showSuccess('Data berhasil dihapus');
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
      ),
      drawer: CustomDrawer(
        onPressed: () {
          _scaffoldKey.currentState?.openEndDrawer();
        },
      ),
      body: Column(
        children: [
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                left: 12.0,
                right: 12.0,
                bottom: 0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Produksi',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                'update-produksi',
                                arguments: DetailArgument(widget.id),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 20,
                                    color: neutral,
                                  ),
                                  SizedBox(height: 3),
                                  Text('Ubah')
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text(
                                    'Hapus Data',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 14,
                                    ),
                                  ),
                                  content: const Text(
                                    'Apakah anda yakin ingin menghapus data ini?',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 14,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _deleteData();
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text(
                                        'Ya',
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text(
                                        'Tidak',
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.delete_outline_rounded,
                                    size: 20,
                                    color: neutral,
                                  ),
                                  SizedBox(height: 3),
                                  Text('Hapus')
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder(
                    future: fetchDetail(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return RefreshData(
                            onTap: () => setState(() {}),
                          );
                        }

                        if (snapshot.hasData) {
                          var detailProduksi =
                              snapshot.data as Map<String, dynamic>;
                          return Column(
                            children: [
                              ContentDetailRow(
                                labelText: 'Tanggal',
                                value: formatMMM
                                    .format(DateTime.parse(
                                        detailProduksi['period_date']))
                                    .toString(),
                              ),
                              ContentDetailRow(
                                labelText: 'Produksi',
                                value: detailProduksi['production'].toString(),
                              ),
                              ContentDetailRow(
                                labelText: 'Permintaan',
                                value:
                                    detailProduksi['market_demand'].toString(),
                              ),
                              ContentDetailRow(
                                labelText: 'Persediaan',
                                value: detailProduksi['stock'].toString(),
                              )
                            ],
                          );
                        }
                      }

                      return Column(
                        children: const [
                          ContentDetailLoader(labelText: 'Tanggal'),
                          ContentDetailLoader(labelText: 'Produksi'),
                          ContentDetailLoader(labelText: 'Persediaan'),
                          ContentDetailLoader(labelText: 'Permintaan'),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    'update-produksi',
                    arguments: DetailArgument(
                      widget.id,
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(20)),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 12,
                        color: secondaryContent,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Ubah data',
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        color: Colors.transparent,
                        decorationColor: primary,
                        decorationThickness: 3,
                        shadows: [
                          Shadow(
                            color: neutral,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: size.width * 0.8,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: secondary,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: secondary,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text(
                          'Hapus Data',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 14,
                          ),
                        ),
                        content: const Text(
                          'Apakah anda yakin ingin menghapus data ini?',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 14,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _deleteData();
                              Navigator.pop(ctx);
                            },
                            child: const Text(
                              'Ya',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                            child: const Text(
                              'Tidak',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'Hapus Data Produksi',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
