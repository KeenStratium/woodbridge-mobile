import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('myWoodbridge'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "The name 'Woodbridge'",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 24.0
                  ),
                ),
              ),
              Text(
                'Wood implies flexibility and sturdiness, and bridge implies a connection between two environments. At Woodbridge, we pave the way for young children to realize their unique giftedness.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Our Vision",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                'A premier preparatory preschool committed to a dynamic and integrated education to develop children into lifelong learners.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Our Mission",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                'The Woodbridge Academy aims to foster a school community that awakens, nurtures, and empowers the uniqueness of each child.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "The Drive for Excellence",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                "Guided by an eclectic philosophy, our integrated curriculum effectively employs developmentally appropriate strategies that promote the child's smooth transition into the big schools.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Strengthening Character",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                "Spanning our entire curriculum is the Virtues Integration Program (VIP). The VIP, through its unique process, ensures that virtues and values do not simply become a subject, but a way of life. It has been, since its initial conception in 2006, the trademark of a Woodbridge education.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
