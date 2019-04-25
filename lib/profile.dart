import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
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
              alignment: AlignmentDirectional.topStart,
              padding: EdgeInsets.symmetric(vertical: 28.0, horizontal: 20.0),
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
  String updateLabel;

  ProfileField({
    Key key,
    this.fieldValue,
    this.fieldLabel,
  }) : super (key: key){
    this.updateLabel = 'Update $fieldLabel';
  }

  @override
  _ProfileFieldState createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.fieldValue),
      subtitle: Text(widget.fieldLabel),
      trailing: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return SimpleDialog(
                title: Text(widget.updateLabel),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)
                ),
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text('Close'),
                  )
                ],
                semanticLabel: widget.updateLabel,
              );
            }
          );
        },
        icon: Icon(Icons.edit)
      ),
    );
  }
}