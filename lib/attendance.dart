import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;

Future<Map> getPresentDaysNo(userId) async {
  String url = '$baseApi/att/get-present-days-of-student';

  var response = await http.post(url, body: json.encode({
    'data': userId
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body)[0];
}


Future<Map> getTotalSchoolDays(userId) async {
  String url = '$baseApi/att/get-total-school-days';

  var response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body)[0];
}

Future<Map> getAbsentDays(userId) async {
  String url = '$baseApi/att/get-absent-days-of-school?data=$userId';

  var response = await http.get(url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    });

  return jsonDecode(response.body)[0];
}


class Attendance extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userId;
  int presentDaysNo;
  double totalSchoolDays;
  int pastSchoolDays;

  Attendance({
    this.firstName,
    this.lastName,
    this.userId
  });

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {

  void getAttendanceInfo(userId) {

    getPresentDaysNo(userId)
      .then((result) {
        setState(() {
          widget.presentDaysNo = result['presentDays'];
        });
      });

    getTotalSchoolDays(userId)
      .then((result) {
        setState(() {
          widget.totalSchoolDays = result['totalDays'];
        });
      });

    getAbsentDays(userId)
      .then((result) {
        setState(() {
          widget.pastSchoolDays = result['totalDaysNow'];
        });
      });
  }

  @override
  void initState(){
    super.initState();

    getAttendanceInfo(widget.userId);
  }

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Column(
                children: <Widget>[
                  ProfileHeader(
                    firstName: this.widget.firstName,
                    lastName: this.widget.lastName,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: double.infinity,
                          maxHeight: 90.0
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BrandTheme.cardShadow],
                            borderRadius: BorderRadius.all(Radius.circular(7.0))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Flex(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Days Present',
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87
                                      ),
                                    ),
                                    Text(
                                      widget.presentDaysNo.toString(),
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: double.infinity,
                                width: 1.0,
                                color: Colors.black12,
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'School Days',
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87
                                      ),
                                    ),
                                    Text(
                                      widget.totalSchoolDays.ceil().toString(), // TODO: Verify if to use ceil or floor for format
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: double.infinity,
                                width: 1.0,
                                color: Colors.black12,
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Days Absent',
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87
                                      ),
                                    ),
                                    Text(
                                      (widget.pastSchoolDays - widget.presentDaysNo).toString(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                  child: CalendarCarousel(
                    weekdayTextStyle: TextStyle(
                      color: Colors.grey[600]
                    ),
                    weekendTextStyle: TextStyle(
                      color: Colors.redAccent
                    ),
                    daysHaveCircularBorder: false,
                    todayBorderColor: Colors.redAccent,
                    todayButtonColor: Colors.white,
                    todayTextStyle: TextStyle(
                      color: Colors.black87
                    ),
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