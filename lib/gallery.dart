import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'package:photo_view/photo_view.dart';

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

List<Widget> _photos = <Widget>[
  PhotoCard()
];

class PhotoCard extends StatelessWidget {
  final int id;
  final String imgUrl;

  PhotoCard({
    this.id,
    this.imgUrl
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.0, bottom: 32.0),
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
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'June 22, 8:14am',
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
                      '"one love" drawing by kindergarten project. What a phenomenal art!',
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
  final String classId = 'NUR-15560-2019';
  int pageNum = 1;
  int pageSize = 2;
  bool isLastItem = false;
  bool isLoading = false;
  bool noMoreImages = false;

  ActivityGallery({
    this.firstName,
    this.lastName,
    this.userId
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
          if(results.length == 0){
            widget.noMoreImages = true;
            print('finished fetching');
          }else{
            for(int i = 0; i < results.length; i++){
              Map photo = results[i];
              _photos.add(PhotoCard(
                id: photo['id'],
                imgUrl: photo['img_url'],
              ));
              print(photo['id']);
            }
          }
          widget.isLoading = false;
        });
      });
  }

  void _loadMore() {
    widget.pageNum++;
    setState(() {
      print('loading more,...');
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
      widget.pageNum++;
    });

    _scrollController.addListener(() {
      if(!widget.noMoreImages){
        if (_scrollController.position.pixels >=
          (_scrollController.position.maxScrollExtent) - 100) {
            if(!widget.isLoading){
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
                margin: EdgeInsets.symmetric(horizontal: 6.0),
                child: ListView.builder(
                  itemCount: _photos.length,
                  itemBuilder: (context, i){
                    return _photos[i];
                  },
                  controller: _scrollController,
                  shrinkWrap: true,
                ),
              )
            )
          ],
        )
      ),
    );
  }
}