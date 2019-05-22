import 'package:flutter/material.dart';

import 'login.dart';
import 'colors.dart';

final ThemeData _woodbridgeTheme = _buildWoodbridgeTheme();

ThemeData _buildWoodbridgeTheme() {
  return ThemeData(
    fontFamily: 'Muli',
    accentColor: blue,
  );
}

class WoodbridgeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Woodbridge',
      home: LoginPage(),
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
      theme: _woodbridgeTheme
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if(settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true
    );
  }
}

