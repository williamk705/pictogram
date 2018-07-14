import 'package:flutter/material.dart';
import '../routes/picture-fave.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class CustomDrawer {

  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _googleAccount;
  final context;
  Map likedPhotos;

  CustomDrawer(this.context, this.likedPhotos, this._googleSignIn, this._googleAccount);

  Widget getUsersGooglePhoto(url) {
    if(url == null) {
      List<String> name = _googleAccount.displayName.split(new RegExp('\\s+'));
      String out;
      if(name.length == 1) {
        out = name[0][0];
      }else if (name.length >= 2) {
        out = '${name[0][0]}${name[1][0]}';
      }

      return new Text(out);
    }

    return new Text('');
  }

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

  Widget getDrawer() {
    return new Drawer(
        child: new ListView(
            padding: const EdgeInsets.only(top: 0.0),
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: Text(
                    _googleAccount.displayName,
                    style: new TextStyle(color: Colors.blue)
                ),
                accountEmail: Text(
                    _googleAccount.email,
                    style: new TextStyle(color: Colors.blue)
                ),
                currentAccountPicture: new CircleAvatar(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    child: getUsersGooglePhoto(_googleAccount.photoUrl)
                ),
              ),
              new ListTile(
                leading: new Icon(Icons.person),
                title: new Text('Profile'),
                onTap: () {
                  print(_googleAccount);
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
                            builder: (context) => LikedPicturePage(likedPhotos))
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
                  _googleSignIn.disconnect();
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              )
            ]
        )
    );
  }

}