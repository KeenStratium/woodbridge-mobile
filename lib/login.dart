import 'dart:async';
import 'dart:convert';
import 'colors.dart';

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_picker.dart';

import 'woodbridge-ui_components.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<List> getData() async {
//    http.Response response = await http.post(Uri.encodeFull('http://54.169.38.97:4200/api/account/login'),
//      body: json.encode({
//        'data': {
//          'uname': _userController.text,
//          'pass': _passwordController.text
//        }
//      }),
//      headers: {
//        'Accept': 'application/json',
//        'Content-Type': 'application/json'
//      });
//
//    var data = await json.decode(response.body);
//
//    try {
//      var userData = await data[0];
//
//      if(userData['user_id'].runtimeType == String){
//        print('is string');
//        return ['S-1557211347790', 'S-1558317961029', 'S-1558418591682'];
//      }else{
//        print('not string');
//        return userData['user_id'];
//      }
//    } catch(e) {
//      print(e);
//      print('Invalid credentials');
//    }

    return ['S-1557211347790', 'S-1558317961029', 'S-1558418591682', 'S-1558680062880', 'S-1558590912317', 'S-1557903052999', 'S-1557210541856'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("img/background-img.png"),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
          child: Container(
            alignment: AlignmentDirectional.center,
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: FittedBox(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 12.0),
                      width: 128.0,
                      height: 128.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("img/woodbridge_logo.png"),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 28.0, vertical: 14.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    boxShadow: [BrandTheme.cardShadow]
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                autofocus: true,
                                controller: _userController,
                                decoration: InputDecoration(
                                  filled: false,
                                  labelText: 'Email/Username',
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  filled: false,
                                  labelText: 'Password',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: accentCtaButton(
                          label: 'Log In',
                          onPressed: (() {
                            getData().then((data) {
                              Route route = MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    print(data);
                                    return StudentPicker(users: data);
                                  });
                              Navigator.push(context, route);
                            });
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    'or',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16.0
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 14.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            CtaButton(
                              label: 'Login with Facebook',
                              color: facebookBlue,
                              onPressed: (() {
                                return null;
                              }),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.0),
                            ),
                            CtaButton(
                              label: 'Login with Google',
                              color: googleRed,
                              onPressed: (() {
                                return null;
                              }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}