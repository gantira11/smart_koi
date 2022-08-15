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

class ProduksiTambahScreen extends StatefulWidget {
  const ProduksiTambahScreen({Key? key}) : super(key: key);

  @override
  State<ProduksiTambahScreen> createState() => _ProduksiTambahScreenState();
}

class _ProduksiTambahScreenState extends State<ProduksiTambahScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _produksiController = TextEditingController();
  final TextEditingController _persediaanController = TextEditingController();
  final TextEditingController _permintaanController = TextEditingController();

  Future<void> _store() async {
    try {
      var data = jsonEncode({
        "market_demand": int.parse(_permintaanController.text),
        "period_date": _tanggalController.text,
        "production": int.parse(_produksiController.text),
        "stock": int.parse(_persediaanController.text)
      });

      final res = await Api().store('history-productions', data);
      var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        Navigator.pushReplacementNamed(context, 'produksi');
        EasyLoading.showSuccess('Data berhasil di tambah');
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
          'Tambah History Produksi',
          style: TextStyle(
            fontFamily: 'Rubik',
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
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Field tidak boleh kosong';
                  }
                  return null;
                },
                onChanged: (val) => setState(
                  () {
                    _tanggalController.text = val;
                    print(_tanggalController.text);
                  },
                ),
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
          buttonText: 'Simpan',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              EasyLoading.show(status: 'Mohon Tunggu');
              _store();
            }
          },
        ),
      ),
    );
  }
}
