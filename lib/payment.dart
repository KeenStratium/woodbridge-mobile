import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'payment-details.dart';

class Payment {
  String label;
  String amount;
  DateTime rawDate;
  var rawPaidDate;

  Payment({this.label, this.amount, this.rawDate, this.rawPaidDate});
}

class PaymentHistory extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userId;
  final Map paymentData;
  List<Payment> payments = <Payment>[];
  double totalPayments = 0.00;
  double totalBalance = 0.00;
  bool isInitiated = false;

  PaymentHistory({
    this.firstName,
    this.lastName,
    this.userId,
    this.paymentData
  });

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                  value: '₱${widget.paymentData['totalBalance'] ?? "0.00"}',
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
                                  value: '₱${widget.paymentData['totalPayments'] ?? "0.00"}',
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
                        rows: (widget.paymentData['payments'] as List).map((payment) {
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
              )
            ],
          ),
        )
      ),
    );
  }
}