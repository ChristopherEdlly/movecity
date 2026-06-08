import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'features/rotas/minhas_rotas_screen.dart';
import 'features/historico/historico_screen.dart';
import 'features/perfil/perfil_screen.dart';
import 'features/displacement/select_route_screen.dart';
import 'features/displacement/start_trip_screen.dart';
import 'features/displacement/in_transit_screen.dart';
import 'features/displacement/displacement_flow_args.dart';
import 'core/mock/banco_mock.dart';
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
  static const perfil = '/perfil';

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
        final rota = settings.arguments;
        if (rota is Rota) {
          return MaterialPageRoute(builder: (_) => StartTripScreen(rota: rota));
        }
        return MaterialPageRoute(builder: (_) => const SelectRouteScreen());

      case emTransito:
        final args = settings.arguments;
        if (args is EmTransitoArgs) {
          return MaterialPageRoute(
            builder: (_) => InTransitScreen(
              rota: args.rota,
              deslocamento: args.deslocamento,
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => const SelectRouteScreen());

      case perfil:
        return MaterialPageRoute(builder: (_) => const PerfilScreen());

      default:
        return null;
    }
  }
}
