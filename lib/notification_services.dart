import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'services.dart';

class TextNotifications extends StatefulWidget {
  TextNotifications({
    Key key,
    this.msg,
    this.postDate,
    this.profileAvatar,
    this.title
  }) : super (key: key);

  final String msg;
  final String postDate;
  final String profileAvatar;
  final String title;

  @override
  _TextNotificationsState createState() => _TextNotificationsState();
}

class _TextNotificationsState extends State<TextNotifications> {
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
          backgroundImage: AssetImage('img/Icons/Icon-180.png'),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              capitalize(widget.title) ?? '',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
                fontWeight: FontWeight.w700
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.0),
            ),
            Text(
              widget.msg.length > 0 ? widget.msg : '' ?? '',
              maxLines: 6,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800]
              ),
            )
          ],
        ),
        subtitle: Text(
          widget.postDate ?? '',
          style: TextStyle(
              fontSize: 12.0
          ),
        ),
      ),
    );
  }
}

Future buildNotificationList(userId, pageSize, pageNum) async {
  int offsetPage = 3;
  int offsetPageSize = pageSize * offsetPage;
  int offsetPageNum = ((pageNum/offsetPage) + 1).floor();
  List<Future> futures = <Future>[fetchStudentNotification(userId, offsetPageSize, offsetPageNum)];

  return Future.wait(futures)
    .then((result) {
      List<List<Widget>> _notifications = <List<Widget>>[];
      Map currentPageData = result[0];
      List _studentNotifications = currentPageData['data'];
      bool isSuccess = currentPageData['success'] ?? false;
      DateTime now = DateTime.now();
      int currentEpoch = (now.millisecondsSinceEpoch/1000).floor();

      if(isSuccess){
        _notifications = transformPaginationListCache(_studentNotifications, pageSize, offsetPage, (item, page, pageItemIndex, index) {
          var postDateEpoch = (DateTime.parse(item['notif_timestamp']).toLocal().millisecondsSinceEpoch/1000).floor();
          return TextNotifications(
            msg: item['notif_desc'] ?? '',
            postDate: epochToHumanTime(currentEpoch - postDateEpoch),
            profileAvatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=707b9c33066bf8808c934c8ab394dff6",
            title: item['notif_subj'] ?? ''
          );
        });
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