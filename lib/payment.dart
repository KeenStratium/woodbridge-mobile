import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'payment-details.dart';

Future<List> fetchPaymentSettings(settingsId) async {
  String url = '$baseApi/pay/get-payment-settings';
  var response = await http.post(url, body: json.encode({
    'data': {
      'settings_id': [settingsId]
    }
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body);
}
Future fetchBankInfo(bankAbbr) async {
  String url = '$baseApi/pay/get-bank-info';

  if(bankAbbr != null){
    var response = await http.post(url, body: json.encode({
      'data': {
        'bank_abbr': bankAbbr
      }
    }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        });

    return jsonDecode(response.body);
  }else{
    return {'success': false};
  }


}

class Payment {
  String label;
  String amount;
  String paymentModes;
  double dueAmount;
  DateTime rawDate;
  String paidDate;
  String paymentSettingId;
  String amountDesc;
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
    this.paymentType
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
                      children: (widget.paymentData['payments'] as List).map((payment) {
                        return Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () async {
                              await Future.wait([fetchBankInfo(payment.paymentType['bank_abbr']), fetchPaymentSettings(payment.paymentSettingId)])
                                .then((results) {
                                  var paymentResults = results[1];
                                  var bankResult = results[0]['data'];
                                  var paymentMetaInfo = payment.paymentType;
                                  Map settings = paymentResults[0];

                                  if(results[0]['success']){
                                    paymentMetaInfo['bank_name'] = bankResult['bank_name'];
                                  }else{
                                    paymentMetaInfo['bank_name'] = null;
                                  }

                                  double totalAnnualFee = settings['total_annual_fee'] + 0.00;
                                  double totalTuitionFee = settings['total_tuition_fee'] + 0.00;

                                  Route route = MaterialPageRoute(
                                    builder: (buildContext) => PaymentDetails(
                                    date: payment.label,
                                    userId: widget.userId,
                                    firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    paymentModes: payment.paymentModes,
                                    amountDesc: payment.amountDesc,
                                    amountPaid: payment.amount != 'N/A' ? double.parse(payment.amount) : null,
                                    enrollmentFee: totalAnnualFee - totalTuitionFee,
                                    tuitionFee: settings['tuition_fee'] + 0.00,
                                    paymentDate: payment.paidDate ?? 'Unpaid',
                                    paymentType: paymentMetaInfo,
                                  ));
                                  Navigator.push(context, route);
                                });
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
                                      '₱${payment.dueAmount ?? 'N/A'}',
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
                      }).toList(),
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