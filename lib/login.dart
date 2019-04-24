import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          alignment: AlignmentDirectional.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
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
                        onPressed: () {},
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
      )
    );
  }
}