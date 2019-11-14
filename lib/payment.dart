import 'services.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'payment-details.dart';

class Payment {
  String label;
  String amount;
  String paymentModes;
  double dueAmount;
  DateTime rawDate;
  String paidDate;
  String paymentSettingId;
  String amountDesc;
  String paymentNote;
  Map paymentType;
  bool isPaid;

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
    this.paymentNote
  });
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
    this.paymentData,
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
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            ProfileHeader(
              firstName: this.widget.firstName,
              lastName: this.widget.lastName,
              heroTag: this.widget.userId,
            ),
            Expanded(
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  DashboardTile(
                                    label: 'BALANCE',
                                    displayPlainValue: true,
                                    value: widget.paymentData['totalBalance'] != null ? localCurrencyFormat(widget.paymentData['totalBalance']) : "0.00",
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
                                    value: widget.paymentData['totalPayments'] != null ? localCurrencyFormat(widget.paymentData['totalPayments']) : "0.00",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[300]
                            )
                          )
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
                                    'DATE',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black54
                                    ),
                                  ),
                                  Text(
                                    'DUE',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black54
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
                                    'DUE',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black54
                                    ),
                                  ),
                                  Text(
                                    'AMOUNT',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black54
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
                                    'PAYMENT',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black54
                                    ),
                                  ),
                                  Text(
                                    'DATE',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black54
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
                        children: widget.paymentData['payments'] != null ? (widget.paymentData['payments'] as List).map((payment) {
                          return Material(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                Route route = MaterialPageRoute(
                                  builder: (buildContext) => PaymentDetails(
                                    userId: widget.userId,
                                    firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    payment: payment
                                  ));

                                Navigator.push(context, route);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[200]
                                    )
                                  )
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Flex(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  direction: Axis.horizontal,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        payment.label,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Text(
                                        payment.dueAmount != null ? localCurrencyFormat(payment.dueAmount) : 'N/A',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87
                                        ),
                                      ),
                                      flex: 1
                                    ),
                                    Expanded(
                                      child: Text(
                                        payment.paidDate ?? 'Unpaid',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                          color: payment.paidDate == 'Unpaid' ? Colors.black38 : Colors.black87
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList() : <Widget>[Container()],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}