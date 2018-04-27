import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/zoomable_widget.dart';
import 'package:flutter_advanced_networkimage/transition_to_image.dart';

class PicturePage extends StatelessWidget {
  PicturePage({this.url, this.fullName});
  final String url, fullName;
  void shareImage(){
    // TODO: implement onGetUserInfoEnd
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(Uri.decodeQueryComponent(fullName)),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.share),
            onPressed: shareImage,
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: new ZoomableWidget(
        minScale: .7,
        maxScale: 4.0,
        child: new Container(
          child: new TransitionToImage(
            new NetworkImage(Uri.decodeQueryComponent(url)),
            duration: new Duration(seconds: 1),
          ),
        ),
      ),
    );
  }
}
