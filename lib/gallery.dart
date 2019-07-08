import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'package:photo_view/photo_view.dart';
import 'services.dart';

Future getClassImages(classId, pageSize, pageNum) async {
  String url = '$baseApi/student/get-images-from-class';

  var response = await http.post(url, body: json.encode({
    'data': classId,
    'page_size': pageSize,
    'page_num': pageNum
  }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });

  return jsonDecode(response.body);
}

List<Widget> _photos = <Widget>[];

class PhotoCard extends StatelessWidget {
  final int id;
  final String imgUrl;
  final DateTime timeStamp;
  final String caption;
  String militaryTime;

  PhotoCard({
    this.id,
    this.imgUrl,
    this.timeStamp,
    this.caption
  });

  @override
  Widget build(BuildContext context) {
    militaryTime = '${timeStamp.hour}:${timeStamp.minute}';
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
      margin: EdgeInsets.only(bottom: 16.0),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(11.0)),
                 boxShadow: [BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, .2),
                  blurRadius: 15.0,
                  offset: Offset(1.0, 3.0),
                  spreadRadius: -4.0
                )]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${timeFormat(this.timeStamp.toString(), "MMMM d")}, ${formatMilitaryTime(militaryTime)}",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: GestureDetector(
                       onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HeroPhotoViewWrapper(
                              imageProvider: NetworkImage(imgUrl),
                              id: this.id
                            )
                          ));
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 200.0),
                        child: Container(
                          alignment: Alignment(1.0, 1.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                          ),
                          child: Hero(
                            tag: this.id,
                            child:  Image.network(
                              imgUrl,
                              fit: BoxFit.fitWidth
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    child: Text(
                      this.caption,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeroPhotoViewWrapper extends StatelessWidget {
  const HeroPhotoViewWrapper(
      {this.imageProvider,
      this.loadingChild,
      this.backgroundDecoration,
      this.minScale,
      this.maxScale,
      this.id
      });

  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          imageProvider: imageProvider,
          loadingChild: loadingChild,
          backgroundDecoration: backgroundDecoration,
          minScale: minScale,
          maxScale: maxScale,
          heroTag: id,
        ));
  }
}

class ActivityGallery extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userId;
  final String classId;
  int pageNum = 1;
  int pageSize = 2;
  bool isLastItem = false;
  bool isLoading = false;
  bool noMoreImages = false;

  ActivityGallery({
    this.firstName,
    this.lastName,
    this.userId,
    this.classId
  });

  @override
  _ActivityGalleryState createState() => _ActivityGalleryState();
}

class _ActivityGalleryState extends State<ActivityGallery> {
  ScrollController _scrollController = ScrollController();
  
  void fetchClassImages(classId, pageSize, pageNum) async {
    return await getClassImages(classId, pageSize, pageNum)
      .then((results) {
        setState(() {
          if(_photos.length != 1){
            _photos.removeLast();
          }
          if(results.length == 0){
            widget.noMoreImages = true;
          }else{
            for(int i = 0; i < results.length; i++){
              Map photo = results[i];
              _photos.add(PhotoCard(
                id: photo['id'],
                imgUrl: '${baseServer}/${photo['img_url']}',
                timeStamp: DateTime.parse(photo['date_posted']).toLocal(),
                caption: photo['caption']
              ));
            }
          }
          widget.isLoading = false;
        });
      });
  }

  void _loadMore() {
    widget.pageNum++;
    setState(() {
      fetchClassImages(widget.classId, widget.pageSize, widget.pageNum);
    });
  }

  @override
  void initState(){
    super.initState();

    _photos = <Widget>[
      Padding(
        padding: EdgeInsets.only(bottom: 32.0),
        child: ProfileHeader(
          firstName: this.widget.firstName,
          lastName: this.widget.lastName,
          heroTag: this.widget.userId,
        ),
      ),
    ];

    setState(() {
      widget.isLoading = true;
      fetchClassImages(widget.classId, widget.pageSize, widget.pageNum);
    });

    _scrollController.addListener(() {
      if(!widget.noMoreImages){
        if (_scrollController.position.pixels >=
          (_scrollController.position.maxScrollExtent) - 100) {
            if(!widget.isLoading){
              setState(() {
                _photos.add(
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                    margin: EdgeInsets.only(bottom: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      color: Colors.white
                    ),
                    child: Text(
                      'Fetching more photos...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0
                      ),
                    ),
                  )
                );
              });
              widget.isLoading = true;
              _loadMore();
            }
          }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Gallery'),
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: ListView.builder(
                  itemCount: _photos.length,
                  itemBuilder: (context, i){
                    return _photos[i];
                  },
                  controller: _scrollController,
                  shrinkWrap: true,
                ),
              )
            ),
          ],
        )
      ),
    );
  }
}