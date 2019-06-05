import 'package:intl/intl.dart';

String timeFormat(unformattedTime){
  String time;
  DateFormat formatter = DateFormat('MMMM d, yyyy');
  time = unformattedTime != null ? formatter.format(DateTime.parse(unformattedTime)) : time = '';

  return time;
}