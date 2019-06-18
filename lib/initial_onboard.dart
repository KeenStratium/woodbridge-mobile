import 'dart:async';
import 'dart:convert';
import 'colors.dart';
import 'model.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_picker.dart';

import 'woodbridge-ui_components.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class InitialOnboard extends StatefulWidget {
  int currentPage = 0;
  int prevPage = 0;
  List<Widget> pages = <Widget>[];
  List<String> userIds = <String>[];

  InitialOnboard({
    this.pages,
    this.userIds
  });

  @override
  _InitialOnboardState createState() => _InitialOnboardState();
}

class _InitialOnboardState extends State<InitialOnboard> {
  bool _enableAgreementBtn = false;
  String buttonLabel = "Please read the Parent's Handbook Guide";

  Future loadPdf(int pageNumber) async {
    return widget.pages[pageNumber];
  }


  @override
  Widget build(BuildContext context) {
    int maxPage = widget.pages.length;
    print(_enableAgreementBtn);

    if(_enableAgreementBtn == false){
      _enableAgreementBtn = (widget.currentPage == maxPage - 1);
      if(_enableAgreementBtn){
        buttonLabel = "I have read the Parent's Handbook Guide";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to myWoodbridge'),
      ),
      body: Container(
        width: double.infinity,
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: loadPdf(widget.currentPage),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    return snapshot.data ?? Container();
                  }else {
                    return Center(child: Text('Loading guide...'));
                  }
                },
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
                                  print(widget.currentPage);
                                  widget.currentPage >= 1 ?
                                  setState(() {
                                    widget.currentPage--;
                                    widget.prevPage = widget.currentPage;
                                  }) : null;
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
                                  setState(() {
                                    widget.currentPage++;
                                    widget.prevPage = widget.currentPage;
                                  }) : null;
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  accentCtaButton(
                    label: buttonLabel,
                    isDisabled: !_enableAgreementBtn,
                    onPressed: (){
                      Route route = MaterialPageRoute(
                          builder: (BuildContext context) {
                            return StudentPicker(users: widget.userIds);
                          });
                      Navigator.push(context, route);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}