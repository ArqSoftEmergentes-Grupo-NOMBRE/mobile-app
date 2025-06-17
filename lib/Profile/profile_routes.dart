import 'package:flutter/material.dart';
import 'views/account_screen.dart';

class ProfileRoutes {
  static const String account = '/account';

  static Map<String, WidgetBuilder> getRoutes() => {
    account: (ctx) => const AccountScreen(),
  };
}
