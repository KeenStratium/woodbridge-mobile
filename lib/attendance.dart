import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:date_utils/date_utils.dart';

Future fetchHolidayList() async {
  String url = '$baseApi/sett/get-holidays';

  var response = await http.get(url,
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
  List<DateTime> schoolDays = <DateTime>[];
  List<DateTime> presentDays = <DateTime>[];
  List<DateTime> noSchoolDays = <DateTime>[];
  List<DateTime> specialSchoolDays = <DateTime>[];
  DateTime yearStartDay;
  DateTime yearEndDay;
  int presentDaysNo = 0;
  int pastSchoolDays = 0;
  int absentDays = 0;
  double totalSchoolDays = 0;

  Attendance({
    this.firstName,
    this.lastName,
    this.userId,
    this.schoolDays,
    this.presentDays,
    this.noSchoolDays,
    this.specialSchoolDays,
    this.yearStartDay,
    this.yearEndDay,
    this.presentDaysNo,
    this.pastSchoolDays,
    this.absentDays,
    this.totalSchoolDays,
  });

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> with TickerProviderStateMixin {
  Map<DateTime, List> holidayDays = {};
  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  Map<DateTime, List> _visibleHolidays;

  DateTime _selectedDay;
  DateTime today = DateTime.now();

  List _selectedEvents;
  AnimationController _controller;

  static DateTime currentDate = DateTime.now();
  DateTime currentDay = DateTime(currentDate.year, currentDate.month, currentDate.day);

  void buildAttendanceCalendarDays(yearStartDay, today, presentDays) {
    DateTime schoolDayIndex = yearStartDay;
    int presentDaysIndex = 0;

    while(schoolDayIndex != today){
      if(holidayDays[schoolDayIndex] == null){
        if(schoolDayIndex.weekday <= 5){
          String attendanceStatus = 'ABSENT';

          if(presentDays.length > 0){
            if(schoolDayIndex == presentDays[presentDaysIndex] && presentDaysIndex < presentDays.length){
              attendanceStatus = 'PRESENT';
              if(presentDaysIndex < presentDays.length - 1){
                presentDaysIndex++;
              }
            }
          }

          try{
            if(_events[schoolDayIndex].isEmpty);
          }catch(e){
            _events[schoolDayIndex] = [];
          }
          _events[schoolDayIndex].add(attendanceStatus);
        }
      }

      schoolDayIndex = schoolDayIndex.add(Duration(days: 1));
    }
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
        holidayDays.entries.where(
          (entry) =>
            entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
            entry.key.isBefore(last.add(const Duration(days: 1))),
          ),
      );
    });
  }

  void getHolidayList() async {
    await fetchHolidayList()
      .then((resolve) {
        for(int i = 0; i < resolve.length; i++){
          Map holiday = resolve[i];
          Map<DateTime, List> holidayRange = {};
          String holidayTitle = holiday['title'];
          DateTime startHoliday = DateTime.parse(holiday['holiday_start_date']).toLocal();
          DateTime endHoliday = DateTime.parse(holiday['holiday_end_date']).toLocal();
          DateTime holidayIndexDate = startHoliday;

          for(;!(holidayIndexDate.isAtSameMomentAs(endHoliday)); holidayIndexDate = holidayIndexDate.add(Duration(days: 1))){
            if(holidayDays[holidayIndexDate] == null){
              holidayDays[holidayIndexDate] = [];
            }
            holidayDays[holidayIndexDate].add(holidayTitle);
          }

          if(holidayDays[holidayIndexDate] == null){
            holidayDays[holidayIndexDate] = [];
          }
          holidayDays[holidayIndexDate].add(holidayTitle);
        }
      });
  }

  @override
  void initState(){
    super.initState();

    getHolidayList();

    _selectedDay = DateTime.now();

    _events = {
      _selectedDay: [],
    };

    try {
      _selectedEvents = _events[_selectedDay] ?? [];
    } catch(e) {
      _selectedEvents = [];
    }

    buildAttendanceCalendarDays(widget.yearStartDay, DateTime(today.year, today.month, today.day), widget.presentDays);

    setState(() {
      widget.absentDays = widget.pastSchoolDays - widget.presentDaysNo;
    });

    _visibleEvents = _events;
    _visibleHolidays = holidayDays;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    if(_selectedEvents.length != 0){
      print(_selectedEvents);
    }
    if(holidayDays[_selectedDay] != null){
      print(holidayDays[_selectedDay]);
    }
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 4.0),
                            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              border: Border.all(
                                  color: Colors.green[50]
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(5.0))
                            ),
                            child: Text(
                              'Present',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 4.0),
                            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color:  Colors.red[300],
                              border: Border.all(
                                color: Colors.red[300]
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(5.0))
                            ),
                            child: Text(
                              'Absent',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 4.0),
                            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.deepPurple
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(5.0))
                            ),
                            child: Text(
                              'Holiday',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    _buildTableCalendarWithBuilders(),
                  ],
                ),
              ),
            ),
          )
        ],
      )
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
          if(DateTime(date.year, date.month, date.day) == currentDay){
            if(!_selectedEvents.contains('CURRENT')){
              _selectedEvents.add('CURRENT');
            }
          }
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: DateTime(date.year, date.month, date.day) != currentDay ? Container(
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
            ) : _buildEventsMarker(_selectedDay, _selectedEvents),
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
        _controller.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    DateTime thisDay = DateTime(date.year, date.month, date.day);
    DateTime selectedDay = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    Color bgColor;
    Color fontColor = Colors.white;

    if(thisDay == selectedDay){
      if(events.contains('PRESENT')){
        bgColor = Colors.green;
        fontColor = Colors.green[100];
      }else if(events.contains('ABSENT')){
        bgColor = Colors.red;
      }else if(events.contains('CURRENT')){
        return _todayBuilder(date);
      }
    }else if(events.contains('PRESENT')){
      bgColor = Colors.green[50];
      fontColor = Colors.green;
    }else if(events.contains('ABSENT')){
      bgColor = Colors.red[300];
    }else if(events.contains('CURRENT')){
      return _todayBuilder(date);
    }else{
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

  Widget _todayBuilder(DateTime date) {
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
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event.toString()),
          onTap: () => print('$event tapped!'),
        ),
      ))
          .toList(),
    );
  }
}