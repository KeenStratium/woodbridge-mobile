import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';


class ActivityEvent {
  String title;
  String venue;
  String time;
  String day;
  String weekday;

  ActivityEvent({this.title, this.venue, this.time, this.day, this.weekday});
}

List<ActivityEvent> may = <ActivityEvent>[
  ActivityEvent(
    title: 'Event title 1',
    venue: 'Multi-purpose Gym Multi-purpose Gym',
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

List<ActivityEvent> june = <ActivityEvent>[
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

List<ActivityEvent> july = <ActivityEvent>[
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

List<ActivityEvent> august = <ActivityEvent>[
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

List<List<ActivityEvent>> monthActivities = <List<ActivityEvent>>[
  may, june, july, august
];

List<Widget> _buildLists(BuildContext context, int firstIndex, int count) {
  return List.generate(count, (sliverIndex) {
    sliverIndex += firstIndex;
    return new SliverStickyHeaderBuilder(
      builder: (context, state) => _buildHeader(context, sliverIndex, state),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, i) =>
          Container(
            margin: EdgeInsets.only(top: i == 0 ? 20.0 : 0.00, bottom: i == monthActivities[sliverIndex].length - 1 ? 20.00 : 0.00),
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              height: 80.0,
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              padding: EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                boxShadow: [BrandTheme.cardShadow],
              ),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            monthActivities[sliverIndex][i].day,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Theme.of(context).accentColor
                            ),
                          ),
                          Text(
                            monthActivities[sliverIndex][i].weekday,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black54
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          monthActivities[sliverIndex][i].title,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Flexible(
                              flex: 0,
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    size: 16.0,
                                    color: Colors.black54,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1.0),
                                  ),
                                  Text(
                                    monthActivities[sliverIndex][i].time,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      fontSize: 14.0
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.0),
                            ),
                            Expanded(
                              flex: 3,
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Flexible(
                                    flex: 0,
                                    child: Icon(
                                      Icons.location_on,
                                      size: 16.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 0,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 1.0),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        monthActivities[sliverIndex][i].venue,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                          fontSize: 14.0
                                      ),
                                ),
                                    ),
                                  ),
                              ],
                          ),
                            )
                        ],
                      )
                    ],
                  ),
                )
                ],
              ),
            ),
          ),
          childCount: monthActivities[sliverIndex].length,
        ),
      ),
    );
  });
}

Widget _buildHeader(BuildContext context, int index, SliverStickyHeaderState state, {String text}) {
  return new Container(
    height: 48.0,
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: Colors.grey[300],
          width: 1.0
        ),
        top: BorderSide(
          color: state.isPinned ? Colors.white : Colors.grey[300],
          width: 1.0
        )
      )
    ),
    child: new Text(
      text ?? 'Header #${index+1}',
      style: TextStyle(
        color: Colors.black87,
        fontSize: 16.0,
        fontWeight: FontWeight.w700
      ),
    ),
  );
}

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
            Flexible(
              child: Builder(builder: (BuildContext context) {
                return new CustomScrollView(
                  slivers: _buildLists(context, 0, monthActivities.length),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

}