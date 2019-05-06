import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'enroll_student.dart';
import 'home_page.dart';

class StudentPicker extends StatelessWidget {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Hero(
                              tag: 'kion',
                              child: FittedBox(
                                child: Material(
                                  child: InkWell(
                                    onTap: () =>
                                      Navigator.of(context).push(new MaterialPageRoute(
                                        builder: (BuildContext context) => new HomePage(
                                          child: Avatar(
                                            backgroundColor: Colors.indigo,
                                            maxRadius: 48.0,
                                            minRadius: 24.0,
                                            initial: 'KI',
                                            fontSize: 24.0,
                                          ),
                                          firstName: 'Kion Kefir',
                                          lastName: 'Gargar',
                                          heroTag: 'kion',
                                        ),
                                      )),
                                      child: Avatar(
                                        backgroundColor: Colors.indigo,
                                        maxRadius: 80.0,
                                        initial: 'KI',
                                        fontSize: 32.0,
                                      ),
                                  ),
                                ),
                                fit: BoxFit.contain
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Gargar, \nKion Kefir',
                                textAlign: TextAlign.center,
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
                            Hero(
                              tag: 'keanu',
                              child: FittedBox(
                                  child: Material(
                                    child: InkWell(
                                      onTap: () =>
                                          Navigator.of(context).push(new MaterialPageRoute(
                                            builder: (BuildContext context) => new HomePage(
                                              child: Avatar(
                                                backgroundColor: Colors.cyan,
                                                maxRadius: 48.0,
                                                minRadius: 24.0,
                                                initial: 'KE',
                                                fontSize: 24.0,
                                              ),
                                              firstName: 'Keanu Kent',
                                              lastName: 'Gargar',
                                              heroTag: 'keanu',
                                            ),
                                          )),
                                      child: Avatar(
                                        backgroundColor: Colors.cyan,
                                        maxRadius: 80.0,
                                        initial: 'KE',
                                        fontSize: 32.0,
                                      ),
                                    ),
                                  ),
                                  fit: BoxFit.contain
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 16.0),
                                child: Text(
                                  'Gargar, \nKeanu Kent',
                                  textAlign: TextAlign.center,
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
                          Route route = MaterialPageRoute(builder: (context) => EnrollStudent());
                          Navigator.push(context, route);
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