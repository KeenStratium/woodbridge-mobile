import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class ActivityEvent {
  String title;
  String venue;
  String time;
  String day;
  String weekday;

  ActivityEvent({this.title, this.venue, this.time, this.day, this.weekday});
}

List<ActivityEvent> june = <ActivityEvent>[
  ActivityEvent(
      title: 'Event title 1',
      venue: 'Multi-purpose Gym',
      time: '8:00am',
      day: '02',
      weekday: 'Tue'
  ),
  ActivityEvent(
      title: 'Event title 2',
      venue: 'Carmelite Hall',
      time: '9:30am',
      day: '02',
      weekday: 'Tue'
  ),
  ActivityEvent(
      title: 'Event title 3',
      venue: 'Multi-purpose Gym',
      time: '8:00am',
      day: '04',
      weekday: 'Thu'
  ),
];

List<ActivityEvent> july = <ActivityEvent>[
  ActivityEvent(
      title: 'Event title 4',
      venue: 'Multi-purpose Gym',
      time: '1:30pm',
      day: '04',
      weekday: 'Fri'
  ),
  ActivityEvent(
      title: 'Event title 5',
      venue: 'Multi-purpose Gym',
      time: '1:30pm',
      day: '04',
      weekday: 'Fri'
  ),
  ActivityEvent(
      title: 'Event title 6',
      venue: 'Multi-purpose Gym',
      time: '1:30pm',
      day: '04',
      weekday: 'Fri'
  ),
];

List<ActivityEvent> august = <ActivityEvent>[
  ActivityEvent(
      title: 'Event title 1',
      venue: 'Multi-purpose Gym',
      time: '8:00am',
      day: '02',
      weekday: 'Tue'
  ),
  ActivityEvent(
      title: 'Event title 2',
      venue: 'Carmelite Hall',
      time: '9:30am',
      day: '02',
      weekday: 'Tue'
  ),
  ActivityEvent(
      title: 'Event title 3',
      venue: 'Multi-purpose Gym',
      time: '8:00am',
      day: '04',
      weekday: 'Thu'
  ),
];

Map monthActivities = {};

bool isInitiated = false;

List<String> activityNames = <String>[];

Future<List> getStudentActivities(classId) async {
  String url = '$baseApi/act/get-student-activities?data=$classId';

  var response = await http.get(url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    });

  return jsonDecode(response.body);
}

List<Widget> _buildLists(BuildContext context, int firstIndex, int count) {
  return List.generate(count, (sliverIndex) {
    sliverIndex += firstIndex;
    return new SliverStickyHeaderBuilder(
      builder: (context, state) => _buildHeader(context, sliverIndex, state),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => Container(
            margin: EdgeInsets.only(top: i == 0 ? 20.0 : 0.00, bottom: i == monthActivities[activityNames[sliverIndex]].length - 1 ? 20.00 : 0.00),
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              height: 80.0,
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              padding: EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                boxShadow: [BrandTheme.cardShadow],
              ),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            monthActivities[activityNames[sliverIndex]][i].day,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Theme.of(context).accentColor
                            ),
                          ),
                          Text(
                            monthActivities[activityNames[sliverIndex]][i].weekday,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black54
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          monthActivities[activityNames[sliverIndex]][i].title,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Flexible(
                              flex: 0,
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    size: 16.0,
                                    color: Colors.black54,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1.0),
                                  ),
                                  Text(
                                    monthActivities[activityNames[sliverIndex]][i].time,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      fontSize: 14.0
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.0),
                            ),
                            Expanded(
                              flex: 3,
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Flexible(
                                    flex: 0,
                                    child: Icon(
                                      Icons.location_on,
                                      size: 16.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 0,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 1.0),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        monthActivities[activityNames[sliverIndex]][i].venue,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                          fontSize: 14.0
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          childCount: monthActivities[activityNames[sliverIndex]].length,
        ),
      ),
    );
  });
}

Widget _buildHeader(BuildContext context, int index, SliverStickyHeaderState state, {String text}) {
  return new Container(
    height: 48.0,
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: Colors.grey[300],
          width: 1.0
        ),
        top: BorderSide(
          color: state.isPinned ? Colors.white : Colors.grey[300],
          width: 1.0
        )
      )
    ),
    child: new Text(
      text ?? activityNames[index],
      style: TextStyle(
        color: Colors.black87,
        fontSize: 16.0,
        fontWeight: FontWeight.w700
      ),
    ),
  );
}

class Activities extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String classId;

  Activities({
    this.firstName,
    this.lastName,
    this.classId
  });

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  List<String> monthNames = <String>['January', 'February', 'March', 'April','May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  void transformActivityList(classId) async {
    await getStudentActivities(classId)
      .then((results) {
        DateTime currTime = DateTime.now();
        DateTime currDay = DateTime(currTime.year, currTime.month, currTime.day);
        List<String> weekdayNames = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

        try {
          if(monthActivities['June'].length > 0);
        } catch(e){
          monthActivities['June'] = [];
        }
        monthActivities['June'].addAll(august);

        try {
          if(monthActivities['July'].length > 0);
        } catch(e){
          monthActivities['July'] = [];
        }
        monthActivities['July'].addAll(july);

        monthActivities.forEach((month, activities) {
          if(!activityNames.contains(month)){
            activityNames.add(month);
          }
        });

        for(int i = 0; i < results.length; i++){
          Map activity = results[i];
          DateTime date = DateTime.parse(activity['a_start_date']);
          int monthIndex = date.month - 1;
          String month = monthNames[monthIndex];

          date = date.add(Duration(hours: 8));

          if(date.isAfter(currDay) || date.isAtSameMomentAs(currDay)){
            ActivityEvent activityEvent = ActivityEvent(
              title: activity['a_title'],
              venue: activity['a_location'],
              time: activity['a_time_start'],
              day: '${date.day < 10 ? '0' : ''}${date.day.toString()}',
              weekday: weekdayNames[date.weekday - 1]
            );

            try {
              if(monthActivities[month].length > 0);
            } catch(e){
              monthActivities[month] = [];
            }
            monthActivities[month].add(activityEvent);
            if(activityNames.contains(month) == false){
              activityNames.add(month);
            }
          }
        }
        sortActivityNames();

        setState(() {});
    });
  }

  void sortActivityNames() {
    List<int> sortedMonthIndex = <int>[];
    List<String> sortedMonthNames = <String>[];

    for(int i = 0; i < activityNames.length; i++){
      String month = activityNames[i];
      int monthIndex = 0;
      int largestMonthIndex = 0;

      for(monthIndex = 0; monthIndex < monthNames.length; monthIndex++){
        if(monthNames[monthIndex] == month){
          if(monthIndex > largestMonthIndex){
            largestMonthIndex = monthIndex;
          }
          break;
        }
      }
      
      sortedMonthIndex.add(monthIndex);
      sortedMonthIndex.sort();
    }
    for(int i = 0; i < sortedMonthIndex.length; i++){
      sortedMonthNames.add(monthNames[sortedMonthIndex[i]]);
    }
    activityNames = sortedMonthNames;
  }

  @override
  void initState(){
    super.initState();
    if(!isInitiated){
      setState(() {
        transformActivityList(widget.classId);
      });
    }
    isInitiated = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar of Activities'),
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            ProfileHeader(
              firstName: this.widget.firstName,
              lastName: this.widget.lastName,
            ),
            Flexible(
              child: Builder(builder: (BuildContext context) {
                return new CustomScrollView(
                  slivers: _buildLists(context, 0, monthActivities.length),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}