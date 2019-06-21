import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

final List<Object> _notificationData = [
  {'msg': 'Teacher has posted your 1st quarter grade', 'postDate': 'about an hour ago'},
  {'msg': 'Teacher has posted your 2nd quarter grade', 'postDate': 'about two hours ago'},
  {'msg': 'Teacher has posted your 3rd quarter grade', 'postDate': 'about three hours ago'},
];

class Notifications extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String userId;

  Notifications({
    this.firstName,
    this.lastName,
    this.userId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ProfileHeader(
              firstName: firstName,
              lastName: lastName,
              heroTag: userId,
            ),
            Flexible(
              child: ListView(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    _TextNotifications(
                      msg: 'Your student Ceri has been checked present by teacher Lulu!',
                      postDate: 'about an hour ago',
                      profileAvatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=707b9c33066bf8808c934c8ab394dff6"
                    ),
                    _TextNotifications(
                      msg: 'Next payment due is on August 5.',
                      postDate: '3 hours ago',
                        profileAvatar: "https://randomuser.me/api/portraits/women/68.jpg"
                    ),
                    _TextNotifications(
                      msg: "Parent's Orientation is on ",
                      postDate: 'about three hours ago',
                        profileAvatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=707b9c33066bf8808c934c8ab394dff6"
                    ),
                    _TextNotifications(
                      msg: 'Ceri has just been picked up from school.',
                      postDate: '4pm Yesterday',
                        profileAvatar: "https://randomuser.me/api/portraits/men/97.jpg"
                    ),
                    _TextNotifications(
                      msg: 'No school tomorrow due to Typhoon, have a safe day!',
                      postDate: '3 days ago',
                        profileAvatar: "https://randomuser.me/api/portraits/women/68.jpg"
                    ),
                    _TextNotifications(
                        msg: 'Ceri has just been picked up from school.',
                        postDate: '3 days ago',
                        profileAvatar: "https://randomuser.me/api/portraits/men/97.jpg"
                    ),
                    _TextNotifications(
                        msg: 'Joffrey has just been picked up from school.',
                        postDate: '3 days ago',
                        profileAvatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=707b9c33066bf8808c934c8ab394dff6"
                    ),
                    _TextNotifications(
                        msg: 'Your student Ceri has been checked present by teacher Lulu!',
                        postDate: 'about an hour ago',
                        profileAvatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=707b9c33066bf8808c934c8ab394dff6"
                    ),
                    _TextNotifications(
                        msg: 'Your student Joffrey has been checked present by teacher Nen!',
                        postDate: 'about an hour ago',
                        profileAvatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=707b9c33066bf8808c934c8ab394dff6"
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
  final String profileAvatar;

  _TextNotifications({
    Key key,
    this.msg,
    this.postDate,
    this.profileAvatar
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
        backgroundImage: NetworkImage(widget.profileAvatar),
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