import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_koi/components/button_block.dart';
import 'package:smart_koi/constant.dart';
import 'package:smart_koi/components/outline_input.dart';
import 'package:smart_koi/network/api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    var data = jsonEncode({
      'username': _usernameController.text,
      'password': _passwordController.text
    });

    try {
      final res = await Api().auth(data, 'auth/login');
      var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', 'Bearer ${body['data']['token']}');

        Navigator.pushReplacementNamed(context, 'home');
      } else {
        EasyLoading.showInfo('Username atau Password salah');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.08),
                  child: Center(
                    child: Image.asset(
                      'assets/images/smartkoi.png',
                      width: size.width * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Text(
                  'Selamat Datang',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Login untuk melanjutkan',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      OutlineInput(
                        controller: _usernameController,
                        labelText: 'Username',
                        validator: (_usernameController) {
                          if (_usernameController == null ||
                              _usernameController.isEmpty) {
                            return 'Field is Required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      OutlineInput(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: _showPassword,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          child: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 22,
                            color: neutral,
                          ),
                        ),
                        validator: (_passwordController) {
                          if (_passwordController == null ||
                              _passwordController.isEmpty) {
                            return 'Field is Required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ButtonBlock(
                  buttonColor: primary,
                  buttonText: 'Login',
                  textColor: primaryContent,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                      // Navigator.pushNamed(context, 'home');
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
