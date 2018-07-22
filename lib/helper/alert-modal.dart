import 'dart:async';
import 'package:flutter/material.dart';

class Popups {

  static Future alert(BuildContext context, String titleText, String contentText) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(titleText),
        content: new Text(contentText),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Close'),
          ),
        ],
      ),
    );
  }

}