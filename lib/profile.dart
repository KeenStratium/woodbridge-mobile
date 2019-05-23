import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

class Profile extends StatelessWidget {
  final String heroTag;

  Profile({
    this.heroTag
  });

  @override
  Widget build(BuildContext context) {
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
                      initial: "KG",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  Text(
                    'Gargar, Keanu Kent B.',
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