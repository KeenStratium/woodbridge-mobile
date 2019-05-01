import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

class GalleryPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Colors.grey[800]
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Album Name',
                  style: TextStyle(
                    fontSize: 14.0
                  ),
                ),
              ),
              Text(
                '10 photos',
                style: TextStyle(
                  fontSize: 12.0
                ),
              ),
            ],
          ),
        ],
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
              child: GridView.count(
                crossAxisCount: 2,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  GalleryPreview(),
                  GalleryPreview(),
                  GalleryPreview(),
                  GalleryPreview()
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}