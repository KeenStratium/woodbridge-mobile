import 'dart:async';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'message_services.dart';

class MessageBoard extends StatefulWidget {
  String userId;
  String firstName;
  String lastName;
  int pageSize = 6;
  int pageNum = 1;
  List<List<Widget>> messageBoardLists = <List<Widget>>[];
  bool hasInitiated = false;

  MessageBoard({
    this.userId,
    this.firstName,
    this.lastName
  });

  @override
  _MessageBoardState createState() => _MessageBoardState();
}

class _MessageBoardState extends State<MessageBoard> {
  List<String> responseActions = ['Going', 'Not going', 'Undecided'];
  List<Widget> boards = <Widget>[];

  @override
  Widget build(BuildContext context) {
    boards = <Widget>[];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Message Board'),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flexible(
            flex: 0,
            child: ProfileHeader(
              firstName: widget.firstName,
              lastName: widget.lastName,
              heroTag: widget.userId,
            ),
          ),
          FutureBuilder(
            future: !widget.hasInitiated ? buildMessageList(widget.userId, widget.pageSize, widget.pageNum, widget.hasInitiated) : Future.value(<Widget>[Container()]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.connectionState == ConnectionState.done || widget.hasInitiated){
                if(!widget.hasInitiated){
                  widget.messageBoardLists = snapshot.data['messages'];
                  widget.hasInitiated = true;
                }
                return  Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: widget.messageBoardLists[0].length != 0 ? SingleChildScrollView(
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                              child: Column(
                                children: widget.messageBoardLists[widget.pageNum - 1],
                              )
                          ),
                        ) : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "No messages yet. We'll let you know if we've got something for you.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[500]
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 0,
                        child: PaginationControl(
                          pageNum: widget.pageNum,
                          prevCallback: () {
                            setState(() {
                              widget.pageNum--;
                            });
                          },
                          nextCallback: () async {
                            widget.pageNum++;

                            if(widget.pageNum == widget.messageBoardLists.length) {
                              await buildMessageList(widget.userId, widget.pageSize, widget.pageNum, widget.hasInitiated)
                                .then((result) {
                                  widget.messageBoardLists.addAll(result['messages']);
                                });
                            }
                            setState(() {});
                          },
                          nextDisableCondition: widget.messageBoardLists[widget.pageNum].length == 0 || widget.messageBoardLists[widget.pageNum - 1].length == 0,
                        ),
                      )
                    ],
                  ),
                );
              }else{
                return Center(
                  child: Text('Fetching messages for you...'),
                );
              }
            }),
        ],
      )
    );
  }
}