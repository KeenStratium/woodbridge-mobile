import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'home_page.dart';

class EnrollStudent extends StatefulWidget {
  @override
  _EnrollStudentState createState() => _EnrollStudentState();
}

class _EnrollStudentState extends State<EnrollStudent> {
  String _genderValue = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text('Enroll New Student')
      ),
      bottomNavigationBar: BottomAppBar(
        shape: AutomaticNotchedShape(
          RoundedRectangleBorder(),
          StadiumBorder(side: BorderSide())
        ),
        color: Colors.white,
        notchMargin: 5.0,
        child: Row(
//          mainAxisSize: MainAxisSize.max,
//          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            /*Add the Items here*/
            Container(
              /*Padding changes the height*/
              padding: EdgeInsets.all(6.0),
              child: OutlineButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.cancel,
                  color: Colors.grey[500]
                ),
                label: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)
                ),
              )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context) => HomePage(
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
          ));
          Navigator.push(context, route);
        },
        isExtended: true,
        label: Text('Enroll'),
        elevation: 4.0,
        icon: Icon(Icons.school),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          alignment: AlignmentDirectional.topCenter,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              alignment: AlignmentDirectional.topStart,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: AlignmentDirectional.topStart,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Student's Basic Information",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  Form(
                    autovalidate: true,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              labelText: 'First Name'
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Initial Middle Name',
                                labelText: 'Initial Middle Name'
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              labelText: 'Last Name'
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Gender'
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: _genderValue,
                                    isDense: true,
                                    items: <String>['Male', 'Female', 'Neutral']
                                      .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        );
                                      })
                                      .toList(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _genderValue = newValue;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              labelText: 'First Name'
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Middle Name',
                              labelText: 'Middle Name'
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              labelText: 'Last Name'
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    labelText: 'Gender'
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: _genderValue,
                                    isDense: true,
                                    items: <String>['Male', 'Female', 'Neutral']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    })
                                        .toList(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _genderValue = newValue;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}