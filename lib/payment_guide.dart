import 'package:flutter/material.dart';

class PaymentGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('myWoodbridge'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Payment Guide",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 24.0),
                ),
              ),
              Text(
                "For Online Banking/Over-the-Counter Payments:\n",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
              Text(
                'Bank: METROBANK (Metropolitan Bank and Trust)\n'
                "Account Name: NEXTGEN CORPORATION DBA THE WOODBRIDGE ACADEMY OF BACOLOD\n"
                "Account Number: 5467546014939",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Text(
                "*If your bank asks for account holder information, please enter the following name:",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
              Text(
                "ABELIDO, Dominique Jose Y.\n",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              Text(
                "Send a copy of your deposit slip or screenshot of your payment confirmation to",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
              Text(
                "payments.woodbridge@gmail.com\n",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
