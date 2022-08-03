import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_koi/screens/home_screen.dart';
import 'package:smart_koi/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    if (token != null) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedSplashScreen(
      splash: Center(
        child: Image.asset(
          'assets/images/smartkoi.png',
          width: size.width * 0.5,
          fit: BoxFit.contain,
        ),
      ),
      nextScreen: isLoggedIn ? const HomeScreen() : const LoginScreen(),
      nextRoute: isLoggedIn ? 'home' : 'login',
      splashIconSize: double.maxFinite,
    );
  }
}
