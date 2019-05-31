import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

class Grade {
  String subject;
  String first;
  String second;
  String third;
  String fourth;
  String ave;

  Grade({this.subject, this.first, this.second, this.third, this.fourth, this.ave});
}

class Areas {
  String number;
  String location;
}


Future<List> fetchGrades(userId) async {
  String url = '$baseApi/grade/get-grades';

  var response = await http.post(url, body: json.encode({
    'data': userId
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body);
}

Future<List> fetchPsychSkills(userId, schoolLevel) async {
  String url = '$baseApi/grade/get-skills-mobile';

  var response = await http.post(url, body: json.encode({
    'data': {
      's_id': userId,
      'school_level': schoolLevel
    }
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body);
}

class Grades extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userId;
  final String schoolLevel;

  Grades({
    this.firstName,
    this.lastName,
    this.userId,
    this.schoolLevel
  });

  @override
  _GradesState createState() => _GradesState();
}

class _GradesState extends State<Grades> {
  @override
  Widget build(BuildContext context) {

    Future buildGrades(userId) async {
      List<Widget> gradeWidgets = <Widget>[];

      await fetchGrades(userId)
        .then((result) {
          List resultGrades = result;
          for(var i = 0; i < resultGrades.length; i++){
            Map subject = resultGrades[i];

            gradeWidgets.add(GradeCard(
              grade: Grade(
                subject: subject['subjects'],
                first: subject['first'],
                second: subject['second'],
                third: subject['third'],
                fourth: subject['fourth'],
                ave: subject['ave']
              ),
            ));
          }
        });

      return gradeWidgets;
    }

    Future buildPsychSkills(userId, schoolLevel) async {
      List<Widget> skillWidgets = <Widget>[];

      await fetchPsychSkills(userId, schoolLevel)
        .then((result) {
          List resultGrades = result;

          for(var i = 0; i < resultGrades.length; i++){
            Map subject = resultGrades[i];

            skillWidgets.add(GradeCard(
              includeAve: false,
              grade: Grade(
                subject: subject['skill_desc'],
                first: subject['first'],
                second: subject['second'],
                third: subject['third'],
              ),
            ));
          }
        });

      return skillWidgets;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Grades'),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              ProfileHeader(
                firstName: this.widget.firstName,
                lastName: this.widget.lastName,
                heroTag: this.widget.userId,
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'Subjects',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: FutureBuilder(
                        future: buildGrades(widget.userId),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if(snapshot.connectionState == ConnectionState.done){
                            return Column(
                              children: snapshot.data
                            );
                          }else{
                            return Text('fetching grade information...');
                          }
                        },
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'Psychological Skills',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: FutureBuilder(
                        future: buildPsychSkills(widget.userId, widget.schoolLevel),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if(snapshot.connectionState == ConnectionState.done){
                            return Column(
                                children: snapshot.data
                            );
                          }else{
                            return Text('fetching grade information...');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

class GradeCard extends StatelessWidget {
  final Grade grade;
  bool includeAve = true;

  GradeCard({
    this.grade,
    this.includeAve
  });

  @override
  Widget build(BuildContext context) {

    if(includeAve == null){
      includeAve = true;
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7.0))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            child: Text(
              grade.subject,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16.0,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          Container(
            height: 54.0,
            margin: EdgeInsets.symmetric(vertical: 12.0),
            padding: EdgeInsets.symmetric(horizontal: 6.0),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                QuarterGrade(
                  label: '1st',
                  value: grade.first,
                ),
                Container(
                  height: double.infinity,
                  width: 1.0,
                  color: Colors.black12,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                QuarterGrade(
                  label: '2nd',
                  value: grade.second,
                ),
                Container(
                  height: double.infinity,
                  width: 1.0,
                  color: Colors.black12,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                QuarterGrade(
                  label: '3rd',
                  value: grade.third,
                ),
                Container(
                  height: double.infinity,
                  width: 1.0,
                  color: Colors.black12,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                QuarterGrade(
                  label: '4th',
                  value: grade.fourth,
                ),
                includeAve ? Container(
                  height: double.infinity,
                  width: 1.0,
                  color: Colors.black12,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                ) : Container(),
                includeAve ? QuarterGrade(
                  label: 'Ave',
                  value: grade.ave,
                ) : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuarterGrade extends StatelessWidget {
  final String label;
  String value;

  QuarterGrade({
    this.label,
    this.value
  });

  @override
  Widget build(BuildContext context) {
    if(value != null){
      value = value.toUpperCase();
    }
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.0),
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500
              ),
            ),
            Text(
              value ?? '-',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: value == null ? Colors.black54 : Theme.of(context).accentColor
              ),
            )
          ],
        ),
      ),
    );
  }
}
