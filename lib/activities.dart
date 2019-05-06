import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

class ActivityEvent {
  String title;
  String venue;
  String time;
  String day;
  String weekday;

  ActivityEvent({this.title, this.venue, this.time, this.day, this.weekday});
}

List<ActivityEvent> events = <ActivityEvent>[
  ActivityEvent(
      title: 'Event title 1',
      venue: 'Multi-purpose Gym',
      time: '8:00am',
      day: '02',
      weekday: 'Tue'
  ),
  ActivityEvent(
      title: 'Event title 2',
      venue: 'Carmelite Hall',
      time: '9:30am',
      day: '02',
      weekday: 'Tue'
  ),
  ActivityEvent(
      title: 'Event title 3',
      venue: 'Multi-purpose Gym',
      time: '8:00am',
      day: '04',
      weekday: 'Thu'
  ),
  ActivityEvent(
      title: 'Event title 4',
      venue: 'Multi-purpose Gym',
      time: '1:30pm',
      day: '04',
      weekday: 'Fri'
  ),
  ActivityEvent(
      title: 'Event title 5',
      venue: 'Multi-purpose Gym',
      time: '1:30pm',
      day: '04',
      weekday: 'Fri'
  ),
  ActivityEvent(
      title: 'Event title 6',
      venue: 'Multi-purpose Gym',
      time: '1:30pm',
      day: '04',
      weekday: 'Fri'
  ),
];

class Activities extends StatelessWidget {
  final String firstName;
  final String lastName;

  Activities({
    this.firstName,
    this.lastName
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar of Activities'),
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            ProfileHeader(
              firstName: this.firstName,
              lastName: this.lastName,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'January',
                        style: TextStyle(
                            fontSize: 18.0,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: events.length,
                        itemExtent: 96.0,
                        cacheExtent: 96.0,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              height: 80.0,
                              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[200],
                                  width: 1.00
                                )
                              ),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 24.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          events[index].day,
                                          style: TextStyle(
                                            fontSize: 24.0
                                          ),
                                        ),
                                        Text(events[index].weekday,)
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          events[index].title,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(events[index].time),
                                            Text('/'),
                                            Text(events[index].venue)
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }

}