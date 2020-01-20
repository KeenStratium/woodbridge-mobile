import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

List<String> dayNames = <String>['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
List<String> monthNames = <String>['January', 'February', 'March', 'April','May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

String localCurrencyFormat(double amount){
  return '₱${amount + 0.00}'.replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
}

String timeFormat(unformattedTime, format){
  String time;
  DateFormat formatter = DateFormat(format ?? 'MMMM d, yyyy');

  time = unformattedTime != null ? formatter.format(DateTime.parse(unformattedTime).toLocal()) : time = '';

  return time;
}

String formatMilitaryTime(time) {
  String meridiem = 'am';
  List<String> timeClockStr = time.split(':');
  int hour = int.parse(timeClockStr[0]);
  int minutes = int.parse(timeClockStr[1]);
  String hourStr;
  String minuteStr = '${minutes < 10 ? '0': ''}$minutes';

  if(hour >= 12){
    meridiem = 'pm';
    if(hour > 12){
      hour -= 12;
    }
  } else if(hour == 0){
    hour = 12;
  }
  hourStr = hour.toString();

  return '$hourStr:$minuteStr$meridiem';
}

String capitalize(String s) => s.length > 0 ? s[0].toUpperCase() + s.substring(1) : '';

List<List<Widget>> transformPaginationListCache(list, pageSize, offsetPage, callback) {
  List<List<Widget>> paginatedList = <List<Widget>>[];
  for(int i = 0, n = 0; i < offsetPage; i++){
    List<Widget> pageList = <Widget>[];
    for(int o = 0; o < pageSize && n < list.length; o++, n++){
      var item = list[n];
      pageList.add(callback(item, i, o, n));
    }
    paginatedList.add(pageList);
  }

  return paginatedList;
}

String epochToHumanTime(epoch) {
  var currDivisor = [1,60,60,24,7,4, 12];
  var unitTime = ['sec','min','hr',' day',' week', ' month'];
  var sentence = "";
  var majorTime;
  var minorTime = 0;
  var majorTimeUnit;
  var minorTimeUnit = '';
  var i = 0;
  var majorTimePhrase;
  var minorTimePhrase;

  majorTime = epoch;

  for(int realTime = 1; i < currDivisor.length; i++){
    majorTime /= currDivisor[i];
    realTime *= currDivisor[i+1];

    if((epoch) < (realTime)) break;
  }

  minorTime = ((majorTime - majorTime.floor())*currDivisor[i]).floor();
  majorTime = majorTime.floor();
  majorTimeUnit = unitTime[i];
  if(i > 0){
    minorTimeUnit = unitTime[i-1];
  }

  majorTimePhrase = "$majorTime$majorTimeUnit${majorTime > 1 ? 's' : ''}";
  minorTimePhrase = "$minorTime$minorTimeUnit${minorTime > 1 ? 's' : ''}";

  sentence = "$majorTimePhrase${i > 0 ? ' ' : ''}${i == 0 ? ' ' : ''}${ minorTime == 0 ? '' : i == 0 ? '' : minorTimePhrase + ' ' }ago";
  return sentence;
}