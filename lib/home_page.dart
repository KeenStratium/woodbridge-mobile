import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'notifications.dart';
import 'profile.dart';
import 'grades.dart';
import 'attendance.dart';
import 'activities.dart';
import 'gallery.dart';
import 'payment.dart';

List<ActivityEvent> june = <ActivityEvent>[
  ActivityEvent(
      title: 'Event title 1',
      venue: 'Multi-purpose Gym',
      time: '8:00:00',
      day: '02',
      weekday: 'Tue'
  ),
  ActivityEvent(
      title: 'Event title 2',
      venue: 'Carmelite Hall',
      time: '9:30:00',
      day: '02',
      weekday: 'Tue'
  ),
  ActivityEvent(
      title: 'Event title 3',
      venue: 'Multi-purpose Gym',
      time: '8:00:00',
      day: '04',
      weekday: 'Thu'
  ),
];

List<ActivityEvent> july = <ActivityEvent>[
  ActivityEvent(
      title: 'Event title 4',
      venue: 'Multi-purpose Gym',
      time: '15:30:00',
      day: '04',
      weekday: 'Fri'
  ),
  ActivityEvent(
      title: 'Event title 5',
      venue: 'Multi-purpose Gym',
      time: '15:30:00',
      day: '04',
      weekday: 'Fri'
  ),
  ActivityEvent(
      title: 'Event title 6',
      venue: 'Multi-purpose Gym',
      time: '13:30:00',
      day: '04',
      weekday: 'Fri'
  ),
];

List<ActivityEvent> august = <ActivityEvent>[
  ActivityEvent(
      title: 'Event title 1',
      venue: 'Multi-purpose Gym',
      time: '8:00:00',
      day: '02',
      weekday: 'Tue'
  ),
  ActivityEvent(
      title: 'Event title 2',
      venue: 'Carmelite Hall',
      time: '9:05:00',
      day: '02',
      weekday: 'Tue'
  ),
  ActivityEvent(
      title: 'Event title 3',
      venue: 'Multi-purpose Gym',
      time: '8:00:00',
      day: '04',
      weekday: 'Thu'
  ),
];

List<String> users = <String>['S-1559282542934', 'S-1559284284622', 'S-1559286546870'];
bool showStudentSwitcher = false;

Future<Map> getPresentDaysNo(userId) async {
  String url = '$baseApi/att/get-present-days-of-student';

  var response = await http.post(url, body: json.encode({
    'data': userId
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body)[0];
}
Future<Map> getTotalSchoolDays(userId) async {
  String url = '$baseApi/att/get-total-school-days';

  var response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body)[0];
}
Future<Map> getAbsentDays(userId) async {
  String url = '$baseApi/att/get-absent-days-of-school?data=$userId';

  var response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body)[0];
}
Future<List> getAttendanceDays(userId) async {
  String url = '$baseApi/att/get-student-attendance';

  var response = await http.post(url, body: json.encode({
    "data": userId
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body);
}
Future<List> getSchoolYearInformation() async {
  String url = '$baseApi/att/get-attendance-setting-information';

  var response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body);
}
Future<List> getStudentLatestAttendance(userId) async {
  String url = '$baseApi/att/get-student-latest-attendance';

  var response = await http.post(url, body: json.encode({
    "data": userId
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body);
}

class HomePage extends StatefulWidget {
  Widget child;
  String firstName;
  String lastName;
  String heroTag;
  String schoolLevel;
  String classId;
  String gradeLevel;
  String gradeSection;

  HomePage({
    this.child,
    this.firstName,
    this.lastName,
    this.heroTag,
    this.schoolLevel,
    this.classId,
    this.gradeLevel,
    this.gradeSection
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Color attendanceStatusColor = Colors.redAccent;
  Icon attendanceStatusIcon = Icon(
    Icons.error_outline,
    color: Colors.redAccent,
  );
  List<String> monthNames = <String>['January', 'February', 'March', 'April','May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  String attendanceStatus = '';
  String schoolYearStart;
  String schoolYearEnd;
  String nextEventMonth;
  String nextEventDay;

  List<DateTime> schoolDays = <DateTime>[];
  List<DateTime> presentDays = <DateTime>[];
  List<DateTime> noSchoolDays = <DateTime>[];
  List<DateTime> specialSchoolDays = <DateTime>[];

  DateTime yearStartDay;
  DateTime yearEndDay;

  double totalSchoolDays = 0;
  int presentDaysNo = 0;
  int pastSchoolDays = 0;
  int absentDays = 0;

  void getAttendanceInfo(userId) {
    Future.wait([
      getPresentDaysNo(userId)
        .then((result) {
          setState(() {
            presentDaysNo = result['presentDays'];
          });
        }),
      getTotalSchoolDays(userId)
        .then((result) {
          setState(() {
            totalSchoolDays = result['totalDays'];
          });
        }),
      getAbsentDays(userId)
        .then((result) {
          setState(() {
            pastSchoolDays = result['totalDaysNow'];
          });
        }),
      getAttendanceDays(userId)
        .then((results) {
          results.forEach((result) {
            DateTime attendanceDate = DateTime.parse(result['attendance_date']);
            DateTime attendanceDay = DateTime(attendanceDate.year, attendanceDate.month, attendanceDate.day);
            presentDays.add(attendanceDay);
          });
        }),
      getStudentLatestAttendance(userId)
        .then((results) {
          try {
            if(results.length > 0 || results != null){
              Map latestAttendance = results[0];
              DateTime attendanceDate = DateTime.parse(latestAttendance['attendance_date']).toLocal();
              DateTime today = DateTime.now();
              DateTime attendanceDay = DateTime.utc(attendanceDate.year, attendanceDate.month, attendanceDate.day);
              DateTime thisDay = DateTime.utc(today.year, today.month, today.day);

              if(attendanceDay.isAtSameMomentAs(thisDay)){
                if(latestAttendance['in'] == '1'){
                  attendanceStatus = 'Present';
                  attendanceStatusColor = Colors.green;
                  attendanceStatusIcon = Icon(
                    Icons.check,
                    color: Colors.green,
                  );
                }else if(today.isBefore(attendanceDate)){
                  attendanceStatus = 'Soon';
                  attendanceStatusColor = Theme.of(context).accentColor;
                  attendanceStatusIcon = Icon(
                    Icons.brightness_low,
                    color: Theme.of(context).accentColor,
                    size: 18.0,
                  );
                }else if(today.isAfter(attendanceDate)){
                  attendanceStatus = 'Absent';
                }
              }else{
                attendanceStatus = 'Absent';
              }
            }
          } catch(e) {
            attendanceStatus = 'Absent';
          }

          if(attendanceStatus == 'Absent'){
            attendanceStatusColor = Colors.redAccent;
            attendanceStatusIcon = Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 18.0,
            );
          }
        }),
      getSchoolYearInformation()
        .then((results) {
          Map schoolYearInformation = results[results.length - 1]; // TODO: Verify which row to get, or if changes from year to year or new one will be added.
          DateTime yearStart = DateTime.parse(schoolYearInformation['quarter_start']);
          DateTime yearEnd = DateTime.parse(schoolYearInformation['quarter_end']);

          yearStartDay = DateTime(yearStart.year, yearStart.month, yearStart.day);
          yearEndDay = DateTime(yearEnd.year, yearEnd.month, yearEnd.day);

          schoolYearStart = yearStartDay.year.toString();
          schoolYearEnd = yearEndDay.year.toString();
        })
    ]);
  }

  void transformActivityList(classId) async {
    monthActivities = {};
    activityNames = [];

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

    try {
      nextEventMonth = activityNames[0];
      nextEventDay = monthActivities[activityNames[0]][0].day;
    } catch(e){}
  }

  @override
  void initState(){
    super.initState();

    monthActivities = {};
    activityNames = [];

    transformActivityList(widget.classId);
    getAttendanceInfo(widget.heroTag);
  }

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
                              IconButton(
                                icon: Icon(Icons.close),
                                color: Color.fromRGBO(255, 255, 255, .75),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                splashColor: Colors.white,
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
                                              '${this.widget.lastName ?? ""}, ${this.widget.firstName ?? ""}',
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
                                          '${widget.gradeLevel} - ${widget.gradeSection}',
                                          style: TextStyle(
                                              color: Colors.white
                                          ),
                                        ),
                                        Text(
                                          'S.Y. ${schoolYearStart ?? ""}-${schoolYearEnd ?? ""}',
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
                                          padding: EdgeInsets.symmetric(vertical: 12.0),
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
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            attendanceStatusIcon,
                                                            Padding(
                                                              padding: EdgeInsets.only(left: 4.0),
                                                              child: Text(
                                                                attendanceStatus,
                                                                style: TextStyle(
                                                                  color: attendanceStatusColor,
                                                                  fontSize: 16.0,
                                                                  fontWeight: FontWeight.w700
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          '$presentDaysNo/${totalSchoolDays.floor()}',
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
                                                          nextEventMonth ?? '',
                                                          style: TextStyle(
                                                              color: Colors.black38,
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.w600
                                                          ),
                                                        ),
                                                        Text(
                                                          nextEventDay ?? '',
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
                                          userId: this.widget.heroTag,
                                          schoolDays: this.schoolDays,
                                          presentDays: this.presentDays,
                                          noSchoolDays: this.noSchoolDays,
                                          specialSchoolDays: this.specialSchoolDays,
                                          yearStartDay: this.yearStartDay,
                                          yearEndDay: this.yearEndDay,
                                          presentDaysNo: this.presentDaysNo,
                                          pastSchoolDays: this.pastSchoolDays,
                                          absentDays: this.absentDays,
                                          totalSchoolDays: this.totalSchoolDays,
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
                                      onTap: (lname, fname, schoolLevel, classId, gradeLevel, gradeSection) {
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
                                          widget.gradeLevel = gradeLevel;
                                          widget.gradeSection = gradeSection;
                                          transformActivityList(widget.classId);
                                          sortActivityNames();
                                          getAttendanceInfo(widget.heroTag);
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