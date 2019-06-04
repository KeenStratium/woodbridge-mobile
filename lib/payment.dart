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

  Payment({this.label, this.amount});
}

List<Payment> payments = <Payment>[];

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

Future buildStudentPayments(userId) async {
  await fetchStudentPayments(userId)
    .then((results) {
      for(int i = 0; i < results.length; i++){
        Map payment = results[i];
        print(payment);
        payments.add(
          Payment(
            label: payment['paid_date'],
            amount: "₱${payment['amount_paid']}"
          )
        );
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History')
      ),
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
                                    timeFormat(payment.label),
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
                        return Text('Fetching payments...');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}