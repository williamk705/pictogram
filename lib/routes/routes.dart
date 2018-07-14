import 'package:flutter/material.dart';
import './login-page.dart';
import './picture-gallery.dart';

final routes = {
  '/login': (BuildContext context) => new LoginPage(),
  //'/home': (BuildContext context) => new PictureGallery(),
  '/': (BuildContext context) => new LoginPage()
};
