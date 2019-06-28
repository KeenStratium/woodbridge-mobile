import 'dart:async';
import 'dart:convert';
import 'colors.dart';
import 'model.dart';

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_picker.dart';
import 'change-password.dart';

import 'woodbridge-ui_components.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  PDFDocument doc;
  List<Widget> guidePages = <Widget>[];

  void fetchPdf() async {
    await initLoadPdf();
  }

  Future initLoadPdf() async {
    doc = await PDFDocument.fromAsset('files/TWAMobileParentsGuide.pdf');
    int maxPages = doc.count;

    for(int i = 0; i < maxPages; i++){
      guidePages.add(await doc.get(page: i+1));
    }

    return guidePages;
  }

  Future<Map> getData() async {
    print(_userController.text);
    print(_passwordController.text);
    http.Response response = await http.post(Uri.encodeFull('$baseApi/account/login'),
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
    Map loginStatus = {
      'status': 'invalid',
      'ids': []
    };

    try {
      var userData = await data[0];
      List<String> userIds = <String>[];

      if(_passwordController.text == 'woodbridge'){ // TODO: Refactor this along with server to have a unified source of initial password
        userIds.add('initial');
        loginStatus['status'] = 'initial';
      }else{
        loginStatus['status'] = 'auth';
      }

      setUsername('Johnny');
      loginStatus['ids'] = userData["student_id"].split(',');

      return loginStatus;
    } catch(e) {
      print(e);
      print('Invalid credentials');
    }

    return loginStatus;
  }

  @override initState() {
    super.initState();

//    _userController.text = 'Johnny';
//    _passwordController.text = 'woodbridge';

    fetchPdf();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
                                    labelText: 'Username',
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
                                if(data['status'] == 'auth'){
                                  Route route = MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return StudentPicker(users: data['ids']);
                                    });
                                  Navigator.push(context, route);
                                }else if(data['status'] == 'initial'){
                                  print(data['status']);
                                  Route route = MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return ChangePassword();
//                                        return InitialOnboard(
//                                          pages: guidePages,
//                                          userIds: data['ids'],
//                                          showAgreementCta: true,
//                                        );
                                      });
                                  Navigator.push(context, route);
                                } else{
                                  print('Please try again.');
                                }
                              });
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}