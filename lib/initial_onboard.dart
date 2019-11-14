import 'dart:async';
import 'dart:convert';
import 'model.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_picker.dart';

import 'woodbridge-ui_components.dart';

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
  InitialOnboard({
    this.pages,
    this.userIds,
    this.showAgreementCta,
    this.userId
  });

  int currentPage = 0;
  bool hasFinishedLoading = false;
  List<Widget> pages = <Widget>[];
  int prevPage = 0;
  bool showAgreementCta;
  String userId;
  List<String> userIds = <String>[];

  @override
  _InitialOnboardState createState() => _InitialOnboardState();
}

class _InitialOnboardState extends State<InitialOnboard> {
  String buttonLabel = "Please read the Parent's Handbook Guide";

  bool _enableAgreementBtn = false;

  @override
  void initState() {
    super.initState();

    loopTimer();
  }

  Widget loadPdf(int pageNumber) {
    return widget.pages[pageNumber];
  }

  void loopTimer() async {
    var future = new Future.delayed(const Duration(milliseconds: 100));
    if(widget.pages.length >= (14 - 2)){
      setState(() {
        widget.hasFinishedLoading = true;
      });
    }else{
      widget.hasFinishedLoading = false;
      await future.then((result) {
        loopTimer();
      });
    }
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
            widget.hasFinishedLoading ? Expanded(
              child: mounted ? loadPdf(widget.currentPage) : Container(),
            ) : Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 32.0, maxHeight: 32.0),
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Fetching Parent's Guide...",
                      style: TextStyle(
                        color: Colors.grey[500]
                      ),
                    ),
                  )
                ],
              ),
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
                                  if(widget.currentPage >= 1 && mounted){
                                    setState(() {
                                      widget.currentPage--;
                                    });
                                  }
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
                                  if(widget.currentPage < maxPage - 1 && mounted){
                                    setState(() {
                                      widget.currentPage++;
                                    });
                                  }
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