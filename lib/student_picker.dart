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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
        boxShadow: [BrandTheme.cardShadow]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                              maxRadius: 40.0,
                              minRadius: 20.0,
                              fontSize: 20.0,
                              initial: "${fname != null ? fname[0] : ''}${lname != null ? lname[0] : ''}"
                            ),
                            firstName: fname ?? '',
                            lastName: lname ?? '',
                            heroTag: widget.userId,
                          ),
                        )),
                    child: Avatar(
                      backgroundColor: Colors.indigo,
                      maxRadius: 48.0,
                      fontSize: 24.0,
                      initial: "${fname != null ? fname[0] : ''}${lname != null ? lname[0] : ''}",
                    ),
                  ),
                ),
                fit: BoxFit.contain
            ),
          ),
          Container(
            width: 128.0,
            margin: EdgeInsets.only(top: 16.0),
            child: Text(
              '${fname ?? ''}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            )
          )
        ],
      ),
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 33.0),
          alignment: AlignmentDirectional.center,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: SingleChildScrollView(
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Flexible(
                        flex: 0,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            'Select Student',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600
                            )
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 0,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: 360.00
                          ),
                          child: Container(
                            child: GridView.count(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: false,
                                childAspectRatio: .9,
                                crossAxisCount: 2,
                                children: widget.users.map((userId) {
                                  return StudentAvatarPicker(userId: userId);
                                }).toList()
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                child: Container(
                  padding: EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: accentCtaButton(
                      label: 'Enroll New Student',
                      onPressed: () {
                        Route route = MaterialPageRoute(builder: (context) => EnrollStudent());
                        Navigator.push(context, route);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}