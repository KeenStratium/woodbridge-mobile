import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';
import 'dart:io';

import 'woodbridge-ui_components.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Update Password'),
      ),
      body: ChangePasswordPage()
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SingleChildScrollView(
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Flexible(
                  flex: 0,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 248, 225, 1),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border.all(
                            color: Colors.amber[300]
                        )
                    ),
                    child: Text(
                      'To activate your account, update to a new password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 0, 0, .6)
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: SizedBox(
                    width: 300.0,
                    child: Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                autofocus: true,
                                controller: _passwordController,
                                validator: (value) {
                                  if(value.isEmpty) {
                                    return 'Enter a password';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  filled: false,
                                  labelText: 'New Password',
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: _passwordAgainController,
                                validator: (value) {
                                  if(value.isEmpty) {
                                    return 'Enter password again';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  filled: false,
                                  labelText: 'Re-type password',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: accentCtaButton(
              label: 'Update password',
              onPressed: (() {
                final errorSnackBar = SnackBar(
                  content: Text(
                    'Password does not match. Please try again.',
                    style: TextStyle(
                      color: Colors.amberAccent
                    ),
                  ),
                  action: SnackBarAction(
                    label: 'Okay',
                    textColor: Colors.white,
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                final processingSnackBar = SnackBar(
                  content: Text(
                    'Updating your password...',
                    style: TextStyle(
                        color: Colors.blue[200]
                    ),
                  ),
                );
                final successSnackBar = SnackBar(
                  content: Text(
                    'Successfully updated your password!',
                    style: TextStyle(
                      color: Colors.greenAccent,
                    ),
                  ),
                  action: SnackBarAction(
                    label: 'Okay',
                    textColor: Colors.white,
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );

                if (_formKey.currentState.validate()) {
                  if(_passwordController.text == _passwordAgainController.text){
                    Scaffold.of(context).showSnackBar(processingSnackBar);
                    Scaffold.of(context).showSnackBar(successSnackBar);
                  }else{
                    Scaffold.of(context).showSnackBar(errorSnackBar);
                  }
                }

                return null;
              }),
            ),
          )
        ],
      ),
    );
  }
}