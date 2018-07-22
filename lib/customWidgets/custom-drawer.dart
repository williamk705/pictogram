import 'package:flutter/material.dart';
import '../routes/picture-fave.dart';
import 'dart:async';

/// A Widget that is used in the picture-gallery view
/// this widget is a drawer with options and the logged in
/// users account info for display.
class CustomDrawer {

  /// The logged in users account and user information
  final _account;
  final _user;

  final context;
  Map likedPhotos;

  CustomDrawer(this.context, this.likedPhotos, this._account, this._user);

  /// Displays a circle avatar with the picture of the signed in user.
  Widget getUsersGooglePhoto(url) {
    if(url == null) {
      return new CircleAvatar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          child: new Text(_user.email[0])
      );
    }
    return new Container(
        width: 190.0,
        height: 190.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(url)
            )
        )
    );
  }

  /// Alert dialog for entering the liked photos view
  Future alert() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('No liked photos.'),
        content: new Text('Like some photos and come back later'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Close'),
          ),
        ],
      ),
    );
  }

  /// The drawer widget, displays user info, options for going to other views
  /// and for logging out.
  Widget getDrawer() {
    return new Drawer(
        child: new ListView(
            padding: const EdgeInsets.only(top: 0.0),
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: Text(
                    _user.displayName != null ? _user.displayName : '',
                    style: new TextStyle(color: Colors.blue)
                ),
                accountEmail: Text(
                    _user.email,
                    style: new TextStyle(color: Colors.blue)
                ),
                currentAccountPicture: new CircleAvatar(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    child: getUsersGooglePhoto(_user.photoUrl)
                ),
              ),
              new ListTile(
                leading: new Icon(Icons.person),
                title: new Text('Profile'),
                onTap: () {
                  print(_user);
                },
              ),
              new ListTile(
                leading: new Icon(Icons.check),
                title: new Text('Liked Photos'),
                onTap: () {
                  if(likedPhotos.length > 0) {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LikedPicturePage(likedPhotos)
                        )
                    );
                  }else {
                    alert();
                  }
                },
              ),
              new ListTile(
                leading: new Icon(Icons.power_settings_new),
                title: new Text('Logout'),
                onTap: () {
                  _account.signOut();
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              )
            ]
        )
    );
  }

}