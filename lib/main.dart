import 'package:flutter/material.dart';
import 'package:instagram_big_picture/pages/home/home_page.dart';
import 'package:instagram_big_picture/pages/picture_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    var path = settings.name.split("/");
    if (path[1] == "picture") {
      return new MaterialPageRoute(
          builder: (BuildContext context) =>
              new PicturePage(fullName: path[2], url: path[3]),
          settings: settings);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Instagram Big Picture',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      onGenerateRoute: onGenerateRoute,
      home: new HomePage(),
    );
  }
}
