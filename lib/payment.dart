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
    amount: '₱5,000'
  ),
  Payment(
    label: '2/10/2019',
    amount: '₱5,000'
  ),
  Payment(
    label: '2/14/2019',
    amount: '₱2,000'
  )
];

class PaymentHistory extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String userId;

  PaymentHistory({
    this.firstName,
    this.lastName,
    this.userId
  });

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
              firstName: this.firstName,
              lastName: this.lastName,
              heroTag: this.userId,
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
                    rows: payments.map((payment) => DataRow(
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
                                userId: userId,
                                firstName: firstName,
                                lastName: lastName,
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
                                userId: userId,
                                firstName: firstName,
                                lastName: lastName,
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