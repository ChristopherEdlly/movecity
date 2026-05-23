import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'auth/forgot_password_screen.dart';

class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const registration = '/registration';
  static const forgotPassword = '/forgot-password';

  static Route<dynamic>? onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

         // LOGIN
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      // CADASTRO
      case registration:
        return MaterialPageRoute(
          builder: (_) => const RegistrationScreen(),
        );

      // ESQUECEU SENHA
      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );
      default:
        return null;
    }
  }
}
