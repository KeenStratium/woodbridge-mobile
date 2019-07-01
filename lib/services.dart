import 'package:intl/intl.dart';

String timeFormat(unformattedTime, format){
  String time;
  DateFormat formatter = DateFormat(format ?? 'MMMM d, yyyy');

  time = unformattedTime != null ? formatter.format(DateTime.parse(unformattedTime)) : time = '';

  return time;
}

String formatMilitaryTime(time) {
  String meridiem = 'am';
  List<String> timeClockStr = time.split(':');
  int hour = int.parse(timeClockStr[0]);
  int minutes = int.parse(timeClockStr[1]);
  String hourStr;
  String minuteStr = '${minutes < 10 ? '0': ''}${minutes}';

  if(hour > 12){
    meridiem = 'pm';
    hour -= 12;
  }else if(hour == 0){
    hour = 12;
  }
  hourStr = hour.toString();

  return '$hourStr:$minuteStr$meridiem';
}

String localCurrencyFormat(double amount){
  return '₱${amount + 0.00}';
}