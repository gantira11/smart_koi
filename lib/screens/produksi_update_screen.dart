import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_koi/components/button_block.dart';
import 'package:smart_koi/components/custom_drawer.dart';
import 'package:smart_koi/components/outline_input.dart';
import 'package:smart_koi/constant.dart';
import 'package:smart_koi/network/api.dart';
import 'package:smart_koi/router/router_generator.dart';

class ProduksiUpdateScreen extends StatefulWidget {
  const ProduksiUpdateScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  State<ProduksiUpdateScreen> createState() => _ProduksiUpdateScreenState();
}

class _ProduksiUpdateScreenState extends State<ProduksiUpdateScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  int idProduksi = 0;

  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _produksiController = TextEditingController();
  final TextEditingController _persediaanController = TextEditingController();
  final TextEditingController _permintaanController = TextEditingController();

  Future<void> fetchData() async {
    try {
      final res = await Api().fetchData('history-productions/${widget.id}');
      final body = jsonDecode(res.body);

      setState(() {
        idProduksi = body['data']['id'];
        _tanggalController.text = body['data']['period_date'];
        _produksiController.text = body['data']['production'].toString();
        _persediaanController.text = body['data']['stock'].toString();
        _permintaanController.text = body['data']['market_demand'].toString();
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _update() async {
    try {
      var data = jsonEncode({
        "id": idProduksi,
        "market_demand": int.parse(_permintaanController.text),
        "period_date": _tanggalController.text,
        "production": int.parse(_produksiController.text),
        "stock": int.parse(_persediaanController.text)
      });

      final res = await Api().update('history-productions/${widget.id}', data);
      var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        Navigator.popUntil(context, ModalRoute.withName('produksi'));
        Navigator.pushNamed(
          context,
          'produksi',
          arguments: DetailArgument(widget.id),
        );
        EasyLoading.showSuccess('Data berhasil di update');
      } else if (res.statusCode == 401) {
        EasyLoading.showInfo('Expired Token');
        Navigator.pushNamedAndRemoveUntil(
            context, 'login', (Route<dynamic> route) => false);
      } else {
        EasyLoading.dismiss();
        EasyLoading.showInfo(body['messages'].toString());
      }
    } catch (e) {
      EasyLoading.showInfo("Terjadi Kesalahan");
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
        title: const Text(
          'Ubah data histori produksi',
          style: TextStyle(
            fontFamily: 'Rubik',
            fontSize: 18,
          ),
        ),
      ),
      drawer: CustomDrawer(
        onPressed: () {
          _scaffoldKey.currentState?.openEndDrawer();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DateTimePicker(
                controller: _tanggalController,
                dateMask: 'd-MMM-yyyy',
                type: DateTimePickerType.date,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  label: const Text(
                    'Tanggal',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      color: neutral,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                      color: neutral,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                      color: neutralFocus,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  isDense: true,
                ),
                validator: (_tanggalController) {
                  if (_tanggalController == null ||
                      _tanggalController.isEmpty) {
                    return 'Field tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              OutlineInput(
                controller: _produksiController,
                labelText: 'Produksi',
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (_produksiController) {
                  if (_produksiController == null ||
                      _produksiController.isEmpty) {
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
              OutlineInput(
                controller: _permintaanController,
                labelText: 'Permintaan',
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
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ButtonBlock(
          buttonText: 'Ubah Data',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _update();
            }
          },
        ),
      ),
    );
  }
}
