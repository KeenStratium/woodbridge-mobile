import 'package:flutter/material.dart';
import 'woodbridge-ui_components.dart';

class GalleryPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800]
              ),
            ),
          ),
          Text('Album Name'),
          Text('10 photos'),
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
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    GalleryPreview(),
                    GalleryPreview()
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