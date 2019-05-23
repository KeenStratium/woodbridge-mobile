import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;

class Attendance extends StatelessWidget {
  final String firstName;
  final String lastName;

  Attendance({
    this.firstName,
    this.lastName,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attendance'),
        ),
        resizeToAvoidBottomInset: false,
        body: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Column(
                children: <Widget>[
                  ProfileHeader(
                    firstName: this.firstName,
                    lastName: this.lastName,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: double.infinity,
                          maxHeight: 90.0
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BrandTheme.cardShadow],
                            borderRadius: BorderRadius.all(Radius.circular(7.0))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Flex(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Days Present',
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87
                                      ),
                                    ),
                                    Text(
                                      '38',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: double.infinity,
                                width: 1.0,
                                color: Colors.black12,
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'School Days',
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87
                                      ),
                                    ),
                                    Text(
                                      '44',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: double.infinity,
                                width: 1.0,
                                color: Colors.black12,
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Days Absent',
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87
                                      ),
                                    ),
                                    Text(
                                      '6',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                  child: CalendarCarousel(
                    weekdayTextStyle: TextStyle(
                      color: Colors.grey[600]
                    ),
                    weekendTextStyle: TextStyle(
                      color: Colors.redAccent
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}