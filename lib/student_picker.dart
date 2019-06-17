import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'enroll_package.dart';
import 'home_page.dart';

List<StudentAvatarPicker> studentAvatarPickers = <StudentAvatarPicker>[];

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
    studentAvatarPickers = <StudentAvatarPicker>[];

    studentAvatarPickers.addAll(widget.users.map((userId) {
      return StudentAvatarPicker(
        userId: userId,
        isActive: false,
        onTap: (lname, fname, schoolLevel, classId, gradeLevel, gradeSection) =>
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
              heroTag: userId,
              schoolLevel: schoolLevel,
              classId: classId,
              gradeLevel: gradeLevel,
              gradeSection: gradeSection,
              userIds: users,
            ),
          )),
      );
    }).toList());

    return SafeArea(
      child: Scaffold(
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
                            child: GridView.count(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              childAspectRatio: .9,
                              crossAxisCount: 2,
                              children: studentAvatarPickers
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
                          Route route = MaterialPageRoute(builder: (context) => EnrollPackage());
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
      ),
    );
  }
}