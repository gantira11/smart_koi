import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_koi/components/button_block.dart';
import 'package:smart_koi/components/custom_drawer.dart';
import 'package:smart_koi/components/outline_input.dart';
import 'package:smart_koi/constant.dart';
import 'package:smart_koi/network/api.dart';
import 'package:smart_koi/router/router_generator.dart';

class PenggunaUpdateScreen extends StatefulWidget {
  const PenggunaUpdateScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  State<PenggunaUpdateScreen> createState() => _PenggunaUpdateScreenState();
}

class _PenggunaUpdateScreenState extends State<PenggunaUpdateScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<String> jabatan = ['Admin', 'Kepala Petugas', 'Petugas'];
  String? selectedValue;

  bool showPassword = true;

  Future<void> _fetchData() async {
    try {
      final res = await Api().fetchData('users/${widget.id}');
      var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        setState(() {
          _namaController.text = body['data']['name'];
          selectedValue = body['data']['role'] == 'ADMIN'
              ? 'Admin'
              : body['data']['role'] == 'HEAD_OFFICER'
                  ? 'Kepala Petugas'
                  : 'Petugas';
          _noTelpController.text = body['data']['phone_number'];
          _usernameController.text = body['data']['username'];
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _update() async {
    try {
      var data = jsonEncode({
        'id': widget.id,
        'name': _namaController.text,
        'role': _jabatanController.text.toUpperCase(),
        'phone_number': _noTelpController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
      });

      final res = await Api().update('users/${widget.id}', data);

      if (res.statusCode == 200) {
        EasyLoading.showSuccess('Data berhasil di update');
        Navigator.popUntil(context, ModalRoute.withName('pengguna'));

        Navigator.pushNamed(
          context,
          'pengguna',
          arguments: DetailArgument(widget.id),
        );
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
  void initState() {
    super.initState();
    _fetchData();
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
          'Ubah data pengguna',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                OutlineInput(
                  controller: _namaController,
                  labelText: 'Nama Lengkap',
                  validator: (_namaController) {
                    if (_namaController == null || _namaController.isEmpty) {
                      return 'Field tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField2(
                  value: selectedValue,
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    color: neutral,
                  ),
                  items: jabatan
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Field tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      if (value == 'Admin') {
                        _jabatanController.text = 'ADMIN';
                      } else if (value == 'Kepala Petugas') {
                        _jabatanController.text = 'HEAD_OFFICER';
                      } else {
                        _jabatanController.text = 'OFFICER';
                      }
                    });
                  },
                  onSaved: (value) {
                    selectedValue = value.toString();
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    label: Text(
                      'Jabatan',
                      style: const TextStyle(
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
                        color: neutral,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.redAccent,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 15),
                OutlineInput(
                  controller: _noTelpController,
                  labelText: 'No. Telp',
                  keyboardType: TextInputType.number,
                  validator: (_noTelpController) {
                    if (_noTelpController == null ||
                        _noTelpController.isEmpty) {
                      return 'Field tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                OutlineInput(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: showPassword ? true : false,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    child: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      size: 22,
                      color: Colors.grey,
                    ),
                  ),
                  validator: (_passwordController) {
                    if (_passwordController == null ||
                        _passwordController.isEmpty) {
                      return 'Field tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 90),
              ],
            ),
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
              _update();
            }
          },
        ),
      ),
    );
  }
}
