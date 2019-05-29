import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class BrandTheme {
  static final BoxShadow cardShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, .25),
    blurRadius: 5.0,
    offset: Offset(1.0, 1.0),
    spreadRadius: -2.0
  );
}

class Avatar extends StatelessWidget {
  final Color backgroundColor;
  final double maxRadius;
  final String initial;
  final double fontSize;
  double minRadius = null;

  Avatar({
    this.backgroundColor,
    this.maxRadius,
    this.initial,
    this.fontSize,
    this.minRadius
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
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
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String firstName;
  final String lastName;

  ProfileHeader({
    Key key,
    this.firstName,
    this.lastName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
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
                '${this.firstName} ${this.lastName}',
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
    );
  }
}

class DashboardTile extends StatelessWidget {
  final String label;
  final String value;
  final Widget child;
  final bool displayPlainValue;

  DashboardTile({
    Key key,
    this.label,
    // ignore: avoid_init_to_null
    this.child: null,
    // ignore: avoid_init_to_null
    this.value: null,
    this.displayPlainValue: false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            this.label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              color: Colors.grey[600]
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
          ),
          displayPlainValue ? Text(
            this.value,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).accentColor
            ),
          ) : this.child,
        ],
      ),
    );
  }

}

class CtaButton extends FlatButton {
  String label;
  var onPressed;
  Color color;

  CtaButton({
    this.onPressed,
    this.label,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0))
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 16.0,
              color: Colors.white
          ),
        ),
        onPressed: (() {
          onPressed();
        }),
        padding: EdgeInsets.symmetric(vertical: 20.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class accentCtaButton extends FlatButton {
  String label;
  var onPressed;

  accentCtaButton({
    this.onPressed,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return CtaButton(
      label: label,
      onPressed: onPressed,
      color: Theme.of(context).accentColor
    );
  }
}

class StudentAvatarPicker extends StatefulWidget{
  final userId;
  final heroTag;
  bool isActive;
  var onTap;

  StudentAvatarPicker({
    Key key,
    this.userId,
    this.onTap,
    this.heroTag,
    this.isActive
  }) : super(key: key);

  @override
  _StudentAvatarPickerState createState() => _StudentAvatarPickerState();
}

class _StudentAvatarPickerState extends State<StudentAvatarPicker> {
  String fname;
  String lname;
  String schoolLevel; // TODO: Verify if school level is 's_grade_level' or 's_school'

  void getStudent(userId) async {
    await _getStudentInfo(userId)
      .then((data) {
        setState(() {
          fname = data['s_fname'] ?? null;
          lname = data['s_lname'] ?? null;
          schoolLevel = data['s_grade_level'];
        });
      });
  }

  @override
  void initState() {
    super.initState();

    getStudent(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    String fInitial;
    String lInitial;
    Color avatarColor = widget.isActive ? Theme.of(context).accentColor : Colors.white;

    try {
      fInitial = fname != null ? fname[0] ?? '' : '';
    } catch(e) {
      fInitial = '';
    }

    try {
      lInitial = lname != null ? lname[0] ?? '' : '';
    } catch(e) {
      lInitial = '';
    }

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
        decoration: BoxDecoration(
            color: widget.isActive ? Theme.of(context).accentColor : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
            boxShadow: [BrandTheme.cardShadow]
        ),
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
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
                        return widget.onTap(lname, fname, schoolLevel);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: avatarColor,
                        ),
                        child: Stack(
                          children: <Widget>[
                            widget.isActive ? Center(
                              child: CircleAvatar(
                                maxRadius: 46.0,
                                backgroundColor: Colors.white,
                              ),
                            ) : Container(),
                            Center(
                              child: Avatar(
                                backgroundColor: Colors.indigo,
                                maxRadius: widget.isActive ? 41.0 : 48.0,
                                fontSize: 24.0,
                                initial: "$fInitial$lInitial",
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
              flex: 1,
              child: SizedBox(
                height: 16.0,
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              flex: 2,
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
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<Map> _getStudentInfo(userId) async {
  String url = 'http://54.169.38.97:4200/api/student/get-student';

  var response = await http.post(url, body: json.encode({
    'data': userId
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });
  return jsonDecode(response.body)[0];
}