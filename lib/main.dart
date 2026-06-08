import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final usuario = await FirebaseAuth.instance.authStateChanges().first;

  final rotaInicial = usuario != null
      ? AppRoutes.home
      : AppRoutes.login;

  runApp(MyApp(rotaInicial: rotaInicial));
}

class MyApp extends StatelessWidget {
  final String rotaInicial;

  const MyApp({super.key, required this.rotaInicial});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoveCity',
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      initialRoute: rotaInicial,
      onGenerateRoute: AppRoutes.onGenerate,
    );
  }
}