import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

Map profileInformation = {
  'Basic Information': {
    'gender': 'Male',
    'Address': 'Sample Address',
    'Tel. No.': '123-4567',
    'Birthday': 'December 1, 2014',
    'Place of Birth':'Bacolod City',
    'Citizenship': 'Filipino',
    'Religion': 'Catholic'
  },
  'Prior Schooling': {
    'S.Y. 2014 - 2015': 'School Name'
  },
  'Family Background': {
    "Father's Name": 'Daniel Padilla Sr.',
    "Father's Age": '29',
    "Father's Home Address": 'Home Address',
    "Father's Business Address": 'Business Address',
    "Father's Tel. No.": '123-4567',
    "Father's Mobile No.": '09289065696',
    "Father's Email Address": 'kevinklinegargar@gmail.com',
    "Father's Home Address": 'Home Address',
    "Mother's Name": 'Mrs. Daniel Padilla Sr.',
    "Mother's Age": '25',
    "Mother's Home Address": 'Home Address',
    "Mother's Business Address": 'Business Address',
    "Mother's Tel. No.": '123-4567',
    "Mother's Mobile No.": '09289065696',
    "Mother's Email Address": 'msdanielpaddila@gmail.com',
    "Mother's Home Address": 'Home Address',
    "Child's legal guardian": 'Kevin Kline Gargar',
    "Child's siblings": [
      {
        'Sibling #1': 'Keanu Kent Gargar',
        'Age': '22',
      },
      {
        'Sibling #2': 'Kefir Kion Gargar',
        'Age': '5'
      }
    ],
    "Assigned to pickup your child from school": [
      {
        'Assigned #1': 'Kevin Gargar',
        'Relationship': 'Father'
      },
      {
        'Assigned #2': 'Anne Marie Gargar',
        'Relationship': 'Mother'
      }
    ]
  },
  'Health & History': {
    "Child's current medications": "Medication #1, Medication #2",
    "Medication purposes": "Medcation purpose"
  },
  'Other information': {
    'Activities that interests your child': 'Football, Army, Fireman',
    "Child's preferred toys": 'LEGO, Building Blocks, Puzzles',
    "How child usually spend his/her day": 'Playing toys and games, watching kids youtube',
    "School experience expectations": 'Able to nurture',
    "Other concerns regarding child": 'N/A'
  }
};

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

    List<Widget> profileSections = <Widget>[];

    try {
      fInitial = firstName != null ? firstName[0] ?? '' : '';
    } catch(e) {
      fInitial = '';
    }

    try {
      lInitial = lastName != null ? lastName[0] ?? '' : '';
    } catch(e) {
      lInitial = '';
    };
    
    profileInformation.forEach((label, value) {
      print(label);
      if(value is Map){
        value.forEach((label, value) {
          print('$label: $value');
        });
      }else if(value is String){
        print(value);
      }
    });

    void _buildProfileFields() {
      profileInformation.forEach((label, value) {
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

              sectionFields.add(
                Padding(padding: EdgeInsets.symmetric(vertical: 10.0))
              );
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

                valueObj.forEach((objLabel, objValue) {
                  sectionListFields.add(
                    Flexible(
                      flex: objLabel == 'Age' ? 1 : objLabel == 'Relationship' ? 2 : 3,
                      child: ProfileField(
                        fieldValue: objValue,
                        fieldLabel: objLabel,
                      ),
                    )
                  );
                });
                sectionFields.add(
                  Flex(
                    direction: Axis.horizontal,
                    children: sectionListFields
                  )
                );
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

    _buildProfileFields();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
              Column(
                children: profileSections
              )
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