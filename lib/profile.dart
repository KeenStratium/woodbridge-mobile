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
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Male'
                        ),
                        autofocus: true,
                      ),
                    ),
                    ProfileField(
                      fieldValue: 'Sample Address',
                      fieldLabel: 'Address',
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Sample Address'
                        ),
                        autofocus: true,
                      ),
                    ),
                    ProfileField(
                      fieldValue: '123-4567',
                      fieldLabel: 'Tel. No.',
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: '123-4567'
                        ),
                        autofocus: true,
                      ),
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
  final Widget child;
  String updateLabel;

  ProfileField({
    Key key,
    this.fieldValue,
    this.fieldLabel,
    this.child,
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
              return AlertDialog(
                title: Text(widget.updateLabel),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)
                ),
                content: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: widget.child
                    )
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[700]
                      ),
                    ),
                    textTheme: ButtonTextTheme.normal,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    textTheme: ButtonTextTheme.accent,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
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