import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'services.dart';

class MessageBoard extends StatefulWidget {
  String userId;
  String firstName;
  String lastName;
  int pageSize = 10;
  int pageNum = 1;
  List<List<Widget>> messageBoardLists;

  MessageBoard({
    this.userId,
    this.pageSize,
    this.pageNum,
    this.messageBoardLists,
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
      appBar: AppBar(
        title: Text('Message Board'),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            child: Flex(
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
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                      child: Column(
                        children: widget.messageBoardLists[widget.pageNum - 1],
                      )
                    ),
                  ),
                )
              ],
            ),
          ),
          PaginationControl(
            pageNum: widget.pageNum,
            prevCallback: () {
              setState(() {
                widget.pageNum--;
                print(widget.pageNum);
              });
            },
            nextCallback: () async {
              widget.pageNum++;

              if(widget.pageNum == widget.messageBoardLists.length){
                await buildMessageList(widget.userId, widget.pageSize, widget.pageNum)
                  .then((result) {
                    widget.messageBoardLists.addAll(result['messages']);
                  });
              }
              setState(() {
                print(widget.pageNum);
              });
            },
            nextDisableCondition: widget.messageBoardLists[widget.pageNum].length == 0 || widget.messageBoardLists[widget.pageNum - 1].length == 0,
          )
        ],
      ),
    );
  }
}