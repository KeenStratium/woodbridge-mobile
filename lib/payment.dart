import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

class Payment {
  String date;
  String amount;

  Payment({this.date, this.amount});
}

List<Payment> payments = <Payment>[
  Payment(
    date: '1/14/2019',
    amount: 'P5,000'
  ),
  Payment(
    date: '2/10/2019',
    amount: 'P5,000'
  ),
  Payment(
    date: '2/14/2019',
    amount: 'P2,000'
  ),
  Payment(
    date: '3/11/2019',
    amount: 'P5,000'
  ),
  Payment(
    date: '/29/2019',
    amount: 'P5,000'
  )
];

class PaymentHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History')
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
                    DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Flexible(
                            child: Text(
                              'DATE OF PAYMENT',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0,
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
                            child: Text('AMOUNT'),
                          ),
                          numeric: false,
                          onSort: (i, j){},
                          tooltip: 'amount'
                        )
                      ],
                      rows: payments.map((payment) => DataRow(
                        cells: [
                          DataCell(Text(payment.date)),
                          DataCell(Text(payment.amount))
                        ]
                      )).toList()
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