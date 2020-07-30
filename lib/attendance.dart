import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:date_utils/date_utils.dart';

class Attendance extends StatefulWidget {
  Attendance(
      {this.firstName,
      this.lastName,
      this.userId,
      this.schoolDays: const <DateTime>[],
      this.presentDays: const <DateTime>[],
      this.noSchoolDays: const <DateTime>[],
      this.specialSchoolDays: const <DateTime>[],
      this.yearStartDay,
      this.yearEndDay,
      this.presentDaysNo: 0,
      this.pastSchoolDays: 0,
      this.absentDays: 0,
      this.totalSchoolDays: 0});

  final int absentDays;
  final String firstName;
  bool hasInitiated = false;
  Map<DateTime, List> holidayDays = {};
  final String lastName;
  final List<DateTime> noSchoolDays;
  final int pastSchoolDays;
  final List<DateTime> presentDays;
  final int presentDaysNo;
  final List<DateTime> schoolDays;
  final List<DateTime> specialSchoolDays;
  final double totalSchoolDays;
  final String userId;
  final DateTime yearEndDay;
  final DateTime yearStartDay;

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> with TickerProviderStateMixin {
  static DateTime currentDate = DateTime.now();

  DateTime currentDay = DateTime(currentDate.year, currentDate.month, currentDate.day);
  List<Widget> eventsLegend = <Widget>[];
  DateTime today = DateTime.now();

  AnimationController _controller;
  Map<DateTime, List> _events;
  DateTime _selectedDay;
  List _selectedEvents;
  Map<DateTime, List> _visibleEvents;
  Map<DateTime, List> _visibleHolidays;
  DateFormat formatter = DateFormat('MMMM d, yyyy');

  CalendarController _calendarController;

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();

    eventsLegend.addAll([
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: Text(
              'Legend: ',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
      Container(
        margin: EdgeInsets.only(right: 4.0),
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        decoration: BoxDecoration(
            color: Colors.green[50],
            border: Border.all(color: Colors.green[50]),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Text(
          'Present',
          softWrap: false,
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 14.0),
        ),
      ),
      Container(
        margin: EdgeInsets.only(right: 4.0),
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        decoration: BoxDecoration(
            color: Colors.red[300],
            border: Border.all(color: Colors.red[300]),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Text(
          'Absent',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.0),
        ),
      ),
      Container(
        margin: EdgeInsets.only(right: 4.0),
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Text(
          'Holiday',
          softWrap: false,
          style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600, fontSize: 14.0),
        ),
      )
    ]);

    _selectedDay = DateTime.now();
    _selectedDay = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, 0, 0);

    _events = {
      _selectedDay: [],
    };

    try {
      _selectedEvents = [];
      _selectedEvents = _events[_selectedDay] ?? [];
    } catch (e) {
      _selectedEvents = [];
    }

    _visibleEvents = _events;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller.forward();
  }

  Future fetchHolidayList() async {
    String url = '$baseApi/sett/get-holidays';

    var response = await http
        .get(url, headers: {'Accept': 'application/json', 'Content-Type': 'application/json'});

    return jsonDecode(response.body);
  }

  Future getHolidayList() async {
    return await fetchHolidayList().then((resolve) async {
      widget.holidayDays = {};
      for (int i = 0; i < resolve.length; i++) {
        Map holiday = resolve[i];
        String holidayTitle = holiday['title'];
        DateTime startHoliday = DateTime.parse(holiday['holiday_start_date']).toLocal();
        DateTime endHoliday = DateTime.parse(holiday['holiday_end_date']).toLocal();
        DateTime holidayIndexDate = startHoliday;

        for (;
            !(holidayIndexDate.isAtSameMomentAs(endHoliday));
            holidayIndexDate = holidayIndexDate.add(Duration(days: 1))) {
          if (widget.holidayDays[holidayIndexDate] == null) {
            widget.holidayDays[holidayIndexDate] = [];
          }
          widget.holidayDays[holidayIndexDate].add(holidayTitle);
        }

        if (widget.holidayDays[holidayIndexDate] == null) {
          widget.holidayDays[holidayIndexDate] = [];
        }
        widget.holidayDays[holidayIndexDate].add(holidayTitle);
      }

      return Future.value(widget.holidayDays);
    }).then((resolve) {
      buildAttendanceCalendarDays(widget.yearStartDay,
          DateTime(today.year, today.month, today.day).add(Duration(days: 1)), widget.presentDays);
      return Future.value(resolve);
    });
  }

  Future buildAttendanceCalendarDays(yearStartDay, today, presentDays) {
    DateTime schoolDayIndex = yearStartDay;
    int presentDaysIndex = 0;
    if (yearStartDay != null) {
      while (schoolDayIndex.isBefore(today)) {
        if (widget.holidayDays[schoolDayIndex] == null) {
          if (schoolDayIndex.weekday <= 5) {
            String attendanceStatus = 'ABSENT';

            if (presentDays.length > 0) {
              try {
                if (presentDays[presentDaysIndex].isBefore(schoolDayIndex) &&
                    presentDaysIndex < presentDays.length - 1) {
                  presentDaysIndex++;
                }
              } catch (e) {}
              if (schoolDayIndex == presentDays[presentDaysIndex] &&
                  presentDaysIndex < presentDays.length) {
                attendanceStatus = 'PRESENT';
                if (presentDaysIndex < presentDays.length - 1) {
                  presentDaysIndex++;
                }
              }
            }

            try {
              if (_events[schoolDayIndex].isEmpty) {}
            } catch (e) {
              _events[schoolDayIndex] = [];
            }
            _events[schoolDayIndex].add(attendanceStatus);
          }
        }

        schoolDayIndex = schoolDayIndex.add(Duration(days: 1));
      }
    }

    return Future.value();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = DateTime(day.year, day.month, day.day, 0, 0);
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
        widget.holidayDays.entries.where(
          (entry) =>
              entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );
    });
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
          weekdayStyle: TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w600)),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.red[300]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          if (DateTime(date.year, date.month, date.day) == currentDay) {
            if (!_selectedEvents.contains('CURRENT')) {
              _selectedEvents.add('CURRENT');
            }
          }
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: DateTime(date.year, date.month, date.day) != currentDay
                ? Container(
                    margin: const EdgeInsets.all(4.0),
                    color: Colors.grey[200],
                    width: 100,
                    height: 100,
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                : _buildEventsMarker(_selectedDay, _selectedEvents),
          );
        },
        todayDayBuilder: (context, date, _) {
          return _todayBuilder(date);
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
        List selectedHolidays = widget.holidayDays[_selectedDay];
        List thisEvents = _events[_selectedDay] ?? [''];
        eventsLegend = [];
        DateFormat formatter = DateFormat('MMM. d');
        if (_selectedEvents.length != 0 &&
            thisEvents[0] != '' &&
            (thisEvents.length > 0 && thisEvents[0] != 'CURRENT')) {
          eventsLegend.add(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 4.0, left: 4.0),
                child: Text(
                  '${formatter.format(date)} ',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[600]),
                ),
              ),
            ],
          ));

          for (int i = 0; i < _selectedEvents.length; i++) {
            String event = _selectedEvents[i];

            if (event == 'ABSENT') {
              eventsLegend.add(Container(
                margin: EdgeInsets.only(right: 4.0),
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                decoration: BoxDecoration(
                    color: Colors.red[300],
                    border: Border.all(color: Colors.red[300]),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Text(
                  'Absent',
                  style:
                      TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.0),
                ),
              ));
            }
            if (event == 'PRESENT' || (event == 'CURRENT' && thisEvents[0] == 'PRESENT')) {
              if (event != 'CURRENT') {
                eventsLegend.add(Container(
                  margin: EdgeInsets.only(right: 4.0),
                  padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                      color: Colors.green[50],
                      border: Border.all(color: Colors.green[50]),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Text(
                    'Present',
                    softWrap: false,
                    style:
                        TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 14.0),
                  ),
                ));
              }
            }
          }
        }
        if (selectedHolidays != null) {
          eventsLegend.add(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 4.0, left: 4.0),
                child: Text(
                  '${formatter.format(date)} ',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[600]),
                ),
              ),
            ],
          ));
          for (int i = 0; i < selectedHolidays.length; i++) {
            String holiday = selectedHolidays[i];

            eventsLegend.add(Container(
              margin: EdgeInsets.only(right: 4.0),
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Text(
                holiday,
                softWrap: false,
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w600, fontSize: 14.0),
              ),
            ));
          }
        }

        _controller.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      calendarController: _calendarController,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    DateTime thisDay = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime selectedDay = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, 0, 0);
    Color bgColor;
    Color fontColor = Colors.white;

    if (thisDay == selectedDay) {
      if (events.contains('PRESENT')) {
        bgColor = Colors.green;
        fontColor = Colors.green[100];
      } else if (events.contains('ABSENT')) {
        bgColor = Colors.red;
      } else if (events.contains('CURRENT')) {
        return _todayBuilder(date);
      }
    } else if (events.contains('PRESENT')) {
      bgColor = Colors.green[50];
      fontColor = Colors.green;
    } else if (events.contains('ABSENT')) {
      bgColor = Colors.red[300];
    } else if (events.contains('CURRENT')) {
      return _todayBuilder(date);
    } else {
      bgColor = Utils.isSameDay(date, DateTime.now()) ? Colors.brown[300] : Colors.blue[400];
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(shape: BoxShape.rectangle, color: bgColor),
      width: 100.0,
      height: 100.0,
      child: Center(
        child: Text(
          '${date.day}',
          style:
              TextStyle().copyWith(color: fontColor, fontSize: 14.0, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker(date) {
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.deepPurple)),
      width: 100.0,
      height: 100.0,
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle()
              .copyWith(color: Colors.black87, fontSize: 14.0, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _todayBuilder(DateTime date) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.redAccent)),
      width: 100,
      height: 100,
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle().copyWith(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Attendance'),
        ),
        resizeToAvoidBottomInset: false,
        body: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 0,
              child: Column(
                children: <Widget>[
                  ProfileHeader(
                    firstName: this.widget.firstName,
                    lastName: this.widget.lastName,
                    heroTag: this.widget.userId,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: double.infinity, maxHeight: 90.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BrandTheme.cardShadow],
                            borderRadius: BorderRadius.all(Radius.circular(7.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Flex(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Days Present',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        widget.presentDaysNo.toString(),
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontSize: 32.0,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
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
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'School Days',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        widget.totalSchoolDays.floor().toString(),
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontSize: 32.0,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
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
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Days Absent',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        widget.absentDays.toString(),
                                        style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontSize: 32.0,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
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
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Container(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        height: 30.0,
                        margin:
                            EdgeInsets.only(top: 20.0, left: eventsLegend.length > 0 ? 20.0 : 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            eventsLegend.length > 0
                                ? Expanded(
                                    flex: 1,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: AlwaysScrollableScrollPhysics(),
                                        itemCount: eventsLegend.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return eventsLegend[index];
                                        }),
                                  )
                                : Text(
                                    formatter.format(_selectedDay),
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[600]),
                                  ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: !widget.hasInitiated
                            ? getHolidayList()
                            : Future.value(_visibleHolidays),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if ((snapshot.connectionState == ConnectionState.done) ||
                              widget.hasInitiated) {
                            widget.hasInitiated = true;
                            _visibleHolidays = snapshot.data;
                            return _buildTableCalendarWithBuilders();
                          } else {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 64.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
