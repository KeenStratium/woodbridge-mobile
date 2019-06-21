import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login.dart';
import 'colors.dart';

final ThemeData _woodbridgeTheme = _buildWoodbridgeTheme();

ThemeData _buildWoodbridgeTheme() {
  return ThemeData(
    fontFamily: 'Muli',
    accentColor: blue,
    backgroundColor: Color.fromRGBO(246, 246, 246, 1),
    scaffoldBackgroundColor: Color.fromRGBO(245, 244, 245, 1),
    appBarTheme: AppBarTheme(
      color: blue
    )
  );
}

class WoodbridgeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
    ));

    return MaterialApp(
      title: 'Woodbridge',
      debugShowCheckedModeBanner: false,
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