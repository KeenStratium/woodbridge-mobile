import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: Container(
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
              Expanded(
//                fit: FlexFit.loose,
                flex: 1,
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      ListTile(
                        title: Text('Male'),
                        subtitle: Text('Gender'),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.edit)
                        ),
                      ),
                      ListTile(
                        title: Text('Male'),
                        subtitle: Text('Gender'),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.edit)
                        ),
                      ),
//                        Profile()
                    ]
                  ).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileField extends StatefulWidget {
  ProfileField({Key key}) : super (key: key);

  @override
  _ProfileFieldState createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Male'),
      subtitle: Text('Gender'),
      trailing: Icon(Icons.edit),
    );
  }
}