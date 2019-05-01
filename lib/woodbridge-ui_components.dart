import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String profileName;

  ProfileHeader({
    Key key,
    this.profileName,
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
                this.profileName,
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