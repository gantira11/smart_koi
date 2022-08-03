import 'package:flutter/material.dart';
import 'package:smart_koi/constant.dart';
import 'package:smart_koi/router/router_generator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(
    const MyApp(),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..toastPosition = EasyLoadingToastPosition.top
    ..textStyle = const TextStyle(fontFamily: 'Rubik')
    ..indicatorSize = 30
    ..indicatorColor = primary
    ..textColor = primary
    ..backgroundColor = neutralContent;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      title: 'Smart Koi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: RouterGenerator.generateRoute,
      builder: EasyLoading.init(),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
