import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';
import 'services.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

class PaymentDetail {
  PaymentDetail({this.label, this.amount, this.isPaid});

  String amount;
  bool isPaid;
  String label;
}

Future<List> fetchPaymentSettings(settingsId) async {
  String url = '$baseApi/pay/get-payment-settings';
  var response = await http.post(url,
      body: json.encode({
        'data': {
          'settings_id': [settingsId]
        }
      }),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'});

  return jsonDecode(response.body);
}

Future fetchBankInfo(bankAbbr) async {
  String url = '$baseApi/pay/get-bank-info';

  if (bankAbbr != null && bankAbbr != '') {
    var response = await http.post(url,
        body: json.encode({
          'data': {'bank_abbr': bankAbbr}
        }),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'});

    return jsonDecode(response.body);
  } else {
    return {'success': false};
  }
}

List<PaymentDetail> _preSchoolPayments = <PaymentDetail>[];
List<PaymentDetail> _kumonPayments = <PaymentDetail>[];

class PaymentDataView extends StatelessWidget {
  PaymentDataView({
    this.title,
    this.payments,
  });

  final List<PaymentDetail> payments;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: this.title != '' ? EdgeInsets.symmetric(vertical: 10.0) : EdgeInsets.symmetric(vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  this.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
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
              PaymentDetail payment = this.payments[index];
              bool isPaid = payment.isPaid;
              if (isPaid == null) {
                isPaid = false;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  Text(
                    payment.label,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    payment.amount,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: isPaid ? Theme.of(context).accentColor : Colors.grey[500],
                    ),
                  ),
                ]),
              );
            },
          )
        ],
      ),
    );
  }
}

class Payment {
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
    this.paymentType,
    this.paymentNote,
  });

  String amount;
  String amountDesc;
  double dueAmount;
  bool isPaid;
  String label;
  String paidDate;
  String paymentModes;
  String paymentNote;
  String paymentSettingId;
  Map paymentType;
  DateTime rawDate;
}

class PaymentDetails extends StatelessWidget {
  PaymentDetails({
    this.firstName,
    this.lastName,
    this.userId,
    this.payment,
  });

  String amountDesc;
  double amountDue;
  double amountPaid;
  String date;
  double enrollmentFee;
  final String firstName;
  int installment;
  final String lastName;
  var payment;
  String paymentDate;
  String paymentModes;
  String paymentNote;
  Map paymentType;
  double totalAnnualPackageOneFee;
  double tuitionFee;
  final String userId;

  @override
  Widget build(BuildContext context) {
    double kumonRegFee;
    double mathFee;
    double readingFee;
    double tutorialFee = 0.0;
    double manualTuitionFee;
    double manualEnrollmentFee;
    double othersFee;
    int packageNum;
    List payments;

    _kumonPayments = <PaymentDetail>[];
    _preSchoolPayments = <PaymentDetail>[];

    return Scaffold(
      appBar: AppBar(title: Text('Payment on ' + this.payment.label)),
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
                child: FutureBuilder(
                    future: Future.wait([
                      fetchBankInfo(this.payment.paymentType['bank_abbr']),
                      fetchPaymentSettings(this.payment.paymentSettingId),
                    ]),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var results = snapshot.data;
                        var paymentResults = results[1];
                        var bankResult = results[0]['data'];
                        var paymentMetaInfo = payment.paymentType;
                        Map settings = paymentResults[0];
                        int installment = settings['installment'];

                        if (results[0]['success']) {
                          paymentMetaInfo['bank_name'] = bankResult['bank_name'];
                        } else {
                          paymentMetaInfo['bank_name'] = null;
                        }

                        double totalAnnualFee = settings['total_annual_fee'] + 0.00;
                        double totalTuitionFee = settings['total_tuition_fee'] + 0.00;

                        this.date = payment.label;
                        this.paymentModes = payment.paymentModes;
                        this.amountDesc = payment.amountDesc;
                        this.amountPaid = payment.amount != 'N/A' ? double.parse(payment.amount) : null;
                        this.enrollmentFee = totalAnnualFee - totalTuitionFee;
                        this.tuitionFee = settings['tuition_fee'] + 0.00;
                        this.paymentDate = payment.paidDate ?? 'Unpaid';
                        this.paymentType = paymentMetaInfo;
                        this.amountDue = payment.dueAmount;
                        this.totalAnnualPackageOneFee = totalAnnualFee - (totalAnnualFee * settings['discount']);
                        this.paymentNote = payment.paymentNote;
                        this.installment = installment;

                        if (paymentModes != null) {
                          payments = paymentModes.split(',');

                          if (payments[0] != '') {
                            packageNum = int.parse(payments[0]);
                          }
                          if (payments[1] != '') {
                            kumonRegFee = double.parse(payments[1]);
                          }
                          if (payments[2] != '') {
                            mathFee = double.parse(payments[2]);
                          }
                          if (payments[3] != '') {
                            readingFee = double.parse(payments[3]);
                          }
                          if (payments[4] != '') {
                            tutorialFee = double.parse(payments[4]);
                          }

                          try {
                            if (payments[5] != '') {
                              manualTuitionFee = double.parse(payments[5]);
                            }
                            if (payments[6] != '') {
                              manualEnrollmentFee = double.parse(payments[6]);
                            }
                            if (payments[7] != '') {
                              othersFee = double.parse(payments[7]);
                            }
                          } catch (e) {}

                          if (packageNum == 3) {
                            enrollmentFee /= installment;
                          }

                          if (packageNum == 0) {
                            tuitionFee = manualTuitionFee;
                            enrollmentFee = manualEnrollmentFee;
                          }

                          if (packageNum == 1) {
                            if (enrollmentFee != null && enrollmentFee != 0.0) {
                              _preSchoolPayments.add(PaymentDetail(label: 'ENROLLMENT FEES', amount: localCurrencyFormat(totalAnnualPackageOneFee), isPaid: paymentDate != 'Unpaid'));
                            }
                          } else {
                            if (enrollmentFee != null && enrollmentFee != 0.0) {
                              _preSchoolPayments.add(PaymentDetail(label: 'ENROLLMENT FEES', amount: localCurrencyFormat(enrollmentFee), isPaid: paymentDate != 'Unpaid'));
                            }
                            if (tuitionFee != null && tuitionFee != 0.0) {
                              _preSchoolPayments.add(PaymentDetail(label: 'TUITION FEE', amount: localCurrencyFormat(tuitionFee), isPaid: paymentDate != 'Unpaid'));
                            }
                          }

                          if (mathFee != null && mathFee != 0.0) {
                            _kumonPayments.add(PaymentDetail(label: 'MATH', amount: localCurrencyFormat(mathFee), isPaid: paymentDate != 'Unpaid'));
                          }
                          if (readingFee != null && readingFee != 0.0) {
                            _kumonPayments.add(PaymentDetail(label: 'READING', amount: localCurrencyFormat(readingFee), isPaid: paymentDate != 'Unpaid'));
                          }
                          if (kumonRegFee != null && kumonRegFee != 0.0) {
                            _kumonPayments.add(PaymentDetail(label: 'REGISTRATION FEE', amount: localCurrencyFormat(kumonRegFee), isPaid: paymentDate != 'Unpaid'));
                          }
                        } else {
                          _preSchoolPayments.add(PaymentDetail(label: amountDesc.toUpperCase(), amount: localCurrencyFormat(amountDue), isPaid: paymentDate != 'Unpaid'));
                        }

                        return Column(
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
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            DashboardTile(
                                              label: 'Due Date',
                                              displayPlainValue: true,
                                              value: date,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            DashboardTile(
                                              label: 'Date of Payment',
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
                                  child: Column(children: <Widget>[
                                    _preSchoolPayments.length > 0 ? PaymentDataView(title: 'Preschool', payments: _preSchoolPayments) : Container(),
                                    _kumonPayments.length > 0 ? PaymentDataView(title: 'Kumon', payments: _kumonPayments) : Container(),
                                    tutorialFee != 0.0 && tutorialFee != null
                                        ? PaymentDataView(
                                            title: 'Tutorial',
                                            payments: [
                                              PaymentDetail(
                                                label: 'REGISTRATION FEE',
                                                amount: '₱${tutorialFee + 0.00}',
                                                isPaid: paymentDate != 'Unpaid',
                                              )
                                            ],
                                          )
                                        : Container(),
                                    othersFee != 0.0 && othersFee != null
                                        ? PaymentDataView(
                                            title: '',
                                            payments: [
                                              PaymentDetail(
                                                label: 'OTHERS',
                                                amount: '₱${othersFee + 0.00}',
                                                isPaid: paymentDate != 'Unpaid',
                                              ),
                                            ],
                                          )
                                        : Container()
                                  ]),
                                ),
                                Divider(height: 1.0, color: Colors.grey[300]),
                              ],
                            ),
                            paymentNote != '' && paymentNote != null
                                ? Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.description,
                                              size: 16.0,
                                              semanticLabel: 'Note icon',
                                              color: Colors.amber[700],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 2.0),
                                            ),
                                            Text(
                                              'Note',
                                              style: TextStyle(
                                                color: Colors.amber[700],
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 3.0),
                                          child: Text(
                                            paymentNote,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            paymentDate != 'Unpaid'
                                ? Column(
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
                                                        'Official Receipt',
                                                        style: TextStyle(
                                                          color: Colors.grey[500],
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 3.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            Text(
                                                              '#',
                                                              style: TextStyle(color: Colors.grey[500]),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 1.0),
                                                            ),
                                                            Text(
                                                              '${paymentType['official_receipt']}',
                                                              style: TextStyle(
                                                                fontSize: 18.0,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.black87,
                                                              ),
                                                            ),
                                                          ],
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
                                                        'Mode of Payment',
                                                        style: TextStyle(
                                                          color: Colors.grey[500],
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 3.0),
                                                        child: Text(
                                                          capitalize(paymentType['type']),
                                                          style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black87,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                paymentType['bank_name'] != null
                                                    ? Column(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(vertical: 6.0),
                                                            child: Column(
                                                              children: <Widget>[
                                                                Text(
                                                                  'Check Number',
                                                                  style: TextStyle(
                                                                    color: Colors.grey[500],
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 14.0,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.symmetric(vertical: 3.0),
                                                                  child: Text(
                                                                    payment.checkNo ?? 'n/a',
                                                                    style: TextStyle(
                                                                      fontSize: 18.0,
                                                                      fontWeight: payment.checkNo != null ? FontWeight.w600 : FontWeight.w400,
                                                                      color: payment.checkNo != null ? Colors.black87 : Colors.black54,
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
                                                                  'Bank',
                                                                  style: TextStyle(
                                                                    color: Colors.grey[500],
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 14.0,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.symmetric(vertical: 3.0),
                                                                  child: Text(
                                                                    paymentType['bank_name'] ?? '',
                                                                    style: TextStyle(
                                                                      fontSize: 18.0,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Colors.black87,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(height: 1.0, color: Colors.grey[300]),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFF3F9BDF),
                                            borderRadius: BorderRadius.all(Radius.circular(14.0)),
                                            border: Border.all(
                                              width: 1.0,
                                              color: Color.fromRGBO(0, 0, 0, .075),
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                                          child: Flex(
                                            direction: Axis.horizontal,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Flexible(
                                                child: Text(
                                                  'GRAND TOTAL',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  localCurrencyFormat(amountPaid),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Container(
                                    padding: EdgeInsets.symmetric(vertical: 40.0),
                                    child: Text(
                                      'No payment information yet.',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 64.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
