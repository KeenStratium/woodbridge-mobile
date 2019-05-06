import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

class Payment {
  String label;
  String amount;

  Payment({this.label, this.amount});
}

List<Payment> pre_school_payments = <Payment>[
  Payment(
      label: '1/14/2019',
      amount: 'P5,000'
  ),
  Payment(
      label: '2/10/2019',
      amount: 'P5,000'
  ),
  Payment(
      label: '2/14/2019',
      amount: 'P2,000'
  )
];

List<Payment> kumon_payments = <Payment>[
  Payment(
      label: '1/14/2019',
      amount: 'P5,000'
  ),
  Payment(
      label: '2/10/2019',
      amount: 'P5,000'
  ),
  Payment(
      label: '2/14/2019',
      amount: 'P2,000'
  )
];

class PaymentDataView extends StatelessWidget{
  final String title;
  final List<Payment> payments;

  PaymentDataView({
    this.title,
    this.payments
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                this.title,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600
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
                      fontSize: 16.0
                    ),
                  ),
                  Text(
                    payment.amount,
                    style: TextStyle(
                        fontSize: 16.0
                    ),
                  ),
                ]
              ),
            );
          },
        )
      ],
    );
  }
}

class PaymentDetails extends StatelessWidget {
  final String date;

  PaymentDetails({
    this.date
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment on ' + date)
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProfileHeader(
                profileName: 'Kion Kefir C. Gargar',
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
              )
            ],
          ),
        )
      )
    );
  }
}