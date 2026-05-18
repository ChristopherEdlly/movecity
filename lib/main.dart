import 'package:flutter/material.dart';
import 'historico.dart';

void main() {
  runApp(const MoveCity());
}

class MoveCity extends StatelessWidget {
  const MoveCity({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoveCity',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HistoricoPage(),
    );
  }
}

