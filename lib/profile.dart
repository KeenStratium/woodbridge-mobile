import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

Future<Map> fetchProfileInformation(userId) async {
  String url = '$baseApi/student/get-profile-info';

  var response = await http.post(url, body: json.encode({
    'data': userId
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body);
}

class Profile extends StatefulWidget {
  final String heroTag;
  final String firstName;
  final String lastName;

  Profile({
    this.heroTag,
    this.firstName,
    this.lastName
  });

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map profileInfo;

  @override
  Widget build(BuildContext context) {
    String fInitial;
    String lInitial;

    List<Widget> profileSections = <Widget>[];

    try {
      fInitial = widget.firstName != null ? widget.firstName[0] ?? '' : '';
    } catch(e) {
      fInitial = '';
    }

    try {
      lInitial = widget.lastName != null ? widget.lastName[0] ?? '' : '';
    } catch(e) {
      lInitial = '';
    };

    void _buildProfileFields() {
      profileInfo.forEach((label, value) {
        String prevSectionType = 'normal';
        List<Widget> sectionFields = <Widget>[];

        if(value is Map){
          value.forEach((label, value) {
            if(value is String){
              sectionFields.add(
                ProfileField(
                  fieldValue: value,
                  fieldLabel: label,
                )
              );
            }else if(value is List){
              if(prevSectionType != 'multi-field'){
                sectionFields.add(
                    Padding(padding: EdgeInsets.symmetric(vertical: 10.0))
                );
              }
              prevSectionType = 'multi-field';
              sectionFields.add(
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    child: Text(
                      label,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87
                      ),
                    ),
                  )
              );
              value.forEach((valueObj) {
                List<Widget> sectionListFields = <Widget>[];
                if(valueObj is Map){
                  valueObj.forEach((objLabel, objValue) {
                    if(objValue != ''){
                      sectionListFields.add(
                        Flexible(
                          flex: objLabel == 'Age' ? 1 : 3,
                          child: ProfileField(
                            fieldValue: objValue,
                            fieldLabel: objLabel,
                          ),
                        )
                      );
                    }
                  });
                  sectionFields.add(
                    Flex(
                      direction: Axis.horizontal,
                      children: sectionListFields
                    )
                  );
                }else if(valueObj is String){
                  sectionFields.add(
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      child: Text(
                        valueObj,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black45
                        ),
                      ),
                    )
                  );
                }
              });
              sectionFields.add(
                Padding(padding: EdgeInsets.symmetric(vertical: 10.0))
              );
            }
          });

          profileSections.add(
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Flexible(
                    flex: 0,
                    child: Container(
                      alignment: AlignmentDirectional.topStart,
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 1.0, color: Colors.grey[300]),
                  Flexible(
                    flex: 0,
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: sectionFields
                      ).toList(),
                    ),
                  )
                ],
              ),
            ),
          );
        }else if(value is String){
          sectionFields.add(
            ProfileField(
              fieldValue: value,
              fieldLabel: label,
            )
          );
        }
      });
    }

    Future<List<Widget>> getProfileInformation(userId) async {
      await fetchProfileInformation(userId)
        .then((result) {
          profileInfo = result;
          _buildProfileFields();
       });
      return profileSections;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 28.0),
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: widget.heroTag,
                      child: Avatar(
                        backgroundColor: Colors.indigo,
                        maxRadius: 48.0,
                        minRadius: 20.0,
                        fontSize: 20.0,
                        initial: "$fInitial$lInitial",
                        enableShadow: false,
                        avatarUrl: getAvatarUrl(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    Text(
                      '${widget.lastName}, ${widget.firstName}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                        color: Theme.of(context).accentColor
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: getProfileInformation(widget.heroTag),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    return Column(
                      children: snapshot.data,
                    );
                  }else{
                    return Text('fetching profile information...');
                  }
                },
              ),
            ],
          ),
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
      title: Text(widget.fieldValue, softWrap: true),
      subtitle: Text(widget.fieldLabel, softWrap: true),
    );
  }
}