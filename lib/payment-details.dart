import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

class Payment {
  String label;
  String amount;

  Payment({this.label, this.amount});
}

List<Payment> pre_school_payments = <Payment>[
  Payment(
      label: 'TUITION FEE',
      amount: 'P5,000'
  ),
  Payment(
      label: 'ENROLLMENT FEES',
      amount: 'P5,000'
  ),
  Payment(
      label: 'OTHERS',
      amount: 'P2,000'
  )
];

List<Payment> kumon_payments = <Payment>[
  Payment(
      label: 'MATH',
      amount: 'P5,000'
  ),
  Payment(
      label: 'READING',
      amount: 'P5,000'
  ),
  Payment(
      label: 'REGISTRATION FEE',
      amount: 'P500'
  )
];

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
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  this.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700
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
                        fontSize: 14.0
                      ),
                    ),
                    Text(
                      payment.amount,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700
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

  PaymentDetails({
    this.date,
    this.firstName,
    this.lastName,
    this.userId
  });

  @override
  Widget build(BuildContext context) {
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
                                  label: 'MONTH',
                                  displayPlainValue: true,
                                  value: 'January',
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
                                  value: date,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1.0, color: Colors.grey[300]),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: <Widget>[
                          PaymentDataView(
                            title: 'Pre-School',
                            payments: pre_school_payments
                          ),
                          PaymentDataView(
                            title: 'Kumon',
                            payments: kumon_payments
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1.0, color: Colors.grey[300]),
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
                              'P5,000.00',
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
              )
            ],
          ),
        )
      )
    );
  }
}