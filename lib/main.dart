import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'auth/forgot_password_screen.dart';
import 'package:movecity/app_routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(),
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.onGenerate,
    );
  }
}