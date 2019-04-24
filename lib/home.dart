import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          alignment: AlignmentDirectional.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Select Student',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600
                  )
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 48.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FittedBox(
                              child: CircleAvatar(
                                child: Text(
                                  'KI',
                                  style: TextStyle(
                                    fontSize: 32.0,
                                  ),
                                ),
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                maxRadius: 80.0
                              ),
                              fit: BoxFit.contain
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Kion',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            )
                          ],
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        Column(
                          children: <Widget>[
                            FittedBox(
                              child: CircleAvatar(
                                child: Text(
                                  'KF',
                                  style: TextStyle(
                                    fontSize: 32.0,
                                  ),
                                ),
                                backgroundColor: Colors.cyan,
                                foregroundColor: Colors.white,
                                maxRadius: 80.00,
                              ),
                              fit: BoxFit.contain
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Kefir',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        child: Text(
                          'Enroll New Student',
                          style: TextStyle(
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        onPressed: () {

                        },
                        elevation: 3.0,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}