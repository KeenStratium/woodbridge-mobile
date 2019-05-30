import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:date_utils/date_utils.dart';

final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

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

Future<List> getAttendanceDays(userId) async {
  String url = '$baseApi/att/get-student-attendance';

  var response = await http.post(url, body: json.encode({
      "data": userId
    }),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    });

  return jsonDecode(response.body);
}

Future<List> getSchoolYearStart(userId) async {
  String url = '$baseApi/att/get-student-attendance';

  var response = await http.post(url, body: json.encode({
    "data": userId
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body);
}


class Attendance extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userId;
  int presentDaysNo = 0;
  double totalSchoolDays = 0;
  int pastSchoolDays = 0;

  int absentDays = 0;

  Attendance({
    this.firstName,
    this.lastName,
    this.userId
  });

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> with TickerProviderStateMixin {
  DateTime _selectedDay;
  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  Map<DateTime, List> _visibleHolidays;
  List _selectedEvents;
  AnimationController _controller;
  List<DateTime> schoolDays = <DateTime>[];
  List<DateTime> presentDays = <DateTime>[];

  void getAttendanceInfo(userId) {
    Future.wait([
      getPresentDaysNo(userId)
        .then((result) {
          setState(() {
            widget.presentDaysNo = result['presentDays'];
            widget.absentDays = widget.pastSchoolDays - widget.presentDaysNo;
          });
        }),
      getTotalSchoolDays(userId)
        .then((result) {
          setState(() {
          widget.totalSchoolDays = result['totalDays'];
          });
        }),
      getAbsentDays(userId)
        .then((result) {
          setState(() {
            widget.pastSchoolDays = result['totalDaysNow'];
            widget.absentDays = widget.pastSchoolDays - widget.presentDaysNo;
          });
        }),
      getAttendanceDays(userId)
        .then((results) {
          results.forEach((result) {
            DateTime attendanceDate = DateTime.parse(result['attendance_date']);
            DateTime attendanceDay = DateTime.utc(attendanceDate.year, attendanceDate.month, attendanceDate.day);
            presentDays.add(attendanceDay);
          });
        })
    ]).then((results) {
      DateTime schoolYearStarts = DateTime.utc(2019, 1, 1);
      DateTime SchoolYearEnd = DateTime.utc(2019, 3, 1); // TODO: Continue here
      for(int i = widget.totalSchoolDays.floor(); i > 0 ; i--){
        print(i);
      }
    });
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      _visibleEvents = Map.fromEntries(
        _events.entries.where(
              (entry) =>
          entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );

      _visibleHolidays = Map.fromEntries(
        _holidays.entries.where(
              (entry) =>
          entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );
    });
  }

  @override
  void initState(){
    super.initState();

    _selectedDay = DateTime.now();
    _events = {
      _selectedDay.subtract(Duration(days: 30)): ['PRESENT'],
      _selectedDay.subtract(Duration(days: 29)): ['PRESENT'],
      _selectedDay.subtract(Duration(days: 28)): ['PRESENT'],
      _selectedDay.subtract(Duration(days: 27)): ['PRESENT'],
      _selectedDay.subtract(Duration(days: 26)): ['PRESENT'],
      _selectedDay.subtract(Duration(days: 23)): ['PRESENT'],
      _selectedDay.subtract(Duration(days: 22)): ['PRESENT'],
      _selectedDay.subtract(Duration(days: 21)): ['PRESENT'],
      _selectedDay.subtract(Duration(days: 20)): ['PRESENT'],
      _selectedDay.subtract(Duration(days: 19)): ['PRESENT'],
      _selectedDay.subtract(Duration(days: 15)): ['PRESENT'],
      _selectedDay.subtract(Duration(days: 14)): ['PRESENT'],
      _selectedDay.subtract(Duration(days: 16)): ['ABSENT'],
      _selectedDay.subtract(Duration(days: 10)): ['ABSENT'],
      _selectedDay.add(Duration(days: 7)): ['PRESENT'],
      _selectedDay.add(Duration(days: 11)): ['PRESENT'],
      _selectedDay.add(Duration(days: 22)): ['ABSENT'],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _visibleEvents = _events;
    _visibleHolidays = _holidays;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller.forward();
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
                                      widget.totalSchoolDays.floor().toString(),
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
                                      widget.absentDays.toString(),
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
                  child: ListView(
                    children: <Widget>[_buildTableCalendarWithBuilders()],
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      events: _visibleEvents,
      holidays: _visibleHolidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
      },
      calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendStyle: TextStyle().copyWith(color: Colors.red[300]),
          holidayStyle: TextStyle().copyWith(color: Colors.red[800]),
          weekdayStyle: TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w600)
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.red[300]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              color: Colors.grey[200],
              width: 100,
              height: 100,
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle().copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.redAccent
                )
            ),
            width: 100,
            height: 100,
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87
                ),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned.fill(
                top: 0,
                left: 0,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned.fill(
                top: 0,
                left: 0,
                child: _buildHolidaysMarker(date),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _controller.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    Color bgColor;
    Color fontColor = Colors.white;

    if(Utils.isSameDay(date, _selectedDay)){
      if(events[0] == 'PRESENT'){
        bgColor = Colors.green;
        fontColor = Colors.green[100];
      }else if(events[0] == 'ABSENT'){
        bgColor = Colors.red;
      }
    }else if(events[0] == 'PRESENT'){
      bgColor = Colors.green[50];
      fontColor = Colors.green;
    }else if(events[0] == 'ABSENT'){
      bgColor = Colors.red[300];
    }else {
      bgColor =  Utils.isSameDay(date, DateTime.now()) ? Colors.brown[300] : Colors.blue[400];
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: bgColor
      ),
      width: 100.0,
      height: 100.0,
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle().copyWith(
              color: fontColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker(date) {
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.deepPurple
          )
      ),
      width: 100.0,
      height: 100.0,
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle().copyWith(
              color: Colors.black87,
              fontSize: 14.0,
              fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}