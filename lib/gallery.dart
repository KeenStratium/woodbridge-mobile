import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';
import 'GalleryDetail.dart';

class GalleryPreview extends StatelessWidget {
  final String heroTag;
  final String imgPath;
  final String name;
  final String subName;

  GalleryPreview({
    this.heroTag,
    this.imgPath,
    this.name,
    this.subName
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: new Container(
        child: new Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.vertical,
          children: <Widget>[
            Hero(
              tag: this.heroTag,
              child: Material(
                child: InkWell(
                  onTap: () =>
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new GalleryDetail(
                        galleryName: this.name,
                        heroTag: this.heroTag,
                        imgPath: this.imgPath,
                      ),
                    )),
                  child: new Image.asset(
                    this.imgPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        this.name,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Text(
                      this.subName,
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

class ActivityGallery extends StatelessWidget {
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
            ProfileHeader(
              profileName: 'Kion Kefir C. Gargar',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    GalleryPreview(
                      heroTag: 'aquaman',
                      imgPath: 'img/aquaman.jpg',
                      name: 'Album name 1',
                      subName: '10 photos'
                    ),
                    GalleryPreview(
                      heroTag: 'venom',
                      imgPath: 'img/venom.jpg',
                      name: 'Album name 2',
                      subName: '8 photos'
                    ),
                    GalleryPreview(
                      heroTag: 'flash',
                      imgPath: 'img/flash.jpg',
                      name: 'Album name 3',
                      subName: '12 photos'
                    ),
                    GalleryPreview(
                      heroTag: 'superman',
                      imgPath: 'img/superman.jpg',
                      name: 'Album name 4',
                      subName: '15 photos'
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}