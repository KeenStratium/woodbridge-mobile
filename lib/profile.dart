import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';


class Profile extends StatelessWidget {
  final String heroTag;
  final String firstName;
  final String lastName;

  Profile({
    this.heroTag,
    this.firstName,
    this.lastName
  });

  @override
  Widget build(BuildContext context) {
    String fInitial;
    String lInitial;

    try {
      fInitial = firstName != null ? firstName[0] ?? '' : '';
    } catch(e) {
      fInitial = '';
    }

    try {
      lInitial = lastName != null ? lastName[0] ?? '' : '';
    } catch(e) {
      lInitial = '';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 28.0),
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: heroTag,
                    child: Avatar(
                      backgroundColor: Colors.indigo,
                      maxRadius: 48.0,
                      minRadius: 20.0,
                      fontSize: 20.0,
                      initial: "$fInitial$lInitial",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  Text(
                    '$lastName, $firstName',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20.0,
                      color: Theme.of(context).accentColor
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: AlignmentDirectional.topStart,
              margin: EdgeInsets.only(bottom: 28.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Basic Information',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700
                ),
              ),
            ),
            Divider(height: 1.0, color: Colors.grey[300]),
            Flexible(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    ProfileField(
                      fieldValue: 'Male',
                      fieldLabel: 'Gender',
                    ),
                    ProfileField(
                      fieldValue: 'Sample Address',
                      fieldLabel: 'Address',
                    ),
                    ProfileField(
                      fieldValue: '123-4567',
                      fieldLabel: 'Tel. No.',
                    ),
                    ProfileField(
                      fieldValue: 'December 1, 2014',
                      fieldLabel: 'Birthday',
                    ),
                    ProfileField(
                      fieldValue: 'Bacolod City',
                      fieldLabel: 'Place of Birth',
                    ),
                    ProfileField(
                      fieldValue: 'Filipino',
                      fieldLabel: 'Citizenship',
                    ),
                    ProfileField(
                      fieldValue: 'Catholic',
                      fieldLabel: 'Religion',
                    ),
                  ]
                ).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatefulWidget {
  final String fieldValue;
  final String fieldLabel;

  ProfileField({
    Key key,
    this.fieldValue,
    this.fieldLabel,
  });

  @override
  _ProfileFieldState createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.fieldValue),
      subtitle: Text(widget.fieldLabel),
    );
  }
}