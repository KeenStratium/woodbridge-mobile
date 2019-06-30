import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'package:flutter/services.dart';

Future buildNotificationList(userId, pageSize, pageNum) async {
  List<Future> futures = <Future>[fetchStudentNotification(userId, pageSize, pageNum)];

  return await Future.wait(futures)
    .then((result) {
      List<Widget> _notifications = <Widget>[];
      Map currentPageData = result[0];
      List _studentNotifications = currentPageData['data'];
      bool isSuccess = currentPageData['success'] ?? false;
      if(isSuccess){
        for(int i = 0; i < _studentNotifications.length; i++){
          Map studentNotification = _studentNotifications[i];
          print(studentNotification['id']);
          _notifications.add(_TextNotifications(
            msg: studentNotification['notif_desc'],
            postDate: 'about an hour ago',
          ));
        }
      }else{
        return Text('Something went wrong getting you updated. Please try again.');
      }

      return {'notifications': _notifications};
    });
}
Future fetchStudentNotification(userId, pageSize, pageNum) async {
  String url = '$baseApi/notif/get-paginated-notifications';

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

class Notifications extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userId;
  int pageNum = 1;
  int pageSize = 3;
  bool completedAllPages = false;
  List<List<Widget>> notificationTiles = [];

  Notifications({
    this.firstName,
    this.lastName,
    this.userId
  });

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  Future initGetNextPage(pageNum) async {
    return await buildNotificationList(widget.userId, widget.pageSize, pageNum + 1)
      .then((data) {
        widget.notificationTiles.add(data['notifications']);
      });
  }

  Future updateNotificationList(pageNum) async {
    if(!widget.completedAllPages){
      if(pageNum == 1){
        await initGetNextPage(pageNum - 1);
        await initGetNextPage(pageNum);
      }
      if(pageNum == widget.notificationTiles.length){
        print('fetching next data');
        await initGetNextPage(pageNum);
        await initGetNextPage(pageNum + 1);
      }
      if(widget.notificationTiles[widget.notificationTiles.length-1].length == 0){
        widget.completedAllPages = true;
      }
    }

    return widget.notificationTiles[pageNum-1];
  }

  @override
  void initState(){
    super.initState();

    initGetNextPage(widget.pageNum - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Container(
        height: double.infinity,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 0,
                    child: ProfileHeader(
                      firstName: widget.firstName,
                      lastName: widget.lastName,
                      heroTag: widget.userId,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: FutureBuilder(
                      future: updateNotificationList(widget.pageNum),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if(snapshot.connectionState == ConnectionState.done){
                          return ListView(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            children: ListTile.divideTiles(
                              context: context,
                              tiles: snapshot.data
                            ).toList(),
                          );
                        }else{
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[300]
                  )
                )
              ),
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Material(
                    color: Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.chevron_left),
                      color: Colors.grey[700],
                      tooltip: 'Previous',
                      highlightColor: Theme.of(context).accentColor,
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      onPressed: widget.pageNum > 1 ? () {
                        setState(() {
                          widget.pageNum--;
                        });
                      } : null,
                    ),
                  ),
                  Text(
                    'Page ${widget.pageNum}',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                        color: Colors.grey[600]
                    ),
                  ),
                  Material(
                    color: Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.chevron_right),
                      color: Colors.grey[700],
                      tooltip: 'Next',
                      highlightColor: Theme.of(context).accentColor,
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      onPressed: widget.completedAllPages && widget.pageNum + 1 == widget.notificationTiles.length ? null : (){
                        print(widget.completedAllPages);
                        setState(() {
                          widget.pageNum++;
                        });
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}

class _TextNotifications extends StatefulWidget {
  final String msg;
  final String postDate;

  _TextNotifications({
    Key key,
    this.msg,
    this.postDate,
}) : super (key: key);

  @override
  __TextNotificationsState createState() => __TextNotificationsState();
}

class __TextNotificationsState extends State<_TextNotifications> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 246, 246, 1)
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepOrange,
          radius: 24.0,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
        title: Text(
          widget.msg,
          maxLines: 3,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800]
          ),
        ),
        subtitle: Text(
          widget.postDate,
          style: TextStyle(
            fontSize: 12.0
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_horiz),
          onPressed: () {}
        ),
      ),
    );
  }
}