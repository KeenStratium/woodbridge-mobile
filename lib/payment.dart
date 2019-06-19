import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'payment-details.dart';
import 'services.dart';

class Payment {
  String label;
  String amount;
  DateTime rawDate;
  var rawPaidDate;

  Payment({this.label, this.amount, this.rawDate, this.rawPaidDate});
}

double totalBalance = 0.00;
double totalPayments = 0.00;

List<Payment> payments = <Payment>[];
List<Payment> initialPayments = <Payment>[];

Future<List> fetchStudentPayments(userId) async {
  String url = '$baseApi/pay/get-student-payments';

  var response = await http.post(url, body: json.encode({
    'data': userId
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body);
}

Future<List> getSchoolYearInformation() async {
  String url = '$baseApi/att/get-attendance-setting-information';

  var response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body);
}

class PaymentHistory extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userId;

  PaymentHistory({
    this.firstName,
    this.lastName,
    this.userId
  });

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  static Future buildStudentPayments(userId) async {
    DateTime yearStartMonth;
    DateTime yearEndMonth;
    Completer _completer = Completer();

    await getSchoolYearInformation()
        .then((results) {
      Map schoolYearInformation = results[results.length - 1]; // TODO: Verify which row to get, or if changes from year to year or new one will be added.
      DateTime yearStart = DateTime.parse(schoolYearInformation['quarter_start']);
      DateTime yearEnd = DateTime.parse(schoolYearInformation['quarter_end']);

      DateTime yearStartLocal = yearStart.toLocal();
      DateTime yearEndLocal = yearEnd.toLocal();

      yearStartMonth = DateTime(yearStartLocal.year, yearStartLocal.month, 1);
      yearEndMonth = DateTime(yearEndLocal.year, yearEndLocal.month + 1, 0, 23, 59);
    });

    await fetchStudentPayments(userId)
        .then((results) {
      bool isPaymentRegistered = false;
      List paymentSettings = [];
      DateTime latestPaymentDate;
      int paymentPackage;
      double kumonRegFee;
      double mathFee;
      double readingFee;
      double tutorialFee;

      payments = [];

      results.forEach((payment) {
        String amount;

        try {
          amount = payment['amount_paid'] != null ? payment['amount_paid'].toString() : 'N/A';
          if(amount == 'N/A' || amount == null){
            totalBalance += payment['due_amount'];
          }else {
            if(payment['amount_paid'] != null){
              totalPayments += payment['amount_paid'];
            }
          }
        } catch(e){}

        payments.add(
            Payment(
                label: timeFormat(DateTime.parse(payment['due_date']).toLocal().toString()),
                amount: amount,
                rawDate: DateTime.parse(payment['due_date']).toLocal(),
                rawPaidDate: DateTime.parse(payment['due_date']).toLocal()
            )
        );
      });
    });
    print('called');
    _completer.complete();
    return _completer.future;
  }
  
  @override
  Widget build(BuildContext context) {
    payments = [];
    initialPayments = [];

    totalBalance = 0;
    totalPayments = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History')
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              ProfileHeader(
                firstName: this.widget.firstName,
                lastName: this.widget.lastName,
                heroTag: this.widget.userId,
              ),
              FutureBuilder(
                future: buildStudentPayments(widget.userId),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Flex(
                        direction: Axis.vertical,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      DashboardTile(
                                        label: 'BALANCE',
                                        displayPlainValue: true,
                                        value: '₱$totalBalance',
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      DashboardTile(
                                        label: 'TOTAL PAYMENTS',
                                        displayPlainValue: true,
                                        value: '₱$totalPayments',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataTable(
                              columns: <DataColumn>[
                                DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'DATE OF PAYMENT',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.0,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                    numeric: false,
                                    onSort: (i, j){},
                                    tooltip: 'data of payment'
                                ),
                                DataColumn(
                                    label: Flexible(
                                      child: Text(
                                        'AMOUNT',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.0,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                    numeric: false,
                                    onSort: (i, j){},
                                    tooltip: 'amount'
                                )
                              ],
                              rows: payments.map((payment) {
                                return DataRow(
                                    cells: [
                                      DataCell(
                                          Text(
                                            payment.label,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16.0
                                            ),
                                          ),
                                          onTap: () {
                                            Route route = MaterialPageRoute(
                                                builder: (buildContext) => PaymentDetails(
                                                  date: payment.label,
                                                  userId: widget.userId,
                                                  firstName: widget.firstName,
                                                  lastName: widget.lastName,
                                                ));
                                            Navigator.push(context, route);
                                          }
                                      ),
                                      DataCell(
                                          Text(
                                            payment.amount ?? 'N/A',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          onTap: () {
                                            Route route = MaterialPageRoute(
                                                builder: (buildContext) => PaymentDetails(
                                                  date: payment.label,
                                                  userId: widget.userId,
                                                  firstName: widget.firstName,
                                                  lastName: widget.lastName,
                                                ));
                                            Navigator.push(context, route);
                                          }
                                      )
                                    ]
                                );
                              }).toList()
                          )
                        ],
                      ),
                    );
                  }else{
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: Text('Fetching payments...'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        )
      ),
    );
  }
}