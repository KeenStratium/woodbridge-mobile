import 'package:flutter/material.dart';

class GalleryDetail extends StatelessWidget {
  final String galleryName;
  final String heroTag;
  final String imgPath;

  GalleryDetail({
    this.galleryName,
    this.heroTag,
    this.imgPath
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.galleryName),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              child: Hero(
                tag: this.heroTag,
                child: new Image.asset(
                  this.imgPath,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}