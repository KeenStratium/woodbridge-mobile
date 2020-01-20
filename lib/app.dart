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
String firstInitial;
String lastInitial;
List<String> userIds;

void getUserPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String sFname = prefs.getString('fname');
  String sLname = prefs.getString('lname');
  String sAvatarUrl = prefs.getString('avatarUrl');;
  String sUserId = prefs.getString('userId');
  String sSchoolLevel = prefs.getString('schoolLevel');
  String sClassId = prefs.getString('classId');
  String sGradeLevel = prefs.getString('gradeLevel');
  String sGradeSection = prefs.getString('gradeSection');
  List<String> sUserIds = prefs.getStringList('userIds');

  fname = sFname;
  lname = sLname;
  avatarUrl = sAvatarUrl;
  userId = sUserId;
  schoolLevel = sSchoolLevel;
  classId = sClassId;
  gradeLevel = sGradeLevel;
  gradeSection = sGradeSection;
  userIds = sUserIds;

  try {
    firstInitial = fname[0];
    lastInitial = lname[0];
  } catch(e) {
    firstInitial = '';
    lastInitial = '';
  }

}

ThemeData _buildWoodbridgeTheme() {
  return ThemeData(
    fontFamily: 'Roboto',
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
    initial: "$firstInitial$lastInitial",
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
              return snapshot.data ? homePage ?? Scaffold(
                body: Center(
                  child: Text(
                    'Loading myWoodbridge',
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ) : LoginPage();
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