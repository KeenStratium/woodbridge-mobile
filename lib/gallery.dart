import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'model.dart';

import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'services.dart';

Future getClassImages(classId, pageSize, pageNum) async {
  String url = '$baseApi/student/get-images-from-class';
  var response = await http.post(url, body: json.encode({'data': classId, 'page_size': pageSize, 'page_num': pageNum}), headers: {'Accept': 'application/json', 'Content-Type': 'application/json'});

  return jsonDecode(response.body);
}

List<Widget> _photos = <Widget>[];

class PhotoCard extends StatelessWidget {
  PhotoCard({this.id, this.imgUrl, this.timeStamp, this.caption});

  final String caption;
  final int id;
  final String imgUrl;
  final DateTime timeStamp;

  @override
  Widget build(BuildContext context) {
    final String militaryTime = '${timeStamp.hour}:${timeStamp.minute}';

    DateTime now = DateTime.now();
    int currentEpoch = (now.millisecondsSinceEpoch / 1000).floor();
    var postDateEpoch = (timeStamp.millisecondsSinceEpoch / 1000).floor();

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
                  boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, .2), blurRadius: 15.0, offset: Offset(1.0, 3.0), spreadRadius: -4.0)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          epochToHumanTime(currentEpoch - postDateEpoch),
                          style: TextStyle(fontSize: 14.0, color: Colors.grey[700], fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "${timeFormat(this.timeStamp.toString(), "MMMM d")}, ${formatMilitaryTime(militaryTime)}",
                          style: TextStyle(fontSize: 12.0, color: Colors.grey[500], fontWeight: FontWeight.w700),
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
                              imageProvider: CachedNetworkImageProvider(imgUrl),
                              id: this.id,
                              caption: this.caption,
                            ),
                          ),
                        );
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 100.0),
                        child: Container(
                          alignment: Alignment(1.0, 1.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                          ),
                          child: Hero(
                            tag: this.id,
                            child: CachedNetworkImage(imageUrl: imgUrl, fit: BoxFit.fitWidth),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                      child: Hero(
                        tag: 'caption-${this.id}',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(this.caption, textAlign: TextAlign.left, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Colors.black87)),
                        ),
                      )),
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
  const HeroPhotoViewWrapper({
    this.imageProvider,
    this.loadingChild,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.caption,
    this.id,
  });

  final Decoration backgroundDecoration;
  final int id;
  final ImageProvider imageProvider;
  final Widget loadingChild;
  final dynamic maxScale;
  final dynamic minScale;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
                constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height,
                ),
                child: PhotoView(
                    imageProvider: imageProvider,
                    // loadingChild: loadingChild,
                    loadingBuilder: (context, progress) => Center(
                          child: Container(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              value: progress == null ? null : progress.cumulativeBytesLoaded / progress.expectedTotalBytes,
                            ),
                          ),
                        ),
                    backgroundDecoration: backgroundDecoration,
                    minScale: minScale,
                    maxScale: maxScale,
                    heroAttributes: PhotoViewHeroAttributes(tag: id))),
          ),
          Positioned(
            child: Container(
                margin: EdgeInsets.only(top: 40.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 32.0,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
          ),
          Positioned(
            bottom: 0.0,
            width: MediaQuery.of(context).size.width,
            child: Hero(
              tag: 'caption-${this.id}',
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 32.0, sigmaY: 32.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.35),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        this.caption,
                        style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityGallery extends StatefulWidget {
  ActivityGallery({this.firstName, this.lastName, this.userId, this.classId});

  final String classId;
  final String firstName;
  final bool isLastItem = false;
  bool isLoading = false;
  final String lastName;
  bool noMoreImages = false;
  int pageNum = 1;
  final int pageSize = 2;
  final String userId;

  @override
  _ActivityGalleryState createState() => _ActivityGalleryState();
}

class _ActivityGalleryState extends State<ActivityGallery> {
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
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
      fetchClassImages(widget.classId, widget.pageSize, widget.pageNum).then((resolve) {
        if (_photos.length == 1 && widget.noMoreImages) {
          _photos.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "No photos yet. We'll let you know if we've got something for you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.grey[500]),
                ),
              ],
            ),
          ));
        }
      });
    });

    _scrollController.addListener(() {
      if (!widget.noMoreImages) {
        if (_scrollController.position.pixels >= (_scrollController.position.maxScrollExtent) - 100) {
          if (!widget.isLoading) {
            setState(() {
              _photos.add(Container(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                margin: EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(7.0)), color: Colors.white),
                child: Text(
                  'Fetching more photos...',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w700, fontSize: 16.0),
                ),
              ));
            });
            widget.isLoading = true;
            _loadMore();
          }
        }
      }
    });
  }

  Future fetchClassImages(classId, pageSize, num) async {
    return await getClassImages(classId, pageSize, num).then((results) {
      setState(() {
        if (_photos.length != 1) {
          _photos.removeLast();
        }
        if (results.length == 0) {
          widget.noMoreImages = true;
        } else {
          for (int i = 0; i < results.length; i++) {
            Map photo = results[i];
            _photos.add(PhotoCard(id: _photos.length, imgUrl: '$baseServer/${photo['img_url']}', timeStamp: DateTime.parse(photo['date_posted']).toLocal(), caption: photo['caption']));
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
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
                  itemBuilder: (context, i) {
                    return _photos[i];
                  },
                  controller: _scrollController,
                  shrinkWrap: true,
                ),
              )),
        ],
      )),
    );
  }
}
