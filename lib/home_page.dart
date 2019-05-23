import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'notifications.dart';
import 'profile.dart';
import 'grades.dart';
import 'attendance.dart';
import 'activities.dart';
import 'gallery.dart';
import 'payment.dart';

class HomePage extends StatelessWidget {
  final Widget child;
  final String firstName;
  final String lastName;
  final String heroTag;

  HomePage({
    this.child,
    this.firstName,
    this.lastName,
    this.heroTag
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: this.heroTag,
                      child: this.child
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Material(
                          color: Theme.of(context).accentColor,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${this.lastName ?? "Gargar"}, ${this.firstName ?? "Kion Kefir"}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                    color: Colors.white
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Kinder-Orchid',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            Text(
                              'S.Y. 2018-2019',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: double.infinity,
                              maxHeight: 90.0
                            ),
                            child: Container(
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
                                            'Avg. Grade',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w700,
                                              color: Colors.black87
                                            ),
                                          ),
                                          Text(
                                            'S',
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
                                            'Attendance',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black87
                                            ),
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                  ),
                                                  Text(
                                                    'Present',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 16.0,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '136/138',
                                                style: TextStyle(
                                                    color: Colors.black38,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                            ],
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
                                            'Next Event',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black87
                                            ),
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                'Jan',
                                                style: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              Text(
                                                '01',
                                                style: TextStyle(
                                                    color: Theme.of(context).accentColor,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 6,
                        child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          children: <Widget>[
                            MenuItem(
                              iconPath: 'img/Icons/icon_students_2x.png',
                              label: 'Profile',
                              pageBuilder: Profile(
                                heroTag: heroTag
                              ),
                              buildContext: context,
                            ),
                            MenuItem(
                              iconPath: 'img/Icons/icon_grades.png',
                              label: 'Grades',
                              pageBuilder: Grades(
                                firstName: this.firstName,
                                lastName: this.lastName,
                              ),
                              buildContext: context,
                            ),
                            MenuItem(
                              iconPath: 'img/Icons/icon_attendance_2x.png',
                              label: 'Attendance',
                              pageBuilder: Attendance(
                                firstName: this.firstName,
                                lastName: this.lastName,
                              ),
                              buildContext: context,
                            ),
                            MenuItem(
                              iconPath: 'img/Icons/icon_activities_2x.png',
                              label: 'Activities',
                              pageBuilder: Activities(
                                firstName: this.firstName,
                                lastName: this.lastName,
                              ),
                              buildContext: context,
                            ),
                            MenuItem(
                              iconPath: 'img/Icons/icon_gallery.png',
                              label: 'Gallery',
                              pageBuilder: ActivityGallery(
                                firstName: this.firstName,
                                lastName: this.lastName,
                              ),
                              buildContext: context,
                            ),
                            MenuItem(
                              iconPath: 'img/Icons/icon_payments_2x.png',
                              label: 'Payments',
                              pageBuilder: PaymentHistory(
                                firstName: this.firstName,
                                lastName: this.lastName,
                              ),
                              buildContext: context,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("img/woodbridge_logo.png")
              )
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (buildContext) => Notifications(
                firstName: this.firstName,
                lastName: this.lastName,
              ));
              Navigator.push(context, route);
            },
            icon: Icon(
              Icons.notifications_none,
              color: Theme.of(context).accentColor,
            ),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  MenuItem({
    Key key,
    this.child,
    this.label,
    this.iconPath,
    this.pageBuilder,
    this.buildContext
  }) : super(key: key);

  final Widget child;
  final String iconPath;
  final String label;
  final Widget pageBuilder;
  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Route route = MaterialPageRoute(builder: (buildContext) => pageBuilder);
          Navigator.push(buildContext, route);
        },
        child: Material(
          child: InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                boxShadow: [BrandTheme.cardShadow],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(7.0))
              ),
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(iconPath)
                        )
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}