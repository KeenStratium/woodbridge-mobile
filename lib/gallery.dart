import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'GalleryDetail.dart';

class PhotoCard extends StatelessWidget {
  GlobalKey stickyKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 52.0),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '8:21am',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
              ],
            ),
          ),
          Flexible(
            flex: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6.0),
              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(11.0),
                  topRight: Radius.circular(11.0)
                ),
                boxShadow: [BoxShadow(
                  blurRadius: 26.0, 
                  spreadRadius: -6.0,
                  color: Color.fromRGBO(0, 0, 0, .12),
                  offset: Offset(1.0, 3.0)
                )]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 12.0),
                    child: Text(
                      '"one love" drawing by kindergarten project. What a phenomenal art!',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).accentColor
                      )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Teacher Lulu',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 200.0),
                child: Container(
                alignment: Alignment(1.0, 1.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  boxShadow: [BoxShadow(
                    blurRadius: 38.0, 
                    spreadRadius: -8.0,
                    color: Color.fromRGBO(0, 0, 0, .65),
                    offset: Offset(2.0, 5.0)
                  )]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(9.0)),
                  child: Image.network(
                    'https://imageoptimizer.in/optimize/uploads/p9ygh.jpeg',
                    fit: BoxFit.fitWidth
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityGallery extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String userId;

  ActivityGallery({
    this.firstName,
    this.lastName,
    this.userId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Gallery'),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Flexible(
                flex: 0,
                child: ProfileHeader(
                  firstName: this.firstName,
                  lastName: this.lastName,
                  heroTag: this.userId,
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  padding: EdgeInsets.only(bottom: 40.0),
                  margin: EdgeInsets.symmetric(horizontal: 6.0),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      PhotoCard(),
                      PhotoCard()
                    ],
                  ),
                )
              )
            ],
          ),
        )
      ),
    );
  }
}