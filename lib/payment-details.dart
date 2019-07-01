import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

import 'services.dart';

class Payment {
  String label;
  String amount;

  Payment({this.label, this.amount});
}

List<Payment> pre_school_payments = <Payment>[];

List<Payment> kumon_payments = <Payment>[];

class PaymentDataView extends StatelessWidget{
  final String title;
  final List<Payment> payments;

  PaymentDataView({
    this.title,
    this.payments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  this.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: this.payments.length,
            itemBuilder: (BuildContext context, int index) {
              Payment payment = this.payments[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      payment.label,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87
                      ),
                    ),
                    Text(
                      payment.amount,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).accentColor
                      ),
                    ),
                  ]
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class PaymentDetails extends StatelessWidget {
  final String date;
  final String firstName;
  final String lastName;
  final String userId;
  final String paymentModes;
  final String amountDesc;
  final String paymentDate;
  final double amountPaid;
  final double enrollmentFee;
  final double tuitionFee;

  PaymentDetails({
    this.date,
    this.firstName,
    this.lastName,
    this.userId,
    this.paymentModes,
    this.amountPaid,
    this.amountDesc,
    this.enrollmentFee,
    this.tuitionFee,
    this.paymentDate
  });

  @override
  Widget build(BuildContext context) {
    double kumonRegFee;
    double mathFee;
    double readingFee;
    double tutorialFee = 0.0;
    List payments;

    kumon_payments = <Payment>[];
    pre_school_payments = <Payment>[];

    if(paymentModes != null){
      payments = paymentModes.split(',');
      payments[1] != '' ? kumonRegFee = double.parse(payments[1]) : null;
      payments[2] != '' ? mathFee = double.parse(payments[2]) : null;
      payments[3] != '' ? readingFee = double.parse(payments[3]) : null;
      payments[4] != '' ? tutorialFee = double.parse(payments[4]) : null;

      if(mathFee != null){
        kumon_payments.add( Payment(
          label: 'MATH',
          amount: localCurrencyFormat(mathFee)
        ));
      }
      if(readingFee != null){
        kumon_payments.add( Payment(
          label: 'READING',
          amount: localCurrencyFormat(readingFee)
        ));
      }
      if(kumonRegFee != null){
        kumon_payments.add( Payment(
          label: 'REGISTRATION FEE',
          amount: localCurrencyFormat(kumonRegFee)
        ));
      }

      if(enrollmentFee != null){
        pre_school_payments.add( Payment(
            label: 'ENROLLMENT FEES',
            amount: localCurrencyFormat(enrollmentFee)
        ));
      }
    }

    if(tuitionFee != null){
      pre_school_payments.add( Payment(
          label: 'TUITION FEE',
          amount: localCurrencyFormat(tuitionFee)
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment on ' + date)
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProfileHeader(
                firstName: this.firstName,
                lastName: this.lastName,
                heroTag: this.userId,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    DashboardTile(
                                      label: 'DUE DATE',
                                      displayPlainValue: true,
                                      value: date,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    DashboardTile(
                                      label: 'DATE OF PAYMENT',
                                      displayPlainValue: true,
                                      value: paymentDate,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1.0, color: Colors.grey[300]),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            children: <Widget>[
                              PaymentDataView(
                                title: 'Pre-School',
                                payments: pre_school_payments
                              ),
                              kumon_payments.length > 0 ? PaymentDataView(
                                  title: 'Kumon',
                                  payments: kumon_payments
                              ) : Container(),
                              tutorialFee != 0.0 ? PaymentDataView(
                                title: 'Tutorial',
                                payments: [Payment(
                                  label: 'REGISTRATION FEE',
                                  amount: '₱${tutorialFee + 0.00}'
                                )],
                              ) : Container()
                            ]
                          ),
                        ),
                        Divider(height: 1.0, color: Colors.grey[300]),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    'TYPE',
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.0
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 3.0),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 3.0),
                                    child: Text(
                                      'Check',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black87
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 3.0),
                                    child: Text(
                                      '1234567890',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black87
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 3.0),
                                    child: Text(
                                      'Bank of the Phillipine Islands',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black87
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    'AUTHORIZED BY',
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.0
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 3.0),
                                  ),
                                  Text(
                                    'Annabelle G. Lim',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black87
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1.0, color: Colors.grey[300]),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  'GRAND TOTAL',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  localCurrencyFormat(amountPaid),
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      )
    );
  }
}