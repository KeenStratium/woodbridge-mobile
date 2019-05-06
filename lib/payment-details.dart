import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

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