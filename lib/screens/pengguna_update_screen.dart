import 'dart:convert';

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

  bool showPassword = true;

  Future<void> _fetchData() async {
    try {
      final res = await Api().fetchData('users/${widget.id}');
      var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        setState(() {
          _namaController.text = body['data']['name'];
          _jabatanController.text = body['data']['role'];
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
                OutlineInput(
                  controller: _jabatanController,
                  labelText: 'Jabatan',
                  validator: (_jabatanController) {
                    if (_jabatanController == null ||
                        _jabatanController.isEmpty) {
                      return 'Field tidak boleh kosong';
                    }
                    return null;
                  },
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
