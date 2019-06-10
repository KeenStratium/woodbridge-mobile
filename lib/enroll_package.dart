import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

class EnrollPackage extends StatefulWidget {
  @override
  _EnrollPackageState createState() => _EnrollPackageState();
}

class _EnrollPackageState extends State<EnrollPackage> {
  List<bool> isExpandedPanels = [true, false, false];
  double kumonRegFee = 500.00;
  List note = [];
  // Pre-School
  String preSchoolHeader = 'Choose Pre-School';
  String preSchoolPackageHeader = '';
  String preSchoolGradeLevel;
  String _selectedPackage;
  List<String> _preschoolLevels = ['Toddler', 'Nursery', 'Pre-Kindergarten', 'Kindergarten'];
  int schoolPackageNum = -1;
  // Kumon
  String kumonHeader = 'Choose Kumon';
  String kumonGradeLevel;
  String kumonSelectedPackage;
  List<String> _kumonLevels = ['Pre-Kindergarten', 'Kindergarten', 'Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5'];
  List<String> kumonSelectedPackages = [];
  List<bool> kumonPackages = [false, false];
  List<double> kumonFee = [1800.00, 1800.00];
  // Tutorial
  String tutorialHeader = 'Choose Tutorial';
  String tutorialSelectedPackage;
  List<String> tutorialLabels = ['Half (₱1,250.00)', 'Full (₱2,500.00)'];
  List<double> tutorialFees = [1250, 2500];
  int tutorialRadioValue = -1;

  @override
  Widget build(BuildContext context) {
    note = [];

    note.add(schoolPackageNum);
    kumonPackages[0] || kumonPackages[1] ? note.add(kumonRegFee) : note.addAll([0,0,0]);
    kumonPackages[0] ? note.add(kumonFee[0]) : note.add(0);
    kumonPackages[1] ? note.add(kumonFee[1]) : note.add(0);
    tutorialRadioValue >= 0 ? note.add(tutorialFees[tutorialRadioValue]): note.add(0);

    print(note);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Enroll New Student'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(bottom: 20.0),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30.0),
                  child: Text(
                    'Enrollment Packages',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).accentColor
                    ),
                  ),
                ),
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded){
                    setState(() {
                      isExpandedPanels[index] = !isExpandedPanels[index];
                    });
                  },
                  children: <ExpansionPanel>[
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded){
                        return ListTile(
                          title: Column(
                            children: <Widget>[
                              Container(
                                child: preSchoolHeader != 'Choose Pre-School' ? Text(
                                  'Pre-School',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600]
                                  ),
                                ) : Container(),
                                width: double.infinity,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    preSchoolHeader,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 18.0
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
                                  _selectedPackage == '' ? Container() : Text(
                                    _selectedPackage ?? '',
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      canTapOnHeader: true,
                      body: Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  'Grade Level',
                                  style: TextStyle(
                                    fontSize: 16.0
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                DropdownButton(
                                  hint: Text('Please choose a level'), // Not necessary for Option 1
                                  value: preSchoolGradeLevel,
                                  onChanged: (newValue) {
                                    setState(() {
                                      preSchoolGradeLevel = newValue;
                                      preSchoolHeader = newValue;
                                    });
                                  },
                                  items: _preschoolLevels.map((location) {
                                    return DropdownMenuItem(
                                      child: Text(location),
                                      value: location,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20.0),
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                'Choose School Package',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                  onTap: () {
                                    setState(() {
                                      _selectedPackage = 'Full Paid';
                                      schoolPackageNum = 1;
                                    });
                                  },
                                  splashColor: Theme.of(context).accentColor,
                                  child: PackageOptionCard(
                                    packageName: 'Full Paid',
                                    uponEnrollmentFee: '₱54,000.00',
                                    packageDesc: Column(
                                      children: <Widget>[
                                        PackageDescLabelField(
                                          label: 'Total Annual Fee',
                                          value: '₱56,000.0',
                                        ),
                                        PackageDescLabelField(
                                          label: 'Less 5% discount',
                                          value: '-₱2,000.00',
                                        )
                                      ],
                                    ),
                                    isSelected: _selectedPackage == 'Full Paid'
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                  onTap: () {
                                    setState(() {
                                      _selectedPackage = 'Monthly';
                                      schoolPackageNum = 2;
                                    });
                                  },
                                  splashColor: Theme.of(context).accentColor,
                                  child: PackageOptionCard(
                                      packageName: 'Monthly',
                                      uponEnrollmentFee: '₱16,300.00',
                                      packageDesc: Column(
                                        children: <Widget>[
                                          PackageDescLabelField(
                                            label: 'Enrollment Fees',
                                            value: '₱10,600.0',
                                          ),
                                          PackageDescLabelField(
                                            label: 'July Tuition Fee',
                                            value: '₱4,300.00',
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10.0),
                                          ),
                                          Text(
                                            'Monthly Tuition Fee From Aug To Apr (Due Every 5th Of The Month)',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey[800]
                                            ),
                                          ),
                                          Text(
                                            '₱4,300.00',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                      isSelected: _selectedPackage == 'Monthly'
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                  onTap: () {
                                    setState(() {
                                      _selectedPackage = 'Installment';
                                      schoolPackageNum = 3;
                                    });
                                  },
                                  splashColor: Theme.of(context).accentColor,
                                  child: PackageOptionCard(
                                      packageName: 'Installment',
                                      uponEnrollmentFee: '₱6,950.00',
                                      packageDesc: Column(
                                        children: <Widget>[
                                          PackageDescLabelField(
                                            label: 'Enrollment Fees',
                                            value: '₱10,600.0 / 4',
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10.0),
                                          ),
                                          PackageDescLabelField(
                                            label: 'July 15',
                                            value: '₱2,650.00',
                                          ),
                                          PackageDescLabelField(
                                            label: 'July 31',
                                            value: '₱6,950.00',
                                          ),
                                          PackageDescLabelField(
                                            label: 'August 15',
                                            value: '₱2,650.00',
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10.0),
                                          ),
                                          Text(
                                            'Monthly Tuition Fee From Aug To Apr (Due Every 5th Of The Month)',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey[800]
                                            ),
                                          ),
                                          Text(
                                            '₱4,300.00',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                      isSelected: _selectedPackage == 'Installment'
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      isExpanded: isExpandedPanels[0]
                    ),
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded){
                        return ListTile(
                          title: Column(
                            children: <Widget>[
                              Container(
                                child: kumonHeader != 'Choose Kumon' ? Text(
                                  'Kumon',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600]
                                  ),
                                ) : Container(),
                                width: double.infinity,
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Text(
                                    kumonHeader,
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 18.0
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
                                  Expanded(
                                    child: kumonSelectedPackages.length > 0 ? Text(
                                      "${kumonSelectedPackages[0] ?? ''}${kumonSelectedPackages.length > 1 ? ' & ${kumonSelectedPackages[1]}' : ''}",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.0
                                      ),
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                    ) : Container(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      canTapOnHeader: true,
                      body: Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  'Grade Level',
                                  style: TextStyle(
                                      fontSize: 16.0
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                DropdownButton(
                                  hint: Text('Please choose a level'), // Not necessary for Option 1
                                  value: kumonGradeLevel,
                                  onChanged: (newValue) {
                                    setState(() {
                                      kumonGradeLevel = newValue;
                                      kumonHeader = newValue;
                                    });
                                  },
                                  items: _kumonLevels.map((location) {
                                    return DropdownMenuItem(
                                      child: Text(location),
                                      value: location,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Flex(
                                direction: Axis.vertical,
                                children: <Widget>[
                                  Flexible(
                                    flex: 0,
                                    child: Row(
                                      children: <Widget>[
                                        Checkbox(
                                          onChanged: (bool newState) {
                                            setState((){
                                              kumonPackages[0] = !kumonPackages[0];
                                              if(kumonPackages[0]){
                                                kumonSelectedPackages.add('Math');
                                              }else{
                                                kumonSelectedPackages.remove('Math');
                                              }
                                            });
                                          },
                                          value: kumonPackages[0],
                                        ),
                                        Text(
                                          'Math (₱1,800.00)',
                                          style: TextStyle(
                                              fontSize: 16.0
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 0,
                                    child: Row(
                                      children: <Widget>[
                                        Checkbox(
                                          onChanged: (bool newState) {
                                            setState((){
                                              kumonPackages[1] = !kumonPackages[1];
                                              if(kumonPackages[1]){
                                                kumonSelectedPackages.add('Reading');
                                              }else{
                                                kumonSelectedPackages.remove('Reading');
                                              }
                                            });
                                          },
                                          value: kumonPackages[1],
                                        ),
                                        Text(
                                          'Reading (₱1,800.00)',
                                          style: TextStyle(
                                              fontSize: 16.0
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      isExpanded: isExpandedPanels[1]
                    ),
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded){
                        return ListTile(
                          title: Column(
                            children: <Widget>[
                              Container(
                                child: tutorialSelectedPackage != null ? Text(
                                  'Tutorial',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600]
                                  ),
                                ) : Container(),
                                width: double.infinity,
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Text(
                                    tutorialSelectedPackage != null ? '' : tutorialHeader,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 18.0
                                    ),
                                  ),
                                  Expanded(
                                    child: tutorialSelectedPackage != null ? Text(
                                      "$tutorialSelectedPackage",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.0
                                      ),
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                    ) : Container(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      canTapOnHeader: true,
                      body: Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: <Widget>[
                            InputRadioButton(
                              radioValue: tutorialRadioValue,
                              radioValueLabels: tutorialLabels,
                              label: 'Package',
                              direction: 'col',
                              onChangeCallback: (value) {
                                setState((){
                                  if(value == 0){
                                    tutorialSelectedPackage = 'Half';
                                  }else if(value == 1){
                                    tutorialSelectedPackage = 'Full';
                                  }
                                  tutorialRadioValue = value;
                                });
                              }
                            )
                          ],
                        ),
                      ),
                      isExpanded: isExpandedPanels[2]
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PackageOptionCard extends StatefulWidget {
  String packageName;
  String uponEnrollmentFee;
  Widget packageDesc;
  bool isSelected;

  PackageOptionCard({
    this.packageName,
    this.uponEnrollmentFee,
    this.packageDesc,
    this.isSelected
  });


@override
  _PackageOptionCardState createState() => _PackageOptionCardState();
}

class _PackageOptionCardState extends State<PackageOptionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isSelected ? Theme.of(context).accentColor : Colors.grey[300]
        ),
        borderRadius: BorderRadius.all(Radius.circular(7.0))
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: widget.isSelected ? Theme.of(context).accentColor : Colors.grey[100],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0), topRight: Radius.circular(6.0))
            ),
            child: Text(
              widget.packageName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: widget.isSelected ? Colors.white : Colors.grey[800]
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.uponEnrollmentFee,
                        style: TextStyle(
                            fontSize: 24.0,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(
                        'Total Due upon Enrollment',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[350],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: widget.packageDesc,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PackageDescLabelField extends StatelessWidget {
  String label;
  String value;

  PackageDescLabelField({
    this.label,
    this.value
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800]
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              value,
              softWrap: false,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800]
              ),
            ),
          )
        ],
      ),
    );
  }
}