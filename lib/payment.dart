import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'services.dart';
import 'model.dart';
import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'payment-details.dart';

Future<List> fetchStudentPayments(userId) async {
  String url = '$baseApi/pay/get-student-payments-mobile';

  var response = await http.post(
    url,
    body: json.encode({'data': userId}),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  );

  return jsonDecode(response.body);
}

class Payment {
  Payment({
    this.label,
    this.amount,
    this.rawDate,
    this.paidDate,
    this.isPaid,
    this.dueAmount,
    this.paymentModes,
    this.paymentSettingId,
    this.amountDesc,
    this.paymentType,
    this.paymentNote,
    this.checkNo,
  });

  String amount;
  String amountDesc;
  double dueAmount;
  bool isPaid;
  String label;
  String paidDate;
  String paymentModes;
  String paymentNote;
  String paymentSettingId;
  String checkNo;
  Map paymentType;
  DateTime rawDate;
}

class PaymentHistory extends StatefulWidget {
  PaymentHistory({
    this.firstName,
    this.lastName,
    this.userId,
  });

  final String firstName;
  final String lastName;
  final String userId;

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List<Payment> payments = <Payment>[];
  double totalBalance = 0.00;
  double totalPayments = 0.00;
  bool isInitiated = false;
  String nextPaymentDay;
  String nextPaymentMonth;
  Map paymentData = {};

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future buildStudentPayments(userId) async {
    return await fetchStudentPayments(userId).then((results) {
      payments = [];
      totalBalance = 0.00;
      totalPayments = 0.00;

      results.forEach((payment) {
        var amount;
        DateTime dueDate;
        if (payment['due_date'] != null) {
          dueDate = DateTime.parse(payment['due_date']).toLocal();
        }
        String paymentDate = 'Unpaid';
        double dueAmount = payment['due_amount'] != null ? payment['due_amount'] + 0.00 : 0.00;

        print(dueDate);

        try {
          amount = payment['amount_paid'] != null ? payment['amount_paid'].toString() : 'N/A';
          if (amount == 'N/A' || amount == null || amount == '0') {
            totalBalance += payment['due_amount'];
            if (nextPaymentMonth == null) {
              nextPaymentMonth = monthNames[dueDate.month - 1];
              nextPaymentDay = '${dueDate.day < 10 ? "0" : ""}${dueDate.day}';
              String nextPaymentpackageNum;

              if (payment['note'] != null) {
                nextPaymentpackageNum = payment['note'].split(',')[0];
              }

              setNextPayment(
                nextPaymentDay,
                nextPaymentMonth,
                nextPaymentpackageNum,
              );
            }
          } else {
            if (payment['amount_paid'] != null) {
              totalPayments += payment['amount_paid'];
            }
          }
        } catch (e) {
          print(e);
        }

        try {
          String paidDate = payment['paid_date'];
          if (paidDate != null) {
            paymentDate = timeFormat(
              DateTime.parse(payment['paid_date']).toLocal().toString(),
              'MMM dd y',
            );
          }
        } catch (e) {
          print(e);
        }

        try {
          payments.add(
            Payment(
              label: dueDate != null ? timeFormat(dueDate.toString(), 'MMM dd y') : '',
              amount: amount,
              dueAmount: dueAmount,
              rawDate: dueDate,
              paidDate: paymentDate,
              isPaid: amount != 'N/A',
              paymentModes: payment['note'],
              paymentSettingId: payment['pay_setting_id'].split(',')[0],
              amountDesc: payment['due_desc'],
              checkNo: payment['check_no'],
              paymentType: {
                'type': payment['pay_type'],
                'official_receipt': payment['official_receipt'],
                'bank_abbr': payment['pay_bank'],
              },
              paymentNote: payment['description'],
            ),
          );
        } catch (e) {
          print(e);
        }
      });

      paymentData = {
        'totalPayments': totalPayments,
        'totalBalance': totalBalance,
        'payments': payments,
      };

      return paymentData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment History')),
      backgroundColor: Colors.white,
      body: SafeArea(
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
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        DashboardTile(
                                          label: 'Total Payments',
                                          displayPlainValue: true,
                                          value: snapshot.data['totalPayments'] != null
                                              ? localCurrencyFormat(snapshot.data['totalPayments'])
                                              : "0.00",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        DashboardTile(
                                          label: 'Total Balance',
                                          displayPlainValue: true,
                                          value: snapshot.data['totalBalance'] != null
                                              ? localCurrencyFormat(snapshot.data['totalBalance'])
                                              : "0.00",
                                          color: Color(0xFFDA4453),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ),
                              child: Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Due Date',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Amount Due',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Payment Date',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: snapshot.data['payments'] != null
                                  ? (snapshot.data['payments'] as List).map((payment) {
                                      Payment _payment = payment;
                                      String dueDataLabel = 'N/A';
                                      bool isActive = false;
                                      String packageNum;

                                      if (_payment.paymentModes != null) {
                                        packageNum = _payment.paymentModes.split(',')[0];
                                      }

                                      // if (packageNum == '3.1') {
                                      //   isActive = false;
                                      //   dueDataLabel = '-';
                                      // } else {
                                      //   isActive = true;
                                      //   dueDataLabel = payment.label;
                                      // }

                                      isActive = true;
                                      dueDataLabel = payment.label;

                                      return Material(
                                        color: Colors.white,
                                        child: InkWell(
                                          onTap: () {
                                            Route route = MaterialPageRoute(
                                              builder: (buildContext) => PaymentDetails(
                                                userId: widget.userId,
                                                firstName: widget.firstName,
                                                lastName: widget.lastName,
                                                payment: payment,
                                              ),
                                            );

                                            Navigator.push(context, route);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey[200],
                                                ),
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 16.0),
                                            child: Flex(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              direction: Axis.horizontal,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    dueDataLabel,
                                                    textAlign: isActive
                                                        ? TextAlign.left
                                                        : TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.w600,
                                                      color: isActive
                                                          ? Colors.black87
                                                          : Colors.black38,
                                                    ),
                                                  ),
                                                  flex: 1,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    payment.dueAmount != null
                                                        ? localCurrencyFormat(payment.dueAmount)
                                                        : 'N/A',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  flex: 1,
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                            horizontal: 5.0),
                                                        child: Text(
                                                          payment.paidDate ?? 'Unpaid',
                                                          textAlign: TextAlign.right,
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.w600,
                                                            color: payment.paidDate == 'Unpaid'
                                                                ? Colors.black38
                                                                : Colors.black87,
                                                          ),
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.info_outline,
                                                        size: 16.0,
                                                        semanticLabel: 'View payment details',
                                                        color: Theme.of(context).accentColor,
                                                      ),
                                                    ],
                                                  ),
                                                  flex: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList()
                                  : <Widget>[Container()],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 64.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
