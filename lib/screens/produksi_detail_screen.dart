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
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void _deleteData() async {
    try {
      final res = await Api().delete('history-productions/${widget.id}');

      if (res.statusCode == 200) {
        Navigator.pushReplacementNamed(context, 'produksi');
        EasyLoading.showSuccess('Data berhasil dihapus');
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
              padding: const EdgeInsets.all(12.0),
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
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                'update-produksi',
                                arguments: DetailArgument(widget.id),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: primary,
                              onPrimary: primaryContent,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 20,
                            ),
                            label: const Text(
                              'Ubah Data',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
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
                            style: ElevatedButton.styleFrom(
                              primary: secondary,
                              onPrimary: secondaryContent,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 20,
                            ),
                            label: const Text(
                              'Hapus Data',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
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
                                value: formater
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
        ],
      ),
    );
  }
}
