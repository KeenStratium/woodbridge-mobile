import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'woodbridge-ui_components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'home_page.dart';
import 'colors.dart';

final ThemeData _woodbridgeTheme = _buildWoodbridgeTheme();

bool isLoggedIn = false;

String fname;
String lname;
String avatarUrl;
String userId;
String schoolLevel;
String classId;
String gradeLevel;
String gradeSection;
List<String> userIds;

void getUserPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String s_fname = prefs.getString('fname');
  String s_lname = prefs.getString('lname');
  String s_avatarUrl = prefs.getString('avatarUrl');;
  String s_userId = prefs.getString('userId');
  String s_schoolLevel = prefs.getString('schoolLevel');
  String s_classId = prefs.getString('classId');
  String s_gradeLevel = prefs.getString('gradeLevel');
  String s_gradeSection = prefs.getString('gradeSection');
  List<String> s_userIds = prefs.getStringList('userIds');

  fname = s_fname;
  lname = s_lname;
  avatarUrl = s_avatarUrl;
  userId = s_userId;
  schoolLevel = s_schoolLevel;
  classId = s_classId;
  gradeLevel = s_gradeLevel;
  gradeSection = s_gradeSection;
  userIds = s_userIds;
}

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

Future<bool> _getLoggedInStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool status = prefs.getBool('isLoggedIn');

  isLoggedIn = status;
  if(isLoggedIn != null){
    if(isLoggedIn){
      getUserPreferences();
    }
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
              return snapshot.data ? homePage : LoginPage();
            }else{
              return Scaffold(
                body: Center(
                  child: Text(
                    'Loading myWoodbridge',
                    textDirection: TextDirection.ltr,
                  ),
                ),
              );
            }
          },
        ),
        debugShowCheckedModeBanner: false,
        theme: _woodbridgeTheme
    );
  }
}