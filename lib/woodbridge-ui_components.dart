import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';

String _avatarUrl;
List<String> _topics;

void setAvatarUrl(url) {
  _avatarUrl = url;
}

String getAvatarUrl() {
  return _avatarUrl;
}

void setTopics(List<String> topics) {
  _topics = topics;
}

List<String> getTopics(){
  return _topics;
}

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
  final String avatarUrl;
  bool enableShadow;
  bool hasPhoto = false;
  double minRadius = null;

  Avatar({
    this.backgroundColor,
    this.maxRadius,
    this.initial,
    this.fontSize,
    this.minRadius,
    this.enableShadow,
    this.avatarUrl
  });

  @override
  Widget build(BuildContext context) {
    if(enableShadow == null){
      enableShadow = true;
    }
    if(avatarUrl != null){
      hasPhoto = true;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100.0)),
        boxShadow: enableShadow ? [BoxShadow(
          color: Color.fromRGBO(0, 0, 0, .55),
          blurRadius: 12.0,
          offset: Offset(2.0, 3.0),
          spreadRadius: -1.0
        )] : [],
      ),
      child: !hasPhoto ? CircleAvatar(
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
      ) : CircleAvatar(
        child: Container(),
        backgroundColor: Colors.white,
        maxRadius: this.maxRadius,
        minRadius: this.minRadius,
        backgroundImage: NetworkImage(avatarUrl),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String firstName;
  final String lastName;
  String heroTag;

  ProfileHeader({
    Key key,
    this.firstName,
    this.lastName,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
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
  bool isDisabled = false;

  CtaButton({
    this.onPressed,
    this.label,
    this.color,
    this.isDisabled
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        color: isDisabled ? Colors.grey[200] : color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0))
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: isDisabled ? Colors.black54 : Colors.white
          ),
        ),
        onPressed: (() {
          isDisabled ? null : onPressed();
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
  bool isDisabled;

  accentCtaButton({
    this.onPressed,
    this.label,
    this.isDisabled
  });

  @override
  Widget build(BuildContext context) {
    if(isDisabled == null){
      isDisabled = false;
    }
    return CtaButton(
      label: label,
      onPressed: onPressed,
      color: Theme.of(context).accentColor,
      isDisabled: isDisabled
    );
  }
}

class StudentAvatarPicker extends StatefulWidget{
  final userId;
  final heroTag;
  bool enableShadow;
  bool isActive;
  var onTap;

  StudentAvatarPicker({
    Key key,
    this.userId,
    this.onTap,
    this.heroTag,
    this.isActive,
    this.enableShadow
  }) : super(key: key);

  @override
  _StudentAvatarPickerState createState() => _StudentAvatarPickerState();
}

class _StudentAvatarPickerState extends State<StudentAvatarPicker> {
  String fname;
  String lname;
  String schoolLevel; // TODO: Verify if school level is 's_grade_level' or 's_school'
  String classId;
  String gradeLevel;
  String gradeSection;
  String avatarUrlExt;
  String avatarUrl;

  void getStudent(userId) async {
    await _getStudentInfo(userId)
      .then((data) {
        Map student = data[0];

        setState(() {
          fname = student['s_fname'] ?? null;
          lname = student['s_lname'] ?? null;
          schoolLevel = student['s_grade_level'];
          classId = student['class_id'];
          gradeLevel = student['s_grade_level'];
          gradeSection = student['class_name'];
          avatarUrlExt = student['s_img'];
          if(avatarUrlExt != null){
            avatarUrl = '$baseServer/$avatarUrlExt';
          }
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
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
            color: widget.isActive ? Theme.of(context).accentColor : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
            boxShadow: [BrandTheme.cardShadow]
        ),
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
                            widget.isActive ? Center(
                              child: CircleAvatar(
                                maxRadius: 46.0,
                                backgroundColor: Colors.white,
                              ),
                            ) : Container(),
                            Center(
                              child: Avatar(
                                backgroundColor: Colors.indigo,
                                maxRadius: 41.0,
                                fontSize: 24.0,
                                initial: "$fInitial$lInitial",
                                enableShadow: widget.enableShadow,
                                avatarUrl: avatarUrl,
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

class InputRadioButton extends StatefulWidget {
  int radioValue;
  final List<String> radioValueLabels;
  final String label;
  String direction;
  var onChangeCallback;

  InputRadioButton({
    this.radioValue,
    this.radioValueLabels,
    this.label,
    this.direction,
    this.onChangeCallback
  });

  @override
  _InputRadioButtonState createState() => _InputRadioButtonState();
}

class _InputRadioButtonState extends State<InputRadioButton> {
  List<Widget> listWidgets() {
    List<Widget> radioLabelWidgets = new List();

    for(int i = 0; i < widget.radioValueLabels.length; i++){
      final String label = widget.radioValueLabels[i];

      radioLabelWidgets.add(
        Expanded(
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
        )
      );
    }

    return radioLabelWidgets;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.direction == null){
      widget.direction = 'row';
    }
    if(widget.onChangeCallback == null){
      widget.onChangeCallback = (value) {};
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              '${widget.label}: ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
                color: Colors.black54
              )
            ),
          ),
          Flex(
            direction: widget.direction == 'row' ? Axis.horizontal : Axis.vertical,
            children: listWidgets()
          ),
        ],
      )
    );
  }
}

Future<List> _getStudentInfo(userId) async {
  String url = '$baseApi/student/get-student';

  var response = await http.post(url, body: json.encode({
    'data': userId
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });
  return jsonDecode(response.body);
}