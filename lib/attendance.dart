import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;

class Attendance extends StatelessWidget {
  final String firstName;
  final String lastName;

  Attendance({
    this.firstName,
    this.lastName,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attendance'),
        ),
        resizeToAvoidBottomInset: false,
        body: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            ProfileHeader(
              firstName: this.firstName,
              lastName: this.lastName,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DashboardTile(
                          label: 'QUARTER',
                          displayPlainValue: false,
                          child: DropdownButton<String>(
                              value: '1st quarter',
                              onChanged: (String newValue) {},
                              items: <String>['1st quarter', '2nd quarter', '3rd quarter', '4th quarter']
                                .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value)
                                  );
                                }).toList(),
                          ),
                        ),
                        DashboardTile(
                          label: 'DAYS PRESENT',
                          displayPlainValue: true,
                          value: '38',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DashboardTile(
                          label: 'SCHOOL DAYS',
                          displayPlainValue: true,
                          value: '44',
                        ),
                        DashboardTile(
                          label: 'DAYS ABSENT',
                          displayPlainValue: true,
                          value: '6',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: CalendarCarousel(
                  weekdayTextStyle: TextStyle(
                    color: Colors.grey[600]
                  ),
                  weekendTextStyle: TextStyle(
                    color: Colors.redAccent
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}