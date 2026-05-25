import 'package:flutter/material.dart';
import '../../app_routes.dart';

class BarraNavegacao extends StatelessWidget {
  final int indiceSelecionado;

  const BarraNavegacao({super.key, required this.indiceSelecionado});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: indiceSelecionado,
      onTap: (index) => _navegarPara(context, index),
      selectedItemColor: const Color(0xFF1D9E75),
      unselectedItemColor: Colors.grey,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Início'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Registrar'),
        BottomNavigationBarItem(icon: Icon(Icons.list_outlined), label: 'Rotas'),
        BottomNavigationBarItem(icon: Icon(Icons.history_outlined), label: 'Histórico'),
      ],
    );
  }

  void _navegarPara(BuildContext context, int index) {
    if (index == indiceSelecionado) return;
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
      case 1:
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.registrar, (_) => false);
      case 2:
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.minhasRotas, (_) => false);
      case 3:
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.historico, (_) => false);
    }
  }
}
