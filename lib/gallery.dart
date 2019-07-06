import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'package:photo_view/photo_view.dart';

class PhotoCard extends StatelessWidget {
  GlobalKey stickyKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32.0),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '8:21am',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
              ],
            ),
          ),
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
                          'Teacher Lulu',
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
                            builder: (context) => const HeroPhotoViewWrapper(
                              imageProvider: NetworkImage('https://imageoptimizer.in/optimize/uploads/p9ygh.jpeg')
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
                            tag: "someTag",
                            child:  Image.network(
                              'https://imageoptimizer.in/optimize/uploads/p9ygh.jpeg',
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
      this.maxScale});

  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

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
          heroTag: "someTag",
        ));
  }
}

class ActivityGallery extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String userId;

  ActivityGallery({
    this.firstName,
    this.lastName,
    this.userId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Gallery'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Flexible(
                flex: 0,
                child: ProfileHeader(
                  firstName: this.firstName,
                  lastName: this.lastName,
                  heroTag: this.userId,
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  padding: EdgeInsets.only(bottom: 40.0),
                  margin: EdgeInsets.symmetric(horizontal: 6.0),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      PhotoCard(),
                    ],
                  ),
                )
              )
            ],
          ),
        )
      ),
    );
  }
}