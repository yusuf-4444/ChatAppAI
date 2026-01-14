import 'package:chat_app_ai/pages/home_page.dart';
import 'package:chat_app_ai/utils/router/app_routes.dart';
import 'package:flutter/cupertino.dart';

class AppRouter {
  static Route<dynamic> onGenerateRouter(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.chat:
        return CupertinoPageRoute(builder: (context) => const HomePage());
      default:
        return CupertinoPageRoute(builder: (context) => const HomePage());
    }
  }
}
