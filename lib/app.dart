import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'woodbridge-ui_components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'home_page.dart';
import 'colors.dart';

final ThemeData _woodbridgeTheme = _buildWoodbridgeTheme();

bool isLoggedIn = false;

String fname = 'Keanu';
String lname = 'Gargar';
String avatarUrl = null;
String userId = 'GARGAR-2019-984';
String schoolLevel = 'cet';
String classId = 'CET-56389742-2019';
String gradeLevel = 'cet';
String gradeSection = 'Comp. Eng.';
List<String> userIds = ['GARGAR-2019-984'];

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

Widget homePage = HomePage(
  child: Avatar(
    backgroundColor: Colors.indigo,
    maxRadius: 40.0,
    minRadius: 20.0,
    fontSize: 20.0,
    initial: "${fname != null ? fname[0] : ''}${lname != null ? lname[0] : ''}",
    avatarUrl: avatarUrl,
  ),
  firstName: fname ?? '',
  lastName: lname ?? '',
  heroTag: userId,
  schoolLevel: schoolLevel,
  classId: classId,
  gradeLevel: gradeLevel,
  gradeSection: gradeSection,
  userIds: userIds,
  avatarUrl: avatarUrl,
);

_setLoggedInStatus(bool status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print('settings status');
  print(status);
  await prefs.setBool('isLoggedIn', status);
}

Future<bool> _getLoggedInStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool status = prefs.getBool('isLoggedIn');

  isLoggedIn = status;
  if(isLoggedIn != null){
    return status;
  }else {
    return false;
  }
}

class WoodbridgeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.black, // Color for Android
      statusBarBrightness: Brightness.light // Dark == white status bar -- for IOS.
    ));
    return MaterialApp(
        title: 'myWoodbridge',
        home:  FutureBuilder(
          future: _getLoggedInStatus(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              print('status');
              print(snapshot.data);
              return snapshot.data ? homePage : LoginPage();
            }else{
              return Scaffold(
                body: Text(
                  'Loading myWoodbridge',
                  textDirection: TextDirection.ltr,
                ),
              );
            }
          },
        ),
        debugShowCheckedModeBanner: false,
        theme: _woodbridgeTheme
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if(settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => isLoggedIn ? homePage : LoginPage(),
      fullscreenDialog: true
    );
  }
}