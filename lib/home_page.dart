import 'package:flutter/material.dart';
import 'notifications.dart';
import 'profile.dart';
import 'grades.dart';
import 'attendance.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 28.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          maxRadius: 48.0,
                          minRadius: 24.0,
                          backgroundColor: Colors.tealAccent[700],
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Gargar,\nKion Kefir C.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0
                                    ),
                                  ),
                                  Icon(Icons.arrow_drop_down)
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Column(
                              children: <Widget>[
                                Text('Kinder-Orchid',),
                                Text('S.Y. 2018-2019')
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                ],
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    MenuItem(
                        icon: Icons.notifications_none,
                        label: 'Notifications',
                        pageBuilder: Notifications(),
                        buildContext: context,
                    ),
                    Divider(height: 1.0, color: Colors.grey[300]),
                    MenuItem(
                        icon: Icons.person_outline,
                        label: 'Profile',
                        pageBuilder: Profile(),
                        buildContext: context,
                    ),
                    Divider(height: 1.0, color: Colors.grey[300]),
                    MenuItem(
                      icon: Icons.star_border,
                      label: 'Grades',
                      pageBuilder: Grades(),
                      buildContext: context,
                    ),
                    Divider(height: 1.0, color: Colors.grey[300]),
                    MenuItem(
                        icon: Icons.event_available,
                        label: 'Attendance',
                      pageBuilder: Attendance(),
                      buildContext: context,
                    ),
                    Divider(height: 1.0, color: Colors.grey[300]),
                    MenuItem(
                        icon: Icons.event,
                        label: 'Calendar of Activities'
                    ),
                    Divider(height: 1.0, color: Colors.grey[300]),
                    MenuItem(
                        icon: Icons.filter,
                        label: 'Activity Gallery'
                    ),
                    Divider(height: 1.0, color: Colors.grey[300]),
                    MenuItem(
                        icon: Icons.payment,
                        label: 'Payment History'
                    ),
                    Divider(height: 1.0, color: Colors.grey[300]),
                  ],
                ),
              )
            ],
          ),
        )
      ),
      appBar: AppBar(
        title: Text('Woodbridge'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  MenuItem({
    Key key,
    this.child,
    this.label,
    this.icon,
    this.pageBuilder,
    this.buildContext
  }) : super(key: key);

  final Widget child;
  final IconData icon;
  final String label;
  final Widget pageBuilder;
  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(builder: (buildContext) => pageBuilder);
        Navigator.push(buildContext, route);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(icon),
            SizedBox(
              width: 12.0,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),
    );
  }
}