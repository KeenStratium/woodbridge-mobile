import 'dart:async';
import 'dart:convert';
import 'model.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_picker.dart';

import 'woodbridge-ui_components.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

Future setHandbookAgreement(userId) async {
  String url = '$baseApi/account/handbook-onboard-agree';

  var response = await http.post(url,
      body: json.encode({
        'data': {'user_id': userId}
      }),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'});

  return jsonDecode(response.body);
}

class InitialOnboard extends StatefulWidget {
  InitialOnboard({this.userIds: const <String>[], this.showAgreementCta, this.userId});

  final bool showAgreementCta;
  final String userId;
  final List<String> userIds;

  @override
  _InitialOnboardState createState() => _InitialOnboardState();
}

class _InitialOnboardState extends State<InitialOnboard> {
  String buttonLabel = "Please read the Parent's Handbook Guide";

  bool hasFinishedLoading = true;
  bool _enableAgreementBtn = false;
  PdfController _pdfController;
  int _allPagesCount = 0;

  @override
  void initState() {
    super.initState();

    _pdfController = PdfController(
      document: PdfDocument.openAsset('files/TWAMobileParentsGuide.pdf'),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_enableAgreementBtn == false) {
      _enableAgreementBtn = (_pdfController.page == _allPagesCount);
      if (_enableAgreementBtn) {
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
            hasFinishedLoading
                ? Expanded(
                    child: mounted
                        ? PdfView(
                            documentLoader: Center(child: CircularProgressIndicator()),
                            pageLoader: Center(child: CircularProgressIndicator()),
                            controller: _pdfController,
                            onDocumentLoaded: (document) {
                              setState(() {
                                _allPagesCount = document.pagesCount;
                              });
                            },
                            onPageChanged: (page) {
                              setState(() {});
                            },
                          )
                        : Container(),
                  )
                : Expanded(
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
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        )
                      ],
                    ),
                  ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 20.0),
              decoration: BoxDecoration(color: Colors.white),
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
                                  color: _pdfController.page == 1 ? Colors.grey[400] : Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _pdfController.previousPage(duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                                  });
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
                                    color: _pdfController.page == _allPagesCount
                                        ? Colors.grey[400]
                                        : _enableAgreementBtn ? Colors.grey[600] : Theme.of(context).accentColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _pdfController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                                    });
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  widget.showAgreementCta
                      ? accentCtaButton(
                          label: buttonLabel,
                          isDisabled: !_enableAgreementBtn,
                          onPressed: () {
                            setHandbookAgreement(widget.userId).then((resolves) {
                              Route route = MaterialPageRoute(builder: (BuildContext context) {
                                return StudentPicker(users: widget.userIds);
                              });
                              Navigator.push(context, route);
                            });
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
