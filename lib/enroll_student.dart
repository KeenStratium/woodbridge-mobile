import 'package:flutter/material.dart';
import 'dart:async';

import 'woodbridge-ui_components.dart';
import 'home_page.dart';

class EnrollStudent extends StatefulWidget {
  @override
  _EnrollStudentState createState() => _EnrollStudentState();
}

class _EnrollStudentState extends State<EnrollStudent> {
  int _genderRadio = -1;

  bool _hadPriorSchooling = false;
  bool _homeTelNumNA = false;

  DateTime _dateBirth;

  List<String> sexLabels = ['Male', 'Female'];
  List _month = ['Jan.', 'Feb.', 'Mar.', 'Apr.', 'May', 'June', 'July', 'Aug.', 'Sep.', 'Oct.',' Nov.', 'Dec.'];

  // Student
  final _fnameController = TextEditingController();
  final _middleInitialController = TextEditingController();
  final _lnameController = TextEditingController();
  final _homeAddressController = TextEditingController();
  final _homeTelNumController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _religionController = TextEditingController();
  final _schoolHistoryController = TextEditingController();

  // Family
  List<String> titleLabels = ['Mr.', 'Mrs.', 'Dr.', 'Ms.', 'Arch.', 'Atty.', 'Engr.', 'Hon.', 'Other'];

  // Family - Father
  final _fatherFnameController = TextEditingController();
  final _fatherMiddleInitialController = TextEditingController();
  final _fatherLnameController = TextEditingController();
  final _fatherHomeAddrController = TextEditingController();
  final _fatherOccupationController = TextEditingController();
  final _fatherBusAddrController = TextEditingController();
  final _fatherBusTelNumController = TextEditingController();
  final _fatherMobileNumController = TextEditingController();
  final _fatherEmailAddrController = TextEditingController();
  String _fatherTitle;
  bool _fatherHomeAddrSIsSame = false;

  // Family - Mother
  final _motherFnameController = TextEditingController();
  final _motherMiddleInitialController = TextEditingController();
  final _motherLnameController = TextEditingController();
  final _motherHomeAddrController = TextEditingController();
  final _motherOccupationController = TextEditingController();
  final _motherBusAddrController = TextEditingController();
  final _motherBusTelNumController = TextEditingController();
  final _motherMobileNumController = TextEditingController();
  final _motherEmailAddrController = TextEditingController();
  String _motherTitle;
  bool _motherHomeAddrSIsSame = false;

  
  Future _selectDateBirth() async {
    _dateBirth = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2000),
        lastDate: (new DateTime.now()).add(new Duration(hours: 1))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text('Enroll New Student')
      ),
      bottomNavigationBar: BottomAppBar(
        shape: AutomaticNotchedShape(
          RoundedRectangleBorder(),
          StadiumBorder(side: BorderSide())
        ),
        color: Colors.white,
        notchMargin: 5.0,
        child: Row(
          children: <Widget>[
            /*Add the Items here*/
            Container(
              /*Padding changes the height*/
              padding: EdgeInsets.all(6.0),
              child: OutlineButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.cancel,
                  color: Colors.grey[500]
                ),
                label: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)
                ),
              )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context) => HomePage(
            child: Avatar(
              backgroundColor: Colors.cyan,
              maxRadius: 48.0,
              minRadius: 24.0,
              initial: 'KE',
              fontSize: 24.0,
            ),
            firstName: 'Keanu Kent',
            lastName: 'Gargar',
            heroTag: 'keanu',
          ));
          Navigator.push(context, route);
        },
        isExtended: true,
        label: Text('Enroll'),
        elevation: 4.0,
        icon: Icon(Icons.school),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          alignment: AlignmentDirectional.topCenter,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              alignment: AlignmentDirectional.topStart,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: AlignmentDirectional.topStart,
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Student's Basic Information",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  Form(
                    autovalidate: true,
                    child: Column(
                      children: <Widget>[
                        InputTextField(label: "First Name", controller: _fnameController),
                        InputTextField(label: "Middle Initial", controller: _middleInitialController),
                        InputTextField(label: "Last Name", controller: _lnameController),
                        InputRadioButton(radioValue: _genderRadio, radioValueLabels: sexLabels),
                        InputTextField(label: "Home Address", controller: _homeAddressController),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  controller: _homeTelNumController,
                                  style: TextStyle(
                                    color: _homeTelNumNA ? Colors.black38 : Colors.black87
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Home Telephone Number',
                                    labelText: 'Home Telephone Number',
                                  ),
                                  enabled: !_homeTelNumNA
                                ),
                              ),
                              Flexible(
                                flex: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    children: <Widget>[
                                      Checkbox(
                                        value: _homeTelNumNA,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _homeTelNumNA = !_homeTelNumNA;
                                          });
                                        },
                                      ),
                                      Text('N/A')
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Date of Birth: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0,
                                      color: Colors.black54
                                  )
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                      color: Color.fromRGBO(0, 0, 0, .03)
                                    ),
                                    child: Text(
                                      _dateBirth == null ? 'Please select date' : '${_month[_dateBirth.month - 1]} ${_dateBirth.day.toString()}, ${_dateBirth.year.toString()}',
                                      style: _dateBirth == null ? TextStyle(fontSize: 16.0, color: Colors.black38, fontWeight: FontWeight.w600) : TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 1.0),
                                    child: OutlineButton(
                                      onPressed: () {
                                        return _selectDateBirth();
                                      },
                                      borderSide: BorderSide(
                                        color: _dateBirth == null ? Colors.blueAccent : Colors.black12
                                      ),
                                      child: Text(
                                        _dateBirth == null ? 'Select Date' : 'Change Date',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: _dateBirth == null ? Colors.blueAccent : Colors.black54
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ),
                        InputTextField(label: "Place of Birth", controller: _placeOfBirthController),
                        InputTextField(label: "Religion", controller: _religionController),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Has your child had prior schooling?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0,
                                      color: Colors.black54
                                  )
                                ),
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    flex: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 32.0),
                                      child: Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: _hadPriorSchooling,
                                            onChanged: (bool value) {
                                              setState(() {
                                                _hadPriorSchooling = !_hadPriorSchooling;
                                              });
                                            },
                                          ),
                                          Text('YES')
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: TextFormField(
                                      controller: _schoolHistoryController,
                                      style: TextStyle(
                                        color: !_hadPriorSchooling ? Colors.black38 : Colors.black87
                                      ),
                                      decoration: InputDecoration(
                                          hintText: 'School History',
                                          labelText: 'If so, what school?'
                                      ),
                                      enabled: _hadPriorSchooling,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.topStart,
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Family Background",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  Form(
                    autovalidate: true,
                    child: Flex(
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: AlignmentDirectional.topStart,
                                margin: EdgeInsets.symmetric(vertical: 6.0),
                                child: Text(
                                  "Father",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                              InputTextField(label: "Father's First Name", controller: _fatherFnameController),
                              InputTextField(label: "Father's Middle Initial", controller: _fatherMiddleInitialController),
                              InputTextField(label: "Father's Last Name", controller: _fatherLnameController),
                              customFormField(
                                fieldTitle: "Father's Title",
                                child: InputDropdownButton(dropdownValueLabels: titleLabels, dropdownValue: _fatherTitle)
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextFormField(
                                      controller: _fatherHomeAddrController,
                                      style: TextStyle(
                                          color: _fatherHomeAddrSIsSame ? Colors.black38 : Colors.black87
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Home Address",
                                        labelText: "Home Address",
                                      ),
                                      enabled: !_fatherHomeAddrSIsSame
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Checkbox(
                                        value: _fatherHomeAddrSIsSame,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _fatherHomeAddrSIsSame = !_fatherHomeAddrSIsSame;
                                            if(value){
                                              _fatherHomeAddrController.text = _homeAddressController.text;
                                            }else {
                                              _fatherHomeAddrController.clear();
                                            }
                                          });
                                        },
                                      ),
                                      Text('same as student')
                                    ],
                                  ),
                                ],
                              ),
                              InputTextField(label: "Father's Occupation", controller: _fatherOccupationController),
                              InputTextField(label: "Business Address", controller: _fatherBusAddrController),
                              InputTextField(label: "Business Tel. #", controller: _fatherBusTelNumController),
                              InputTextField(label: "Mobile #", controller: _fatherMobileNumController),
                              InputTextField(label: "Email Address", controller: _fatherEmailAddrController),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: AlignmentDirectional.topStart,
                                margin: EdgeInsets.symmetric(vertical: 6.0),
                                child: Text(
                                  "Mother",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                              InputTextField(label: "Mother's First Name", controller: _motherFnameController),
                              InputTextField(label: "Mother's Middle Initial", controller: _motherMiddleInitialController),
                              InputTextField(label: "Mother's Last Name", controller: _motherLnameController),
                              customFormField(
                                  fieldTitle: "Mother's Title",
                                  child: InputDropdownButton(dropdownValueLabels: titleLabels, dropdownValue: _motherTitle)
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextFormField(
                                      controller: _motherHomeAddrController,
                                      style: TextStyle(
                                          color: _motherHomeAddrSIsSame ? Colors.black38 : Colors.black87
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Home Address",
                                        labelText: "Home Address",
                                      ),
                                      enabled: !_motherHomeAddrSIsSame
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Checkbox(
                                        value: _motherHomeAddrSIsSame,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _motherHomeAddrSIsSame = !_motherHomeAddrSIsSame;
                                            if(value){
                                              _motherHomeAddrController.text = _homeAddressController.text;
                                            }else {
                                              _motherHomeAddrController.clear();
                                            }
                                          });
                                        },
                                      ),
                                      Text('same as student')
                                    ],
                                  ),
                                ],
                              ),
                              InputTextField(label: "Mother's Occupation", controller: _motherOccupationController),
                              InputTextField(label: "Business Address", controller: _motherBusAddrController),
                              InputTextField(label: "Business Tel. #", controller: _motherBusTelNumController),
                              InputTextField(label: "Mobile #", controller: _motherMobileNumController),
                              InputTextField(label: "Email Address", controller: _motherEmailAddrController),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}

class InputTextField extends StatelessWidget {
  final double VerticalSpacing = 6.0;

  final String label;
  TextEditingController controller;

  InputTextField({
    this.label,
    this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: VerticalSpacing),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            hintText: label,
            labelText: label
        ),
      ),
    );
  }
}

class InputRadioButton extends StatefulWidget {
  int radioValue;
  final List<String> radioValueLabels;

  InputRadioButton({
    this.radioValue,
    this.radioValueLabels
  });

  @override
  _InputRadioButtonState createState() => _InputRadioButtonState();
}

class _InputRadioButtonState extends State<InputRadioButton> {
  List<Widget> listWidgets() {
    List<Widget> radioLabelWidgets = new List();

    for(int i = 0; i < widget.radioValueLabels.length; i++){
      final String label = widget.radioValueLabels[i];

      radioLabelWidgets.add(Flexible(
        child: RadioListTile(
          onChanged: (value) {
            setState(() {
              widget.radioValue = value;
            });
          },
          value: i,
          groupValue: widget.radioValue,
          title: Text(label),
        ),
      ));
    }

    return radioLabelWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              'Sex: ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
                color: Colors.black54
              )
            ),
          ),
          Flex(
            direction: Axis.horizontal,
            children: listWidgets()
          ),
        ],
      )
    );
  }
}

class InputDropdownButton extends StatefulWidget{
  final List<String> dropdownValueLabels;
  String dropdownValue;

  InputDropdownButton({
    this.dropdownValueLabels,
    this.dropdownValue
  });

  @override
  _InputDropdownButtonState createState() => _InputDropdownButtonState();
}

class _InputDropdownButtonState extends State<InputDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.dropdownValue ?? widget.dropdownValueLabels[0],
      onChanged: (String newValue) {
        setState(() {
          widget.dropdownValue = newValue;
        });
      },
      items: widget.dropdownValueLabels.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Text(value)
        );
      }).toList(),
    );
  }
}

class customFormField extends StatelessWidget {
  final String fieldTitle;
  final Widget child;

  customFormField({
    this.fieldTitle,
    this.child
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
                fieldTitle,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: Colors.black54
                )
            ),
          ),
          child
        ],
      ),
    );
  }
}