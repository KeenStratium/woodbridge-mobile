import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

List<String> dayNames = <String>['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
List<String> monthNames = <String>['January', 'February', 'March', 'April','May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

String localCurrencyFormat(double amount){
  return '₱${amount + 0.00}';
}

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

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

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