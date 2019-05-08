import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'enroll_student.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';

class StudentAvatarPicker extends StatelessWidget with WidgetsBindingObserver{
  final String userId;
  String fname;
  String lname;

  StudentAvatarPicker({
     this.userId
  });

  getStudentInfo() async {
    http.Response response = await http.post(Uri.encodeFull('http://54.169.38.97:4200/api/student/get-student'),
      body: json.encode({
        'data': userId
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

    var data = json.decode(response.body)[0];

    this.fname = data['s_fname'];
    this.lname = data['s_lname'];

    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Hero(
          tag: this.userId,
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
                          firstName: 'fname',
                          lastName: 'lname',
                          heroTag: this.userId,
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
              'fname',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            )
        )
      ],
    );
  }
}

class StudentPicker extends StatelessWidget {
  List<String> userIds;

  StudentPicker({
    this.userIds
  });

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
                        StudentAvatarPicker(userId: userIds[0]),
                        SizedBox(width: 40.0),
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