import 'package:flutter/material.dart';

final List<Object> _notificationData = [
  {'msg': 'Teacher has posted your 1st quarter grade', 'postDate': 'about an hour ago'},
  {'msg': 'Teacher has posted your 2nd quarter grade', 'postDate': 'about two hours ago'},
  {'msg': 'Teacher has posted your 3rd quarter grade', 'postDate': 'about three hours ago'},
];
//
//final Iterable<Widget> _notificationViews = _notificationData.map((notif) =>
//  new _TextNotifications(
//    msg: notif.msg,
//    postDate: notif.postDate
//  )
//);


class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.tealAccent[700],
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Kion Kefir C. Gargar',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700
                        ),
                      )
                    ],
                  ),
                ),
                Divider(height: 1.0, color: Colors.grey[300]),
              ],
            ),
            Flexible(
              child: ListView(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    _TextNotifications(
                      msg: 'Teacher has posted your 1st quarter grade',
                      postDate: 'about an hour ago',
                    ),
                    _TextNotifications(
                      msg: 'Teacher has posted your 2nd quarter grade',
                      postDate: 'about two hours ago',
                    ),
                    _TextNotifications(
                      msg: 'Teacher has posted your 3rd quarter grade',
                      postDate: 'about three hours ago',
                    ),
                  ]
                ).toList(),
              )
            )
          ],
        ),
      ),
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
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.deepOrange,
        radius: 24.0,
      ),
      title: Text(
        widget.msg,
        maxLines: 3,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400
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
    );
  }
}