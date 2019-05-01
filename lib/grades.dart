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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grades'),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              ProfileHeader(
                profileName: 'Kion Kefir C. Gargar',
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                          label: Flexible(
                            child: Text(
                              'Subjects',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          numeric: false,
                          onSort: (i, j){},
                          tooltip: 'Subjects'
                      ),
                      DataColumn(
                          label: Text('1st'),
                          numeric: false,
                          onSort: (i, j){},
                          tooltip: '1st Quarter'
                      ),
                      DataColumn(
                          label: Text('2nd'),
                          numeric: false,
                          onSort: (i, j){},
                          tooltip: '2nd Quarter'
                      ),
                      DataColumn(
                          label: Text('3rd'),
                          numeric: false,
                          onSort: (i, j){},
                          tooltip: '3rd Quarter'
                      ),
                      DataColumn(
                          label: Text('4th'),
                          numeric: false,
                          onSort: (i, j){},
                          tooltip: '4th Quarter'
                      ),
                      DataColumn(
                          label: Text('Ave'),
                          numeric: false,
                          onSort: (i, j){},
                          tooltip: 'Average grade'
                      )
                    ],
                    rows: grades.map((grade) => DataRow(
                        cells: [
                          DataCell(
                            Text(grade.subject),
                          ),
                          DataCell(
                            Text(grade.first),
                          ),
                          DataCell(
                            Text(grade.second),
                          ),
                          DataCell(
                            Text(grade.third),
                          ),
                          DataCell(
                            Text(grade.fourth),
                          ),
                          DataCell(
                            Text(grade.ave),
                          )
                        ]
                    )).toList(),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

