import 'package:flutter/material.dart';
import './routes/routes.dart';

void main() => runApp(new GalleryView());

class GalleryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = new ThemeData(
      primaryColor: Colors.white,
      accentColor: Colors.blue
    );
    return new MaterialApp(
      title: 'Photo Gallery',
      theme: theme,
      routes: routes,
    );
  }
}
