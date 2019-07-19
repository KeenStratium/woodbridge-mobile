import 'dart:async';
import 'dart:convert';
import 'model.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'student_picker.dart';

import 'woodbridge-ui_components.dart';

_setLoggedInStatus(bool status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setBool('isLoggedIn', status);
}

Future setHandbookAgreement(userId) async {
  String url = '$baseApi/account/handbook-onboard-agree';

  var response = await http.post(url, body: json.encode({
    'data': {
      'user_id': userId
    }
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body);
}

class InitialOnboard extends StatefulWidget {
  int currentPage = 0;
  int prevPage = 0;
  List<Widget> pages = <Widget>[];
  List<String> userIds = <String>[];
  bool showAgreementCta;
  String userId;

  InitialOnboard({
    this.pages,
    this.userIds,
    this.showAgreementCta,
    this.userId
  });

  @override
  _InitialOnboardState createState() => _InitialOnboardState();
}

class _InitialOnboardState extends State<InitialOnboard> {
  bool _enableAgreementBtn = false;
  String buttonLabel = "Please read the Parent's Handbook Guide";

  Widget loadPdf(int pageNumber) {
    return widget.pages[pageNumber];
  }

  @override
  Widget build(BuildContext context) {
    int maxPage = widget.pages.length;

    if(_enableAgreementBtn == false){
      _enableAgreementBtn = (widget.currentPage == maxPage - 1);
      if(_enableAgreementBtn){
        buttonLabel = "I have read the Parent's Handbook Guide";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: !widget.showAgreementCta ? Text("Parent's Handbook Guide") : Text('Welcome to myWoodbridge'),
      ),
      body: Container(
        width: double.infinity,
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: mounted ? loadPdf(widget.currentPage) : Container(),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 20.0),
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Material(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.chevron_left,
                                  color: widget.currentPage == 0 ? Colors.grey[400] : Colors.grey[600],
                                ),
                                onPressed: (){
                                  widget.currentPage >= 1 ?
                                  mounted ? setState(() {
                                    widget.currentPage--;
                                  }) : null : null;
                                },
                              ),
                            ),
                          ),
                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.chevron_right,
                                  color: widget.currentPage == maxPage - 1 ? Colors.grey[400] : _enableAgreementBtn ? Colors.grey[600] : Theme.of(context).accentColor,
                                ),
                                onPressed: (){
                                  widget.currentPage < maxPage - 1 ?
                                  mounted ? setState(() {
                                    widget.currentPage++;
                                  }) : null : null;
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  widget.showAgreementCta ? accentCtaButton(
                    label: buttonLabel,
                    isDisabled: !_enableAgreementBtn,
                    onPressed: (){
                      setHandbookAgreement(widget.userId)
                        .then((resolves) {
                          _setLoggedInStatus(true);
                          Route route = MaterialPageRoute(
                              builder: (BuildContext context) {
                                return StudentPicker(users: widget.userIds);
                              });
                          Navigator.push(context, route);
                        });
                    },
                  ) : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}