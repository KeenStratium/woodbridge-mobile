import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'enroll_student.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';

class StudentAvatarPicker extends StatefulWidget{
  final userId;

  StudentAvatarPicker({
    Key key,
    this.userId,
  }) : super(key: key);

  @override
  _StudentAvatarPickerState createState() => _StudentAvatarPickerState();
}

class _StudentAvatarPickerState extends State<StudentAvatarPicker> {
  String fname;
  String lname;

  void getStudent(userId) async {
    await _getStudentInfo(userId)
        .then((data) {
      setState(() {
        fname = data['s_fname'];
        lname = data['s_lname'];
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getStudent(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Hero(
          tag: widget.userId,
          child: FittedBox(
              child: Material(
                child: InkWell(
                  onTap: () =>
                      Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => HomePage(
                          child: Avatar(
                            backgroundColor: Colors.indigo,
                            maxRadius: 48.0,
                            minRadius: 24.0,
                            fontSize: 24.0,
                            initial: "${fname != null ? fname[0] : ''}${lname != null ? lname[0] : ''}"
                          ),
                          firstName: fname ?? '',
                          lastName: lname ?? '',
                          heroTag: widget.userId,
                        ),
                      )),
                  child: Avatar(
                    backgroundColor: Colors.indigo,
                    maxRadius: 80.0,
                    fontSize: 32.0,
                    initial: "${fname != null ? fname[0] : ''}${lname != null ? lname[0] : ''}",
                  ),
                ),
              ),
              fit: BoxFit.contain
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 16.0),
            child: Text(
              '${fname ?? ''} ${lname ?? ''}',
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

Future<Map> _getStudentInfo(userId) async {
  String url = 'http://54.169.38.97:4200/api/student/get-student';

  var response = await http.post(url, body: json.encode({
    'data': userId
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });
  return jsonDecode(response.body)[0];
}

class StudentPicker extends StatefulWidget {
 var userIds = 'S-1557210835494';
 List users;

  StudentPicker({
    Key key,
    @required this.users
  }) : super(key: key);

  @override
  _StudentPickerState createState() => _StudentPickerState();
}

class _StudentPickerState extends State<StudentPicker> {
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
                        StudentAvatarPicker(userId: widget.users[0]),
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