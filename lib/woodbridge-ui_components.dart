import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

String _avatarUrl;
String _username;
List<Map> _topics = <Map>[];
Map _moduleUnreadCount = {};
String _nextPaymentDay;
String _nextPaymentMonth;
String _nextPaymentPackageNum;

LinearGradient overflowGradient() {
  return LinearGradient(begin: Alignment.centerRight, end: Alignment.center, stops: [
    0.0,
    .25
  ], colors: [
    Colors.white,
    Color.fromRGBO(255, 255, 255, 0),
  ]);
}

Map getNextPayment() {
  Map nextPayment = {
    'nextPaymentDay': _nextPaymentDay ?? '',
    'nextPaymentMonth': _nextPaymentMonth ?? '',
    'nextPaymentPackageNum': _nextPaymentPackageNum ?? '',
  };

  return nextPayment;
}

void setNextPayment(String day, String month, String packageNum) {
  _nextPaymentDay = day;
  _nextPaymentMonth = month;
  _nextPaymentPackageNum = packageNum;
}

void setModuleUnreadCount(String moduleName, int count, List<int> notifIds) {
  if (_moduleUnreadCount[moduleName] == null) {
    _moduleUnreadCount[moduleName] = 0;
  }

  _moduleUnreadCount[moduleName] = count;
}

void setAllUnreadCount(Map unread) {
  _moduleUnreadCount = unread;
}

void clearAllUnreadCount() {
  _moduleUnreadCount = {};
}

void setCategorySeen(String moduleName) {
  _moduleUnreadCount.remove(moduleName);
}

Map getModuleUnread() {
  return _moduleUnreadCount;
}

int getModuleUnreadCount(String moduleName) {
  var _module = _moduleUnreadCount[moduleName] ?? {};

  return _module['count'] ?? 0;
}

List getModuleUnreadNotifIds(String moduleName) {
  var _module = _moduleUnreadCount[moduleName] ?? {};

  return _module['notif_ids'] ?? [];
}

Map getAllUnreadCount() {
  return _moduleUnreadCount;
}

void setAvatarUrl(url) {
  _avatarUrl = url;
}

String getAvatarUrl() {
  return _avatarUrl;
}

void clearTopics() {
  _topics = <Map>[];
}

void addTopic(String topic, String id) {
  _topics.add({'s_id': id, 'topic': topic});
  _topics = _topics.toSet().toList();
}

List<Map> getTopics() {
  return _topics;
}

void setUsername(String username) {
  _username = username;
}

String getUsername() {
  return _username;
}

BoxShadow dynamicCardShadow(Color shadowColor) {
  return BoxShadow(color: shadowColor, blurRadius: 8.0, offset: Offset(0.0, 1.0), spreadRadius: -3.0);
}

class BrandTheme {
  static final BoxShadow cardShadow = BoxShadow(color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 5.0, offset: Offset(1.0, 1.0), spreadRadius: -2.0);
}

class Avatar extends StatelessWidget {
  Avatar({this.backgroundColor, this.maxRadius, this.initial, this.fontSize, this.minRadius, this.enableShadow, this.avatarUrl});

  final String avatarUrl;
  final Color backgroundColor;
  bool enableShadow;
  final double fontSize;
  bool hasPhoto = false;
  final String initial;
  final double maxRadius;
  double minRadius;

  @override
  Widget build(BuildContext context) {
    if (enableShadow == null) {
      enableShadow = true;
    }
    if (avatarUrl != null) {
      hasPhoto = true;
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
          boxShadow: enableShadow ? [BoxShadow(color: Color.fromRGBO(0, 0, 0, .15), blurRadius: 6.0, offset: Offset(0.0, 1.0), spreadRadius: 0.0)] : [],
          border: Border.all(width: 2.0, color: Colors.yellow)),
      child: !hasPhoto
          ? CircleAvatar(
              child: Text(
                this.initial ?? '',
                style: TextStyle(
                  fontSize: this.fontSize,
                ),
              ),
              backgroundColor: this.backgroundColor,
              foregroundColor: Colors.white,
              maxRadius: this.maxRadius,
              minRadius: this.minRadius,
            )
          : CircleAvatar(
              child: Container(),
              backgroundColor: Colors.white,
              maxRadius: this.maxRadius,
              minRadius: this.minRadius,
              backgroundImage: CachedNetworkImageProvider(avatarUrl),
            ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  ProfileHeader({
    Key key,
    this.firstName,
    this.lastName,
    this.heroTag,
  }) : super(key: key);

  final String firstName;
  final String heroTag;
  final String lastName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[300]), bottom: BorderSide(color: Colors.grey[300]))),
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: heroTag,
                child: Avatar(
                  enableShadow: false,
                  avatarUrl: _avatarUrl,
                  maxRadius: 20.0,
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                '${this.firstName} ${this.lastName}',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class DashboardTile extends StatelessWidget {
  DashboardTile(
      {Key key,
      this.label,
      // ignore: avoid_init_to_null
      this.child: null,
      // ignore: avoid_init_to_null
      this.value: null,
      // ignore: avoid_init_to_null
      this.color: null,
      this.displayPlainValue: false,
      this.isActive: true})
      : super(key: key);

  final Widget child;
  final bool displayPlainValue;
  final bool isActive;
  final String label;
  final String value;
  Color color;

  @override
  Widget build(BuildContext context) {
    if (color == null) {
      color = Theme.of(context).accentColor;
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            this.label,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
          ),
          displayPlainValue
              ? Text(
                  this.value,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: isActive ? color : Colors.grey[600]),
                )
              : this.child,
        ],
      ),
    );
  }
}

class CtaButton extends FlatButton {
  CtaButton({this.onPressed, this.label, this.color, this.isDisabled});

  Color color;
  bool isDisabled = false;
  String label;
  var onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        color: isDisabled ? Colors.grey[200] : color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
        child: Text(
          label,
          style: TextStyle(fontSize: 16.0, color: isDisabled ? Colors.black54 : Colors.white),
        ),
        onPressed: (() {
          if (isDisabled != null) {
            onPressed();
          }
        }),
        padding: EdgeInsets.symmetric(vertical: 20.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class accentCtaButton extends FlatButton {
  accentCtaButton({this.onPressed, this.label, this.isDisabled});

  bool isDisabled;
  String label;
  var onPressed;

  @override
  Widget build(BuildContext context) {
    if (isDisabled == null) {
      isDisabled = false;
    }
    return CtaButton(label: label, onPressed: onPressed, color: Theme.of(context).accentColor, isDisabled: isDisabled);
  }
}

class StudentAvatarPicker extends StatefulWidget {
  StudentAvatarPicker({Key key, this.userId, this.onTap, this.heroTag, this.isActive, this.enableShadow, this.hasUnreadNotif = false}) : super(key: key);

  bool enableShadow;
  final bool hasUnreadNotif;
  final heroTag;
  bool isActive;
  var onTap;
  final userId;

  @override
  _StudentAvatarPickerState createState() => _StudentAvatarPickerState();
}

class _StudentAvatarPickerState extends State<StudentAvatarPicker> {
  String avatarUrl;
  String avatarUrlExt;
  String classId;
  String fname;
  String gradeLevel;
  String gradeSection;
  String lname;
  String schoolLevel; // TODO: Verify if school level is 's_grade_level' or 's_school'

  @override
  void initState() {
    super.initState();

    getStudent(widget.userId);
  }

  void getStudent(userId) async {
    await _getStudentInfo(userId).then((data) {
      Map student = data[0];

      setState(() {
        fname = student['s_fname'] ?? null;
        lname = student['s_lname'] ?? null;
        schoolLevel = student['s_grade_level'];
        classId = student['class_id'];
        gradeLevel = student['s_grade_level'];
        gradeSection = student['class_name'];
        avatarUrlExt = student['s_img'];
        if (avatarUrlExt != null) {
          avatarUrl = '$baseServer/$avatarUrlExt';
        }
        addTopic(classId, student['s_id']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String fInitial;
    String lInitial;
    Color avatarColor = widget.isActive ? Theme.of(context).accentColor : Colors.white;

    try {
      fInitial = fname != null ? fname[0] ?? '' : '';
    } catch (e) {
      fInitial = '';
    }

    try {
      lInitial = lname != null ? lname[0] ?? '' : '';
    } catch (e) {
      lInitial = '';
    }

    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(color: widget.isActive ? Theme.of(context).accentColor : Colors.white, borderRadius: BorderRadius.all(Radius.circular(7.0)), boxShadow: [BrandTheme.cardShadow]),
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 4,
                  child: Hero(
                    tag: widget.heroTag ?? widget.userId,
                    child: Material(
                      child: Container(
                        decoration: BoxDecoration(
                          color: avatarColor,
                        ),
                        child: InkWell(
                          onTap: () {
                            return widget.onTap(lname, fname, schoolLevel, classId, gradeLevel, gradeSection, avatarUrl);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: avatarColor,
                            ),
                            child: Stack(
                              children: <Widget>[
                                widget.isActive
                                    ? Center(
                                        child: CircleAvatar(
                                          maxRadius: 41.0,
                                          backgroundColor: Colors.white,
                                        ),
                                      )
                                    : Container(),
                                Center(
                                  child: AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Avatar(
                                      backgroundColor: Colors.indigo,
                                      maxRadius: 41.0,
                                      fontSize: 24.0,
                                      initial: "$fInitial$lInitial",
                                      enableShadow: widget.enableShadow,
                                      avatarUrl: avatarUrl,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 0,
                  child: SizedBox(
                    height: 2.0,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                        width: 128.0,
                        child: Text(
                          '${fname ?? ''}',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: widget.isActive ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
          widget.hasUnreadNotif
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.red[700], borderRadius: BorderRadius.circular(24.0)),
                    constraints: BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class InputRadioButton extends StatefulWidget {
  InputRadioButton({this.radioValue, this.radioValueLabels, this.label, this.direction, this.onChangeCallback});

  String direction;
  final String label;
  var onChangeCallback;
  int radioValue;
  final List<String> radioValueLabels;

  @override
  _InputRadioButtonState createState() => _InputRadioButtonState();
}

class _InputRadioButtonState extends State<InputRadioButton> {
  List<Widget> listWidgets() {
    List<Widget> radioLabelWidgets = new List();

    for (int i = 0; i < widget.radioValueLabels.length; i++) {
      final String label = widget.radioValueLabels[i];

      radioLabelWidgets.add(Expanded(
        flex: widget.direction == 'row' ? 1 : 0,
        child: RadioListTile(
          onChanged: (value) {
            setState(() {
              widget.radioValue = value;
            });
            widget.onChangeCallback(value);
          },
          value: i,
          groupValue: widget.radioValue,
          title: Text(label),
        ),
      ));
    }

    return radioLabelWidgets;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.direction == null) {
      widget.direction = 'row';
    }
    if (widget.onChangeCallback == null) {
      widget.onChangeCallback = (value) {};
    }
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text('${widget.label}: ', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0, color: Colors.black54)),
        ),
        Flex(direction: widget.direction == 'row' ? Axis.horizontal : Axis.vertical, children: listWidgets()),
      ],
    ));
  }
}

class PaginationControl extends StatefulWidget {
  PaginationControl({this.pageNum, this.prevCallback, this.nextCallback, this.nextDisableCondition});

  var nextCallback;
  bool nextDisableCondition;
  int pageNum;
  var prevCallback;

  @override
  _PaginationControlState createState() => _PaginationControlState();
}

class _PaginationControlState extends State<PaginationControl> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[300]))),
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
              onPressed: widget.pageNum > 1
                  ? () {
                      widget.prevCallback();
                    }
                  : null,
            ),
          ),
          Text(
            'Page ${widget.pageNum}',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.0, color: Colors.grey[600]),
          ),
          Material(
            color: Colors.white,
            child: IconButton(
              icon: Icon(Icons.chevron_right),
              color: Colors.grey[700],
              tooltip: 'Next',
              highlightColor: Theme.of(context).accentColor,
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              onPressed: widget.nextDisableCondition
                  ? null
                  : () async {
                      widget.nextCallback();
                    },
            ),
          )
        ],
      ),
    );
  }
}

Future<List> _getStudentInfo(userId) async {
  String url = '$baseApi/student/get-student';

  var response = await http.post(url, body: json.encode({'data': userId}), headers: {'Accept': 'application/json', 'Content-Type': 'application/json'});
  return jsonDecode(response.body);
}
