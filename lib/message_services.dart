import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'services.dart';

Future respondNotification(userId, notifId, notifResponse) async {
  String url = '$baseApi/notif/respond-student-notif';

  var response = await http.post(url, body: json.encode({
    'data': {
      'notif_id': notifId,
      'response': notifResponse,
      's_id': userId
    }
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body);
}

class ResponseButton extends StatefulWidget {
  String label;
  int type;
  var onTap;
  bool isActive;


  ResponseButton({
    this.label,
    this.type,
    this.onTap,
    this.isActive
  });

  @override
  _ResponseButtonState createState() => _ResponseButtonState();
}

class _ResponseButtonState extends State<ResponseButton> {
  Color borderColor;
  Color labelColor;
  Color iconColor;
  Color buttonColor;
  IconData icon;

  @override
  Widget build(BuildContext context) {

    if(widget.type == 1){
      borderColor = Color.fromRGBO(21, 126, 204, .6);
      labelColor = Theme.of(context).accentColor;
      iconColor = Color.fromRGBO(21, 126, 204, .95);
      icon = Icons.check;
    }else if(widget.type == 2){
      borderColor = Colors.red[100];
      labelColor = Colors.red[500];
      iconColor = Colors.red[300];
      icon = Icons.block;
    }else {
      borderColor = Colors.amber[200];
      labelColor = Colors.amber[700];
      iconColor = Colors.amber[500];
      icon = Icons.av_timer;
    }

    if(widget.isActive == null) {
      widget.isActive = false;
    }

    if(widget.isActive){
      buttonColor = labelColor;
      borderColor = buttonColor;
      labelColor = Colors.white;
      iconColor = Color.fromRGBO(255, 255, 255, .75);
    }else{
      buttonColor = Colors.white;
    }

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: widget.onTap,
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
              side: BorderSide(
                  color: borderColor
              )
          ),
          splashColor: borderColor,
          highlightColor: borderColor,
          color: buttonColor,
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: Icon(icon, color: iconColor, size: 20.0),
              ),
              Text(
                widget.label,
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: labelColor
                ),
              ),
            ],
          ), onPressed: (){
          return widget.onTap();
        },
        ),
      ),
    );
  }
}

class Board extends StatefulWidget {
  String title;
  String description;
  String category;
  String time;
  String userId;
  String timeStamp;
  List<String> responseActions;
  DateTime date;
  bool hasResponse;
  int responseType;
  int notifId;
  int activeType;

  Board({
    this.title,
    this.description,
    this.category,
    this.responseActions,
    this.hasResponse,
    this.notifId,
    this.date,
    this.responseType,
    this.time,
    this.activeType,
    this.userId,
    this.timeStamp
  });

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    String dateFormatted;
    String timeFormatted;

    if(widget.date != null || widget.time != null){
      if(widget.date != null) {
        dateFormatted = timeFormat(widget.date.toString(), null);
      }
      if(widget.time != null){
        timeFormatted = formatMilitaryTime(widget.time);
      }
    }
    if(widget.hasResponse == null){
      widget.hasResponse = false;
    }
    if(widget.responseType == null){
      widget.responseType = 0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
          child: Text(
            widget.timeStamp,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500]
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(9.0)),
              boxShadow: [BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, .07),
                  blurRadius: 8.0,
                  offset: Offset(2.0, 1.0),
                  spreadRadius: -2.0
              )],
              color: Colors.white
          ),
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(9.0), topRight: Radius.circular(9.0)),
                  color: widget.category.toLowerCase() == 'announcement' ? Color.fromRGBO(212, 153, 83, .08) : Color.fromRGBO(21, 126, 204, .1),
                ),
                child: Text(
                  capitalize(this.widget.category),
                  style: TextStyle(
                      color: widget.category.toLowerCase() == 'announcement' ? Color.fromRGBO(212, 153, 83, 1) : Color.fromRGBO(21, 126, 204, .85),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    widget.date != null || widget.time != null ? Container(
                      child: Flex(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Text(
                            '${dateFormatted}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[600],
                              fontSize: 14.0
                            ),
                          ),
                          widget.time != null ? Container(
                            width: 1.0,
                            height: 10.0,
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300]
                            ),
                          ) : Container(),
                          Text(
                            "${timeFormatted ?? ''}",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[600],
                                fontSize: 14.0
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.only(topRight: Radius.circular(50.0), bottomRight: Radius.circular(50.0))
                      ),
                      padding: EdgeInsets.only(left: 20.0, top: 8.0, bottom: 8.0, right: 15.0),
                      margin: EdgeInsets.only(bottom: 6.0, top: 12.0),
                    ) : Container(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            this.widget.title,
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Color.fromRGBO(78, 78, 78, 1),
                              fontWeight: FontWeight.w700
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.0),
                          ),
                          Text(
                            this.widget.description,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600
                            ),
                          )
                        ],
                      ),
                    ),
                    widget.activeType == 3 ? Container(
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey[300]
                                    )
                                )
                            ),
                            child: Text(
                              'How to reschedule',
                              style: TextStyle(
                                  color: Colors.amber[700],
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                            child: Text(
                              "Please contact (433-3851) or go to the admin office to reschedule with your preferred time and choose a response accordingly afterwards.",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                        ],
                      ),
                    ) : Container(),
                    widget.hasResponse ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.only(top: 20.0, bottom: 0.0),
                      child: Column(
                        children: <Widget>[
                          Flex(
                            direction: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'I am',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1.0,
                                  color: Colors.grey[200],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              children: <Widget>[
                                ResponseButton(
                                  label: 'Going',
                                  type: 1,
                                  isActive: widget.activeType == 1,
                                  onTap: () {
                                    respondNotification(widget.userId, widget.notifId, 'Going');
                                    Timer(Duration(milliseconds: 145), () {
                                      setState(() {
                                        widget.activeType = 1;
                                      });
                                    });
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                ),
                                Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: ResponseButton(
                                        label: 'Not going',
                                        type: 2,
                                        isActive: widget.activeType == 2,
                                        onTap: () {
                                          respondNotification(widget.userId, widget.notifId, 'Not going');
                                          Timer(Duration(milliseconds: 145), () {
                                            setState(() {
                                              widget.activeType = 2;
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                                    ),
                                    Expanded(
                                      child: ResponseButton(
                                        label: 'Reschedule',
                                        type: 3,
                                        isActive: widget.activeType == 3,
                                        onTap: () {
                                          respondNotification(widget.userId, widget.notifId, 'Reschedule');
                                          Timer(Duration(milliseconds: 145), () {
                                            setState(() {
                                              widget.activeType = 3;
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ) : Container()
                  ],
                )
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future buildMessageList(userId, pageSize, pageNum, hasIniated) async {
  int offsetPage = 2;
  int offsetPageSize = pageSize * offsetPage;
  List<String> responseActions = ['Going', 'Not going', 'Reschedule'];
    return await fetchStudentMessages(userId, offsetPageSize, pageNum)
      .then((result) {
        List<List<Widget>> _messages = <List<Widget>>[];
        List _studentNotifications;
        List<DateTime> _timeStampDays = <DateTime>[];
        bool isSuccess = result['success'] ?? false;
        if(isSuccess){
          _studentNotifications = result['data'];
          _messages = transformPaginationListCache(_studentNotifications, pageSize, offsetPage, (item, page, pageItemIndex, index) {
            Map message = item;
            DateTime eventDate;
            DateTime timeStamp;
            DateTime timeStampDay;

            String timeStampHourMinute;
            String eventTime;
            String response = message['response'];
            String dayName;
            String month;
            String day;
            String boardTitle;
            String boardDesc;

            int activeType = 0;

            bool isSameDay = false;

            for(int i = 0; i < responseActions.length; i++){
              if(responseActions[i] == response){
                activeType = i + 1;
                break;
              }
            }

            timeStamp = DateTime.parse(message['notif_timestamp']).toLocal();
            timeStampHourMinute = formatMilitaryTime('${timeStamp.hour}:${timeStamp.minute}');
            timeStampDay = DateTime.utc(timeStamp.year, timeStamp.month, timeStamp.day);

            _timeStampDays.add(timeStampDay);

            dayName = dayNames[_timeStampDays[index].weekday - 1];
            month = monthNames[_timeStampDays[index].month - 1];
            day = _timeStampDays[index].day.toString();

            if(pageItemIndex > 0){
              if(_timeStampDays[index].isAtSameMomentAs(_timeStampDays[index - 1])){
                isSameDay = true;
              }
            }

            if(message['details'].length > 0){
              Map details = message['details'][0];
              String date = details['aa_event_date'];
              eventTime = details['aa_event_time'];
              eventDate = DateTime.parse(date);
              boardTitle = details['aa_subj'];
              boardDesc = details['aa_desc'];
            }else{
              boardTitle = message['notif_subj'];
              boardDesc = message['notif_desc'];
            }

            return Column(
              children: <Widget>[
                pageItemIndex != 0 ? Padding(padding: EdgeInsets.symmetric(vertical: 10.0)) : Container(),
                isSameDay ? Container() : Container(
                  margin: EdgeInsets.only(top: pageItemIndex != 0 ? 40.0 : 0.0, left: 20.0),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200]
                        ),
                        width: 46.0,
                        height: 3.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          '$dayName, $month $day',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700]
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Board(
                  title: boardTitle,
                  description: boardDesc,
                  category: message['category'],
                  hasResponse: message['category'] == 'appointment',
                  notifId: message['id'],
                  date: eventDate,
                  time: eventTime,
                  responseActions: responseActions,
                  activeType: activeType,
                  userId: userId,
                  timeStamp: timeStampHourMinute,
                ),
              ],
            );
          });
        }else{
          return Text('Something went wrong getting you updated. Please try again.');
        }

        return {'messages': _messages};
      });
}

Future fetchStudentMessages(userId, pageSize, pageNum) async {
  String url = '$baseApi/notif/get-paginated-messages';

  var response = await http.post(url, body: json.encode({
    'data': {
      'page_size': pageSize,
      'page_num': pageNum,
      's_id': userId
    }
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body);
}