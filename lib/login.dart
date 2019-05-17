import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_picker.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<List<String>> _getStudentInfo(String userId) async {
    http.Response response = await http.post(Uri.encodeFull('http://54.169.38.97:4200/api/student/get-student'),
        body: json.encode({
          'data': userId
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        });

    var data = json.decode(response.body)[0];

    return [userId, data['s_fname'], data['s_lname']];
  }

  Future<List> _getStudentsInfo(List<String> userIds) async {
    List<List<String>> users;

    for(var i = 0; i < userIds.length; i++){
      List<String> user = await _getStudentInfo(userIds[i]);

      users[i] = user;
    }

    return users;
  }

  Future<List> getData() async {
    http.Response response = await http.post(Uri.encodeFull('http://54.169.38.97:4200/api/account/login'),
      body: json.encode({
        'data': {
          'uname': _userController.text,
          'pass': _passwordController.text
        }
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

    var data = await json.decode(response.body);

    try {
      var userData = await data[0];

      if(userData['user_id'].runtimeType == String){
        return [userData['user_id']];
      }else{
        return userData['user_id'];
      }
    } catch(e) {
      print('Invalid credentials');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          alignment: AlignmentDirectional.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        autofocus: true,
                        controller: _userController,
                        decoration: InputDecoration(
                          filled: false,
                          labelText: 'Login',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))
                          )
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            filled: false,
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            )
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontWeight: FontWeight.w700
                            ),
                          ),
                          onPressed: () => {
                            getData().then((data) {
                              Route route = MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return StudentPicker(users: data);
                                  });
                              Navigator.push(context, route);
                            })
                          },
                          elevation: 3.0,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                child: Text('Login with FB'),
                                onPressed: () {},
                                elevation: 0.0,
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                highlightElevation: 0.0,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                child: Text('Login with Google'),
                                onPressed: () {},
                                elevation: 0.0,
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                highlightElevation: 0.0,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}