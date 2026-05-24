import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';

class AppRoutes {
  static const home = '/';

  static Route<dynamic>? onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return null;
    }
  }
}
