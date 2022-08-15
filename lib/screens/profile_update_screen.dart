import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_koi/components/button_block.dart';
import 'package:smart_koi/components/custom_drawer.dart';
import 'package:smart_koi/components/outline_input.dart';
import 'package:smart_koi/constant.dart';
import 'package:smart_koi/network/api.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();

  bool showPassword = false;

  Future<void> fetchProfile() async {
    try {
      final res = await Api().fetchData('profile');
      var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        setState(() {
          _namaController.text = body['data']['name'];
          _noTelpController.text = body['data']['phone_number'];
        });
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

  Future<void> _update() async {
    try {
      var data = jsonEncode({
        'name': _namaController.text,
        'password': _passwordController.text,
        'phone_number': _noTelpController.text,
      });

      final res = await Api().update('profile', data);
      var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        Navigator.pushReplacementNamed(context, 'profile');
        EasyLoading.showSuccess('Data berhasil di update');
      } else {
        EasyLoading.showInfo(body['messages'].toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
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
          'Ubah Profile',
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
              OutlineInput(
                controller: _namaController,
                labelText: 'Nama',
                validator: (_namaController) {
                  if (_namaController == null || _namaController.isEmpty) {
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
              ),
              const SizedBox(height: 15),
              OutlineInput(
                controller: _noTelpController,
                labelText: 'No. Telp',
                keyboardType: TextInputType.number,
                validator: (_noTelpController) {
                  if (_noTelpController == null || _noTelpController.isEmpty) {
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
          buttonText: 'Update',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // EasyLoading.show(status: 'Mohon Tunggu');
              _update();
            }
          },
        ),
      ),
    );
  }
}
