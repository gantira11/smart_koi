import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_koi/components/button_block.dart';
import 'package:smart_koi/components/card_hasil_perhitungan.dart';
import 'package:smart_koi/components/custom_drawer.dart';
import 'package:smart_koi/components/outline_input.dart';
import 'package:smart_koi/constant.dart';
import 'package:smart_koi/network/api.dart';

class KalkulatorScreen extends StatefulWidget {
  const KalkulatorScreen({Key? key}) : super(key: key);

  @override
  State<KalkulatorScreen> createState() => _KalkulatorScreenState();
}

class _KalkulatorScreenState extends State<KalkulatorScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _permintaanController = TextEditingController();
  final TextEditingController _persediaanController = TextEditingController();

  Map<String, dynamic> kalkulasi = {};
  Map<String, dynamic> user = {};
  bool showCard = false;

  void hitungProduksi() async {
    var data = jsonEncode({
      'market_demand': int.parse(_permintaanController.text),
      'stock': int.parse(_persediaanController.text)
    });

    try {
      final res = await Api().store('calculate-productions', data);
      final resProfile = await Api().fetchData('profile');

      var body = jsonDecode(res.body);
      var bodyProfile = jsonDecode(resProfile.body);

      if (res.statusCode == 200) {
        setState(() {
          kalkulasi = body['data'];
          user = bodyProfile['data'];
        });
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
        onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Kalkulator Produksi',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      OutlineInput(
                        controller: _permintaanController,
                        labelText: 'Permintan',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (_permintaanController) {
                          if (_permintaanController == null ||
                              _permintaanController.isEmpty) {
                            return 'Field tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      OutlineInput(
                        controller: _persediaanController,
                        labelText: 'Persediaan',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (_persediaanController) {
                          if (_persediaanController == null ||
                              _persediaanController.isEmpty) {
                            return 'Field tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      ButtonBlock(
                        buttonText: 'Hitung',
                        buttonColor: primary,
                        textColor: primaryContent,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              kalkulasi = {};
                              hitungProduksi();
                              showCard = true;
                            });
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: showCard,
              child: kalkulasi.isEmpty
                  ? const CircularProgressIndicator()
                  : Container(
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Perhitungan ${user['name']}',
                                style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                child: Row(
                                  children: [
                                    kalkulasi['percentage_calculation']
                                                ['type'] ==
                                            'UP'
                                        ? const Icon(
                                            Icons.arrow_circle_up,
                                            size: 22,
                                            color: Colors.lightGreen,
                                          )
                                        : const Icon(
                                            Icons.arrow_circle_down_outlined,
                                            size: 22,
                                            color: Colors.redAccent,
                                          ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${kalkulasi['percentage_calculation']['percentage']} %'
                                          .toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text('Perbandingan :'),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CardHasilPerhitungan(
                                    labelText: 'Hasil Perhitungan',
                                    periodDate: '',
                                    produksi:
                                        kalkulasi['production'].toString(),
                                    persediaan: kalkulasi['stock'].toString(),
                                    permintaan:
                                        kalkulasi['market_demand'].toString(),
                                  ),
                                  CardHasilPerhitungan(
                                    labelText: 'Produksi Terakhir',
                                    periodDate: formater
                                        .format(
                                          DateTime.parse(
                                            kalkulasi[
                                                    'latest_history_production']
                                                ['period_date'],
                                          ),
                                        )
                                        .toString(),
                                    produksi:
                                        kalkulasi['latest_history_production']
                                                ['production']
                                            .toString(),
                                    persediaan:
                                        kalkulasi['latest_history_production']
                                                ['stock']
                                            .toString(),
                                    permintaan:
                                        kalkulasi['latest_history_production']
                                                ['market_demand']
                                            .toString(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
