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

Future buildStudentPayments(userId) async {
  List<Payment> paymentsDue = <Payment>[];
  DateTime yearStartMonth;
  DateTime yearEndMonth;

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

      if(results.length > 0){ // TODO: Ask what happens when a payment package is changed
        Map initialPayment = results[0];
        List note = initialPayment['note'].split(',');
        List paymentSettingsList = initialPayment['pay_setting_id'].split(',');

        paymentPackage = int.parse(note[0]);
        kumonRegFee = double.parse(note[1]);
        mathFee = double.parse(note[2]);
        readingFee = double.parse(note[3]);
        tutorialFee = double.parse(note[4]);

        for(int i = 0; i < paymentSettingsList.length; i++){
          String paymentSetting = paymentSettingsList[i];
          if(paymentSetting.length > 0){
            paymentSettings.add(paymentSetting);
          }
        }

        isPaymentRegistered = true;
      }

      for(int i = 0; i < results.length; i++){
        Map payment = results[i];
        DateTime paymentDate = DateTime.parse(payment['due_date']).toLocal();
        if(isPaymentRegistered){
          initialPayments.add(
            Payment(
              label: timeFormat(payment['paid_date']),
              amount: "₱${payment['amount_paid']}",
              rawDate: paymentDate,
              rawPaidDate: DateTime.parse(payment['paid_date']).toLocal()
            )
          );
        }
      }

      if(initialPayments.length > 0){
        Payment latestPayment = initialPayments[initialPayments.length - 1];
        int paymentCounter = 0;
        latestPaymentDate = latestPayment.rawDate;

        if(paymentPackage == 3){
          DateTime paymentPeriodIndex = DateTime(yearStartMonth.year, yearStartMonth.month, 1);
          int previousPaymentMonthCntr = -1;
          int paymentPeriodMonthCntr;
          String amount = 'N/A';

          for(int i = 0; paymentPeriodIndex.isBefore(yearEndMonth) || paymentPeriodIndex.isAtSameMomentAs(yearEndMonth); i++){
            paymentPeriodMonthCntr = paymentPeriodIndex.month;
            amount = 'N/A';

            if(previousPaymentMonthCntr == paymentPeriodMonthCntr){
              paymentPeriodIndex = DateTime.utc(paymentPeriodIndex.year, paymentPeriodMonthCntr + 1, 0, -8);
            }else {
              paymentPeriodIndex = DateTime.utc(paymentPeriodIndex.year, paymentPeriodMonthCntr, 15, -8);
            }

            if(initialPayments.length > 0){
              if(paymentPeriodIndex.toLocal().isAtSameMomentAs(initialPayments[0].rawDate)){
                amount = initialPayments[0].amount;
                initialPayments.removeAt(0);
              }
            }

            payments.add(
              Payment(
                label: timeFormat(paymentPeriodIndex.toLocal().toString()),
                amount: amount,
                rawDate: paymentPeriodIndex.toLocal(),
              )
            );

            paymentPeriodIndex = paymentPeriodIndex.add(Duration(days: 15));
            previousPaymentMonthCntr = paymentPeriodMonthCntr;
          }
        }else if (paymentPackage == 2){
          DateTime paymentPeriodIndex = DateTime(yearStartMonth.year, yearStartMonth.month, 5);
          String amount = 'N/A';

          for(int i = 0; paymentPeriodIndex.isBefore(yearEndMonth) || paymentPeriodIndex.isAtSameMomentAs(yearEndMonth); i++){
            amount = 'N/A';

            if(initialPayments.length > 0){
              if(paymentPeriodIndex.toLocal().isAtSameMomentAs(initialPayments[0].rawDate)){
                amount = initialPayments[0].amount;
                initialPayments.removeAt(0);
              }
            }

            payments.add(
              Payment(
                label: timeFormat(paymentPeriodIndex.toLocal().toString()),
                amount: amount,
                rawDate: paymentPeriodIndex.toLocal(),
              )
            );

            paymentPeriodIndex = paymentPeriodIndex.add(Duration(days: 31));
            paymentPeriodIndex = DateTime.utc(paymentPeriodIndex.year, paymentPeriodIndex.month, 5, -8);
          }
        }else if (paymentPackage == 1){
          initialPayments.forEach((payment){
            payments.add(
              Payment(
                label: timeFormat(payment.rawPaidDate.toLocal().toString()),
                amount: payment.amount,
                rawDate: payment.rawDate.toLocal(),
                rawPaidDate: payment.rawPaidDate
              )
            );
          });
        }
      }
    });
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
  @override
  Widget build(BuildContext context) {

    payments = [];
    initialPayments = [];

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
              Padding(
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
                                  value: 'P10,000.00',
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                DashboardTile(
                                  label: 'TOTAL PAYMENT',
                                  displayPlainValue: true,
                                  value: 'P20,000.00',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: buildStudentPayments(widget.userId),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if(snapshot.connectionState == ConnectionState.done){
                          return DataTable(
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
                                        payment.amount,
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
                          );
                        }else{
                          return DataTable(
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
                            rows: <DataRow>[]
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}