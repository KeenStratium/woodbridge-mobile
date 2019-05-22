import 'package:flutter/material.dart';

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
              color: Colors.grey[700]
            ),
          ),
          displayPlainValue ? Text(
            this.value,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: Colors.grey[900]
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