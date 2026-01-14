import 'package:chat_app_ai/core/utils/router/app_routes.dart';
import 'package:chat_app_ai/features/auth/views/pages/login_page.dart';
import 'package:chat_app_ai/features/auth/views/pages/register_page.dart';
import 'package:chat_app_ai/features/home/views/pages/home_page.dart';
import 'package:flutter/cupertino.dart';

class AppRouter {
  static Route<dynamic> onGenerateRouter(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return CupertinoPageRoute(builder: (context) => const LoginPage());
      case AppRoutes.register:
        return CupertinoPageRoute(builder: (context) => const RegisterPage());
      case AppRoutes.chat:
        return CupertinoPageRoute(builder: (context) => const HomePage());
      default:
        return CupertinoPageRoute(builder: (context) => const LoginPage());
    }
  }
}
