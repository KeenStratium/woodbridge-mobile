import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

import 'services.dart';

class Payment {
  String label;
  String amount;
  bool isPaid;

  Payment({this.label, this.amount, this.isPaid});
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
              bool isPaid = payment.isPaid;
              if(isPaid == null){
                isPaid = false;
              }
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
                        color: isPaid ? Theme.of(context).accentColor : Colors.grey[500]
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
  final double amountDue;
  final double tuitionFee;
  final double totalAnnualPackageOneFee;
  final Map paymentType;
  double enrollmentFee;

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
    this.paymentDate,
    this.paymentType,
    this.amountDue,
    this.totalAnnualPackageOneFee
  });

  @override
  Widget build(BuildContext context) {
    double kumonRegFee;
    double mathFee;
    double readingFee;
    double tutorialFee = 0.0;
    int packageNum;
    List payments;

    kumon_payments = <Payment>[];
    pre_school_payments = <Payment>[];

    if(paymentModes != null){
      payments = paymentModes.split(',');
      payments[0] != '' ? packageNum = int.parse(payments[0]) : null;
      payments[1] != '' ? kumonRegFee = double.parse(payments[1]) : null;
      payments[2] != '' ? mathFee = double.parse(payments[2]) : null;
      payments[3] != '' ? readingFee = double.parse(payments[3]) : null;
      payments[4] != '' ? tutorialFee = double.parse(payments[4]) : null;

      if(packageNum == 3){
        enrollmentFee /= 4;
      }

      if(packageNum == 1){
        if(enrollmentFee != null){
          pre_school_payments.add( Payment(
            label: 'ENROLLMENT FEES',
            amount: localCurrencyFormat(totalAnnualPackageOneFee),
            isPaid: paymentDate != 'Unpaid'
          ));
        }
      }else {
        if(enrollmentFee != null){
          pre_school_payments.add( Payment(
            label: 'ENROLLMENT FEES',
            amount: localCurrencyFormat(enrollmentFee),
            isPaid: paymentDate != 'Unpaid'
          ));
        }
        if(tuitionFee != null){
          pre_school_payments.add( Payment(
            label: 'TUITION FEE',
            amount: localCurrencyFormat(tuitionFee),
            isPaid: paymentDate != 'Unpaid'
          ));
        }
      }

      if(mathFee != null && mathFee != 0.0){
        kumon_payments.add( Payment(
          label: 'MATH',
          amount: localCurrencyFormat(mathFee),
          isPaid: paymentDate != 'Unpaid'
        ));
      }
      if(readingFee != null && readingFee != 0.0){
        kumon_payments.add( Payment(
          label: 'READING',
          amount: localCurrencyFormat(readingFee),
          isPaid: paymentDate != 'Unpaid'
        ));
      }
      if(kumonRegFee != null){
        kumon_payments.add( Payment(
          label: 'REGISTRATION FEE',
          amount: localCurrencyFormat(kumonRegFee),
          isPaid: paymentDate != 'Unpaid'
        ));
      }
    }else{
      pre_school_payments.add( Payment(
        label: amountDesc.toUpperCase(),
        amount: localCurrencyFormat(amountDue),
        isPaid: paymentDate != 'Unpaid'
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
                                      isActive: paymentDate != 'Unpaid',
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
                                  amount: '₱${tutorialFee + 0.00}',
                                  isPaid: paymentDate != 'Unpaid'
                                )],
                              ) : Container()
                            ]
                          ),
                        ),
                        Divider(height: 1.0, color: Colors.grey[300]),
                      ],
                    ),
                    paymentDate != 'Unpaid' ? Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6.0),
                                    child: Column(
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
                                          child: Text(
                                            capitalize(paymentType['type']),
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black87
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'OFFICIAL RECEIPT',
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.0
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 3.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                '#',
                                                style: TextStyle(
                                                  color: Colors.grey[500]
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 1.0),
                                              ),
                                              Text(
                                                '${paymentType['official_receipt']}',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black87
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  paymentType['bank_name'] != null ? Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'BANK',
                                          style: TextStyle(
                                              color: Colors.grey[500],
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.0
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 3.0),
                                          child: Text(
                                            paymentType['bank_name'] ?? '',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) : Container(),
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
                    ) : Container(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Text(
                        'No payment information yet.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600
                        ),
                      ),
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