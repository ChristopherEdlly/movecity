import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'features/rotas/minhas_rotas_screen.dart';
import 'features/historico/historico_screen.dart';
import 'features/displacement/select_route_screen.dart';
import 'features/displacement/start_trip_screen.dart';
import 'features/displacement/in_transit_screen.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'auth/forgot_password_screen.dart';

class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const registration = '/registration';
  static const forgotPassword = '/forgot-password';
  static const minhasRotas = '/rotas';
  static const historico = '/historico';
  static const registrar = '/registrar';
  static const iniciarDeslocamento = '/iniciar-deslocamento';
  static const emTransito = '/em-transito';

  static Route<dynamic>? onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case registration:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());

      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case minhasRotas:
        return MaterialPageRoute(builder: (_) => const MinhasRotasScreen());

      case historico:
        return MaterialPageRoute(builder: (_) => const HistoricoScreen());

      case registrar:
        return MaterialPageRoute(builder: (_) => const SelectRouteScreen());

      case iniciarDeslocamento:
        return MaterialPageRoute(builder: (_) => const StartTripScreen());

      case emTransito:
        return MaterialPageRoute(builder: (_) => const InTransitScreen());

      default:
        return null;
    }
  }
}
