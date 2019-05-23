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

List<Grade> grades = <Grade>[
  Grade(subject: 'Reading Readiness', first: 'MS', second: 'S', third: 'S', fourth: 'S', ave: 'S'),
  Grade(subject: 'Math', first: 'MS', second: 'S', third: 'VS', fourth: 'S', ave: 'MS'),
  Grade(subject: 'Language Arts', first: 'O', second: 'VS', third: 'S', fourth: 'VS', ave: 'MS'),
];

class Grades extends StatelessWidget {
  final String firstName;
  final String lastName;

  Grades({
    this.firstName,
    this.lastName
  });

  @override
  Widget build(BuildContext context) {
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
                firstName: this.firstName,
                lastName: this.lastName,
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
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
                      child: Column(
                        children: grades.map((grade) {
                          return GradeCard(
                            grade: grade,
                          );
                        }).toList(),
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
                      child: Column(
                        children: grades.map((grade) {
                          return GradeCard(
                            grade: grade,
                          );
                        }).toList(),
                      ),
                    )
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

  GradeCard({
    this.grade
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7.0))
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              grade.subject,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18.0,
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
                Container(
                  height: double.infinity,
                  width: 1.0,
                  color: Colors.black12,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                QuarterGrade(
                  label: 'Ave',
                  value: grade.ave,
                )
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
  final String value;

  QuarterGrade({
    this.label,
    this.value
  });

  @override
  Widget build(BuildContext context) {
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
                fontWeight: FontWeight.w700
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
