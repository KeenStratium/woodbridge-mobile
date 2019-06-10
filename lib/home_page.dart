import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'notifications.dart';
import 'profile.dart';
import 'grades.dart';
import 'attendance.dart';
import 'activities.dart';
import 'gallery.dart';
import 'payment.dart';

List<String> users = <String>['S-1559282542934', 'S-1559284284622', 'S-1559286546870'];
bool showStudentSwitcher = false;

class HomePage extends StatefulWidget {
  Widget child;
  String firstName;
  String lastName;
  String heroTag;
  String schoolLevel;
  String classId;

  HomePage({
    this.child,
    this.firstName,
    this.lastName,
    this.heroTag,
    this.schoolLevel,
    this.classId
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    height *= .2;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Material(
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Scaffold(
                  key: _scaffoldKey,
                  drawer: Drawer(
                    child: Flex(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Flexible(
                          flex: 0,
                          child: UserAccountsDrawerHeader(
                            accountEmail: Text(
                              'Kinder - Orchid',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            accountName: Text(
                              'Keanu Kent B. Gargar',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w800
                              ),
                            ),
                            otherAccountsPictures: <Widget>[
                              Icon(
                                  Icons.close,
                                  color: Color.fromRGBO(255, 255, 255, .75)
                              )
                            ],
                            currentAccountPicture: Avatar(
                                backgroundColor: Colors.indigo,
                                maxRadius: 20.0,
                                minRadius: 10.0,
                                fontSize: 18.0,
                                initial: "KG"
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(Icons.book),
                                      title: Text(
                                          "Handbook Guide",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87
                                          )
                                      ),
                                      onTap: () {
                                      },
                                    ),
                                    Divider(
                                      color: Colors.grey[400],
                                      height: 16.0,
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.verified_user),
                                      title: Text(
                                          'Privacy Policy',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87
                                          )
                                      ),
                                      onTap: () {
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.account_balance),
                                      title: Text(
                                          'Legal Terms',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87
                                          )
                                      ),
                                      onTap: () {
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.error),
                                      title: Text(
                                          'About Us',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87
                                          )
                                      ),
                                      onTap: () {
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Divider(
                                      color: Colors.grey[400],
                                      height: 16.0,
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.exit_to_app),
                                      title: Text(
                                          'Logout',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87
                                          )
                                      ),
                                      onTap: () {
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: Container(
                    child: Flex(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Flexible(
                          flex: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: AssetImage('img/home_profile_head_cover.png')
                                )
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                            child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Route route = MaterialPageRoute(
                                        builder: (buildContext) => Profile(
                                          heroTag: widget.heroTag,
                                          firstName: this.widget.firstName,
                                          lastName: this.widget.lastName,
                                        ));
                                    Navigator.push(context, route);
                                  },
                                  child: Hero(
                                      tag: this.widget.heroTag,
                                      child: this.widget.child
                                  ),
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
                                      color: Color.fromRGBO(255, 255, 255, 0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            showStudentSwitcher = true;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '${this.widget.lastName ?? "Gargar"}, ${this.widget.firstName ?? "Kion Kefir"}',
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
                                                      'Next Payment',
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.black87
                                                      ),
                                                    ),
                                                    Column(
                                                      children: <Widget>[
                                                        Text(
                                                          'Sept.',
                                                          style: TextStyle(
                                                              color: Colors.black38,
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.w600
                                                          ),
                                                        ),
                                                        Text(
                                                          '13',
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
                                        iconPath: 'img/Icons/icon_payments_2x.png',
                                        label: 'Payments',
                                        pageBuilder: PaymentHistory(
                                          firstName: this.widget.firstName,
                                          lastName: this.widget.lastName,
                                          userId: this.widget.heroTag,
                                        ),
                                        buildContext: context,
                                      ),
                                      MenuItem(
                                        iconPath: 'img/Icons/icon_attendance_2x.png',
                                        label: 'Attendance',
                                        pageBuilder: Attendance(
                                            firstName: this.widget.firstName,
                                            lastName: this.widget.lastName,
                                            userId: this.widget.heroTag
                                        ),
                                        buildContext: context,
                                      ),
                                      MenuItem(
                                        iconPath: 'img/Icons/icon_grades.png',
                                        label: 'Progress',
                                        pageBuilder: Grades(
                                            userId: widget.heroTag,
                                            firstName: this.widget.firstName,
                                            lastName: this.widget.lastName,
                                            schoolLevel: this.widget.schoolLevel
                                        ),
                                        buildContext: context,
                                      ),
                                      MenuItem(
                                        iconPath: 'img/Icons/icon_activities_2x.png',
                                        label: 'Activities',
                                        pageBuilder: Activities(
                                          firstName: this.widget.firstName,
                                          lastName: this.widget.lastName,
                                          classId: this.widget.classId,
                                          userId: this.widget.heroTag,
                                        ),
                                        buildContext: context,
                                      ),
                                      MenuItem(
                                        iconPath: 'img/Icons/icon_gallery.png',
                                        label: 'Photos',
                                        pageBuilder: ActivityGallery(
                                          firstName: this.widget.firstName,
                                          lastName: this.widget.lastName,
                                          userId: this.widget.heroTag,
                                        ),
                                        buildContext: context,
                                      ),
                                      MenuItem(
                                        iconPath: 'img/Icons/icon_handbook_2x.png',
                                        label: 'Handbook',
                                        pageBuilder: Profile(
                                          heroTag: widget.heroTag,
                                          firstName: this.widget.firstName,
                                          lastName: this.widget.lastName,
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
                        _scaffoldKey.currentState.openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    actions: <Widget>[
                      IconButton(
                        onPressed: () {
                          Route route = MaterialPageRoute(builder: (buildContext) => Notifications(
                            firstName: this.widget.firstName,
                            lastName: this.widget.lastName,
                          ));
                          Navigator.push(context, route);
                        },
                        icon: Icon(
                          Icons.notifications_none,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ],
                  ),
                )
              ),
              Positioned(
                child: showStudentSwitcher ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(22, 86, 135, .88)
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      margin: EdgeInsets.only(top: height),
                      child: Flex(
                        direction: Axis.vertical,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              'Select Student',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 360.00
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                child: GridView.count(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  primary: false,
                                  childAspectRatio: .9,
                                  crossAxisCount: 2,
                                  physics: BouncingScrollPhysics(),
                                  children: users.map((userId) {
                                    return StudentAvatarPicker(
                                      userId: '${userId}',
                                      isActive: userId == widget.heroTag,
                                      onTap: (lname, fname, schoolLevel, classId) {
                                        setState(() {
                                          showStudentSwitcher = false;
                                          widget.child = Avatar(
                                            backgroundColor: Colors.indigo,
                                            maxRadius: 40.0,
                                            fontSize: 20.0,
                                            initial: "${fname != null ? fname[0] : ''}${lname != null ? lname[0] : ''}"
                                          );
                                          widget.firstName = fname ?? '';
                                          widget.lastName = lname ?? '';
                                          widget.heroTag = userId;
                                          widget.schoolLevel = schoolLevel;
                                          widget.classId = classId;
                                        });
                                      }
                                    );
                                  }).toList()
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ) : Container(),
              ),
            ],
          ),
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