import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smart_koi/components/custom_drawer.dart';
import 'package:smart_koi/components/pengguna_loader.dart';
import 'package:smart_koi/components/refresh_data.dart';
import 'package:smart_koi/constant.dart';
import 'package:smart_koi/network/api.dart';
import 'package:smart_koi/router/router_generator.dart';

class PenggunaScreen extends StatefulWidget {
  const PenggunaScreen({Key? key}) : super(key: key);

  @override
  State<PenggunaScreen> createState() => _PenggunaScreenState();
}

class _PenggunaScreenState extends State<PenggunaScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List users = [];
  String searchUser = '';

  int? _value = 2;

  Map<String, String> queryParams = {
    'start_date': '',
    'end_date': '',
    'limit': '999',
    'page': '1',
    'sort': 'id asc'
  };

  Future<void> fetchData() async {
    try {
      final res = await Api().fetchDataWithParams('users', queryParams);
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

  @override
  void initState() {
    super.initState();
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'tambah-pengguna');
            },
            icon: const Icon(
              Icons.add_box_outlined,
              size: 28,
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(
        onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * 0.9,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Text(
                          'Users',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: size.width * 0.7,
                              child: TextFormField(
                                onChanged: (value) => setState(() {
                                  searchUser = value.toLowerCase();
                                }),
                                style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Cari nama user',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 14,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    size: 22,
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  isDense: true,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => showMaterialModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  color: Colors.white,
                                  height: 180,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Urutkan',
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              child: Icon(
                                                Icons.close,
                                                size: 22,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Divider(thickness: 1),
                                        SizedBox(height: 5),
                                        GestureDetector(
                                          onTap: () => setState(() {
                                            _value = 1;
                                            queryParams['sort'] = 'id desc';
                                            Navigator.pop(context);
                                          }),
                                          child: Container(
                                            color: Colors.white,
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Terbaru',
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                  ),
                                                ),
                                                Radio(
                                                  value: 1,
                                                  groupValue: _value,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _value = value as int;
                                                      queryParams['sort'] =
                                                          'id desc';
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => setState(() {
                                            _value = 2;
                                            queryParams['sort'] = 'id asc';
                                            Navigator.pop(context);
                                          }),
                                          child: Container(
                                            color: Colors.white,
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Terlama',
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                  ),
                                                ),
                                                Radio(
                                                  value: 2,
                                                  groupValue: _value,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _value = value as int;
                                                      queryParams['sort'] =
                                                          'id asc';
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              child: Container(
                                width: size.width * 0.18,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Icon(
                                      Icons.filter_list_rounded,
                                      size: 20,
                                      color: primaryContent,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Urutkan',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        color: primaryContent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Table(
                        children: const <TableRow>[
                          TableRow(
                            decoration: BoxDecoration(
                              color: primaryContent,
                            ),
                            children: <Widget>[
                              Center(
                                heightFactor: 2,
                                child: Text(
                                  'Nama',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Center(
                                heightFactor: 2,
                                child: Text(
                                  'Jabatan',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Center(
                                heightFactor: 2,
                                child: Text(
                                  'No. Telp',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      FutureBuilder(
                        future: fetchData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return RefreshData(onTap: () => setState(() {}));
                            }

                            if (snapshot.hasData) {
                              var data = snapshot.data as Map<String, dynamic>;
                              var users = data['contents'];

                              return Expanded(
                                child: ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (context, i) {
                                    return users[i]['name']
                                            .toLowerCase()
                                            .contains(searchUser)
                                        ? Table(
                                            children: [
                                              TableRow(
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                        context,
                                                        'detail-pengguna',
                                                        arguments:
                                                            DetailArgument(
                                                          users[i]['id'],
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 12,
                                                        horizontal: 10,
                                                      ),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          users[i]['name'],
                                                          style:
                                                              const TextStyle(
                                                            fontFamily: 'Rubik',
                                                            color: secondary,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 12,
                                                      horizontal: 10,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        users[i]['role'] ==
                                                                "Admin"
                                                            ? 'Admin'
                                                            : users[i]['role'] ==
                                                                    'HEAD_OFFICER'
                                                                ? 'Kepala Petugas'
                                                                : 'Petugas',
                                                        style: const TextStyle(
                                                          fontFamily: 'Rubik',
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 12,
                                                      horizontal: 10,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        users[i]
                                                            ['phone_number'],
                                                        style: const TextStyle(
                                                          fontFamily: 'Rubik',
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : Container();
                                  },
                                ),
                              );
                            }
                          }
                          return const PenggunaLoader();
                        },
                      )
                    ],
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
