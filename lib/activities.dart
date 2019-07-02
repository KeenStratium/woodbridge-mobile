import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'services.dart';

class ActivityEvent {
  String title;
  String venue;
  String time;
  String day;
  String weekday;

  ActivityEvent({this.title, this.venue, this.time, this.day, this.weekday});
}

Map monthActivities = {};

bool isInitiated = false;

List<String> activityNames = <String>[];

String oldUserId = '';

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
                                    formatMilitaryTime(monthActivities[activityNames[sliverIndex]][i].time),
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
  final String userId;

  Activities({
    this.firstName,
    this.lastName,
    this.classId,
    this.userId
  });

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
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
              heroTag: this.widget.userId,
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