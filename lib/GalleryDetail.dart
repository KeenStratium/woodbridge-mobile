import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
        ),
      ));
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

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper(
      {this.loadingChild,
        this.backgroundDecoration,
        this.minScale,
        this.maxScale,
        this.initialIndex,
        @required this.galleryItems})
      : pageController = PageController(initialPage: initialIndex);

  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<GalleryExampleItem> galleryItems;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;
  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: galleryItems.length,
                loadingChild: widget.loadingChild,
                backgroundDecoration: widget.backgroundDecoration,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
              ),
              Positioned(
                  left: 20,
                  top: 50,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  )
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Image ${currentIndex + 1}",
                  style: const TextStyle(
                      color: Colors.white, fontSize: 17.0, decoration: null),
                ),
              )
            ],
          )),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final GalleryExampleItem item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: AssetImage(item.resource),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
      heroTag: item.id,
    );
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

