import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_koi/components/drawer_item.dart';
import 'package:smart_koi/constant.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final void Function()? onPressed;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool showPengguna = true;
  String role = '';

  void setRole() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    setState(() {
      role = localStorage.getString('role').toString();
      if (role == 'OFFICER') {
        showPengguna = false;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setRole();
  }

  @override
  Widget build(BuildContext context) {
    String? currentRoute = ModalRoute.of(context)?.settings.name;
    return Drawer(
      backgroundColor: neutralContent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: const TextSpan(
                    text: 'Smart ',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      color: neutral,
                      fontSize: 28,
                    ),
                    children: [
                      TextSpan(
                        text: 'KOI',
                        style: TextStyle(
                          color: neutral,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: widget.onPressed,
                  icon: const Icon(Icons.arrow_back_ios),
                )
              ],
            ),
            const Divider(
              thickness: 2,
              color: primaryContent,
            ),
            DrawerItem(
              onTap: () async {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'home');
              },
              iconData: Icons.home_outlined,
              drawerItemText: 'Home',
              bgFocusColor: currentRoute == 'home' ? primary : null,
              itemColor: currentRoute == 'home' ? primaryContent : neutral,
            ),
            DrawerItem(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'produksi');
              },
              iconData: Icons.history,
              drawerItemText: 'Produksi',
              bgFocusColor: currentRoute == 'produksi' ? primary : null,
              itemColor: currentRoute == 'produksi' ? primaryContent : neutral,
            ),
            DrawerItem(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'kalkulator-produksi');
              },
              iconData: Icons.calculate_outlined,
              drawerItemText: 'Kalkulator Produksi',
              bgFocusColor:
                  currentRoute == 'kalkulator-produksi' ? primary : null,
              itemColor: currentRoute == 'kalkulator-produksi'
                  ? primaryContent
                  : neutral,
            ),
            Visibility(
              visible: showPengguna,
              child: DrawerItem(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'pengguna');
                },
                iconData: Icons.supervised_user_circle_outlined,
                drawerItemText: 'Pengguna',
                bgFocusColor: currentRoute == 'pengguna' ? primary : null,
                itemColor:
                    currentRoute == 'pengguna' ? primaryContent : neutral,
              ),
            ),
            DrawerItem(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'profile');
              },
              iconData: Icons.account_circle_outlined,
              drawerItemText: 'Profile',
              bgFocusColor: currentRoute == 'profile' ? primary : null,
              itemColor: currentRoute == 'profile' ? primaryContent : neutral,
            )
          ],
        ),
      ),
    );
  }
}
