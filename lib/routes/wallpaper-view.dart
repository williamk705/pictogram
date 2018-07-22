import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../helper/alert-modal.dart';

class WallpaperView extends StatefulWidget{
  final picInfo;

  WallpaperView(this.picInfo);

  @override
  Wallpaper createState() => new Wallpaper(picInfo);
}

class Wallpaper extends State<WallpaperView> {

  final picInfo;
  static const MethodChannel methodChannel = const MethodChannel('samples.flutter.io/wallpaper');

  Wallpaper(this.picInfo);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  Future _setWallpaper() async {
    var request = await http.get(picInfo);
    List picBytes = await request.bodyBytes;
    try {
      final String result = await methodChannel.invokeMethod('setAndroidWallpaper', <String, dynamic>{
        'data': picBytes
      });
      if(result == 'success') {
        Popups.alert(
          context,
          'Success',
          'Your wallpaper has been updated.'
        );
      }
    } on PlatformException {
      print('Not supported by IOS');
      Popups.alert(
        context,
        'Failure',
        'Wallpaper update not supported by IOS'
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Theme (
      data: new ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.indigo,
          platform: Theme.of(context).platform
      ),
      child: new Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height - 24.0,
              pinned: true,
              floating: true,
              snap: true,
              flexibleSpace: new FlexibleSpaceBar(
                background: new Container(
                    alignment: Alignment.bottomLeft,
                    padding: new EdgeInsets.only(left: 12.0, right: 12.0),
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new NetworkImage(picInfo),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(bottom: 10.0)
                        ),
                        new MaterialButton(
                          height: 40.0,
                          minWidth: 350.0,
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                          textColor: Colors.white,
                          child: Text('SET AS WALLPAPER'),
                          onPressed: () {
                            _setWallpaper();
                          },
                        ),
                      ],
                    )
                ),
              ),
            )
          ],
        )
      )
    );
  }
}