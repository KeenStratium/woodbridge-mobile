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

  void open(BuildContext context, final int index) {
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (context) => GalleryPhotoViewWrapper(
//          galleryItems: galleryItems,
//          backgroundDecoration: const BoxDecoration(
//            color: Colors.black,
//          ),
//          initialIndex: index,
//        ),
//      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.galleryName),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Hero(
                    tag: this.heroTag,
                    child: new Image.asset(
                      this.imgPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 1.0,
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    children: <Widget>[
                      FittedBox(
                        fit: BoxFit.cover,
                        child: GalleryExampleItemThumbnail(
                          galleryExampleItem: galleryItems[0],
                          onTap: () {
                            open(context, 0);
                          },
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.cover,
                        child: GalleryExampleItemThumbnail(
                          galleryExampleItem: galleryItems[1],
                          onTap: () {
                            open(context, 1);
                          },
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.cover,
                        child: GalleryExampleItemThumbnail(
                          galleryExampleItem: galleryItems[2],
                          onTap: () {
                            open(context, 2);
                          },
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.cover,
                        child: GalleryExampleItemThumbnail(
                          galleryExampleItem: galleryItems[3],
                          onTap: () {
                            open(context, 3);
                          },
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.cover,
                        child: GalleryExampleItemThumbnail(
                          galleryExampleItem: galleryItems[4],
                          onTap: () {
                            open(context, 4);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GalleryExampleItem {
  GalleryExampleItem({this.id, this.resource});

  final String id;
  final String resource;
}

class GalleryExampleItemThumbnail extends StatelessWidget {
  const GalleryExampleItemThumbnail(
      {Key key, this.galleryExampleItem, this.onTap})
      : super(key: key);

  final GalleryExampleItem galleryExampleItem;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: GestureDetector(
          onTap: onTap,
          child: Hero(
            tag: galleryExampleItem.id,
            child: Image.asset(galleryExampleItem.resource, height: 80.0),
          ),
        ));
  }
}

List<GalleryExampleItem> galleryItems = <GalleryExampleItem>[
  GalleryExampleItem(
    id: "tag1",
    resource: "img/hulk.jpg",
  ),
  GalleryExampleItem(
    id: "tag3",
    resource: "img/catwoman.jpg",
  ),
  GalleryExampleItem(
    id: "tag4",
    resource: "img/ironman.jpg",
  ),
  GalleryExampleItem(
    id: "tag5",
    resource: "img/spiderman.jpg",
  ),
  GalleryExampleItem(
    id: "tag6",
    resource: "img/captain.jpg",
  ),
];

