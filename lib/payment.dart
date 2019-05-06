import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'payment-details.dart';

class Payment {
  String label;
  String amount;

  Payment({this.label, this.amount});
}

List<Payment> payments = <Payment>[
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

class PaymentHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History')
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            ProfileHeader(
              profileName: 'Kion Kefir C. Gargar',
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
                        DataCell(
                          Text(payment.label),
                          onTap: () {
                            Route route = MaterialPageRoute(
                              builder: (buildContext) => PaymentDetails(
                                date: payment.label
                              ));
                            Navigator.push(context, route);
                          }
                        ),
                        DataCell(
                          Text(payment.amount),
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (buildContext) => PaymentDetails(
                                    date: payment.label
                                ));
                            Navigator.push(context, route);
                          }
                        )
                      ]
                    )).toList()
                  )
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}