import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_koi/components/button_block.dart';
import 'package:smart_koi/components/content_detail_loader.dart';
import 'package:smart_koi/components/content_detail_row.dart';
import 'package:smart_koi/components/custom_drawer.dart';
import 'package:smart_koi/components/refresh_data.dart';
import 'package:smart_koi/constant.dart';
import 'package:smart_koi/network/api.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> fetchProfile() async {
    try {
      final res = await Api().fetchData('profile');
      var body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return body['data'];
      } else if (res.statusCode == 401) {
        EasyLoading.showInfo('Expired Token');
        Navigator.pushNamedAndRemoveUntil(
            context, 'login', (Route<dynamic> route) => false);
      } else {
        EasyLoading.dismiss();
        EasyLoading.showInfo(body['messages'].toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void _logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    localStorage.remove('token');

    localStorage.remove('role');

    Navigator.pushNamedAndRemoveUntil(
      context,
      'login',
      (Route<dynamic> route) => false,
    );
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
      ),
      drawer: CustomDrawer(
        onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
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
              padding:
                  const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            'update-profile',
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
                    ],
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                    future: fetchProfile(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                            child: RefreshData(
                              onTap: () => setState(() {}),
                            ),
                          );
                        }

                        if (snapshot.hasData) {
                          var profile = snapshot.data as Map<String, dynamic>;
                          return Column(
                            children: [
                              ContentDetailRow(
                                labelText: 'Nama',
                                value: profile['name'],
                              ),
                              ContentDetailRow(
                                labelText: 'Jabatan',
                                value: profile['role'] == 'ADMIN'
                                    ? 'Admin'
                                    : profile['role'] == 'HEAD_OFFICER'
                                        ? 'Kepala Petugas'
                                        : 'Petugas',
                              ),
                              ContentDetailRow(
                                labelText: 'No.Telp',
                                value: profile['phone_number'],
                              ),
                              ContentDetailRow(
                                labelText: 'Username',
                                value: profile['username'],
                              )
                            ],
                          );
                        }
                      }

                      return Column(
                        children: const [
                          ContentDetailLoader(labelText: 'Nama'),
                          ContentDetailLoader(labelText: 'Jabatan'),
                          ContentDetailLoader(labelText: 'No.Telp'),
                          ContentDetailLoader(labelText: 'Username'),
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
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ButtonBlock(
          buttonText: 'Logout',
          onPressed: () {
            _logout();
          },
        ),
      ),
    );
  }
}
