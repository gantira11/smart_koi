import 'package:flutter/material.dart';
import 'package:smart_koi/screens/pengguna_detail_screen.dart';
import 'package:smart_koi/screens/pengguna_tambah_screen.dart';
import 'package:smart_koi/screens/pengguna_update_screen.dart';
import 'package:smart_koi/screens/produksi_barchart_screen.dart';
import 'package:smart_koi/screens/produksi_detail_screen.dart';
import 'package:smart_koi/screens/kalkulator_screen.dart';
import 'package:smart_koi/screens/login_screen.dart';
import 'package:smart_koi/screens/home_screen.dart';
import 'package:smart_koi/screens/produksi_screen.dart';
import 'package:smart_koi/screens/pengguna_screen.dart';
import 'package:smart_koi/screens/profile_screen.dart';
import 'package:smart_koi/screens/produksi_tambah_screen.dart';
import 'package:smart_koi/screens/produksi_update_screen.dart';
import 'package:smart_koi/screens/profile_update_screen.dart';
import 'package:smart_koi/screens/splash_screen.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case 'login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case 'home':
        return MaterialPageRoute(
          settings: const RouteSettings(name: 'home'),
          builder: (_) => const HomeScreen(),
        );
      case 'produksi':
        return MaterialPageRoute(
          settings: const RouteSettings(name: "produksi"),
          // builder: (_) => const ProduksiScreen(),
          builder: (_) => const ProduksiScreen(),
        );
      case 'barchart-produksi':
        return MaterialPageRoute(
            builder: (_) => const ProduksiBarchartScreen());
      case 'tambah-produksi':
        return MaterialPageRoute(builder: (_) => const ProduksiTambahScreen());
      case 'detail-produksi':
        final args = settings.arguments as DetailArgument;
        return MaterialPageRoute(
          builder: (_) => ProduksiDetailScreen(
            id: args.id,
          ),
        );
      case 'update-produksi':
        final args = settings.arguments as DetailArgument;
        return MaterialPageRoute(
          builder: (_) => ProduksiUpdateScreen(
            id: args.id,
          ),
        );
      case 'kalkulator-produksi':
        return MaterialPageRoute(
          settings: const RouteSettings(name: "kalkulator-produksi"),
          builder: (_) => const KalkulatorScreen(),
        );
      case 'pengguna':
        return MaterialPageRoute(
          settings: const RouteSettings(name: "pengguna"),
          builder: (_) => const PenggunaScreen(),
        );
      case 'tambah-pengguna':
        return MaterialPageRoute(builder: (_) => const PenggunaTambahScreen());
      case 'detail-pengguna':
        final args = settings.arguments as DetailArgument;
        return MaterialPageRoute(
          builder: (_) => PenggunaDetailScreen(
            id: args.id,
          ),
        );
      case 'update-pengguna':
        final args = settings.arguments as DetailArgument;
        return MaterialPageRoute(
          builder: (_) => PenggunaUpdateScreen(
            id: args.id,
          ),
        );
      case 'profile':
        return MaterialPageRoute(
          settings: const RouteSettings(name: "profile"),
          builder: (_) => const ProfileScreen(),
        );
      case 'update-profile':
        return MaterialPageRoute(
          builder: (_) => ProfileUpdateScreen(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Screen not found'),
          ),
          body: const Center(
            child: Text('Error 404!'),
          ),
        );
      },
    );
  }
}

class DetailArgument {
  final int id;

  DetailArgument(this.id);
}
