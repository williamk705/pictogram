import 'package:flutter/material.dart';
import '../helper/file-storage.dart';
import '../helper/picture-contents.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:share/share.dart';
import './wallpaper-view.dart';

class DetailViewState extends StatefulWidget {
  final Map info;
  final Storage storage;
  final Map likedPhotos;

  DetailViewState(this.likedPhotos, this.info, {Key key, @required this.storage}) : super (key: key);

  @override
  PictureDetailView createState() => new PictureDetailView(likedPhotos, info);
}

class PictureDetailView extends State<DetailViewState> {

  Permission permission;

  Map picInfo = {};
  Map likedPhotos =  {};
  String state;

  PictureDetailView(this.likedPhotos, this.picInfo);

  @override
  initState() {
    super.initState();
    initPermissions();
  }

  initPermissions() async {
    bool permissionSuccess = await requestPermission();
    if(!permissionSuccess) {
      Navigator.pop(context);
    }
  }

  Future requestPermission() async {
    bool res = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    return res;
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget titleSelection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    PictureContents.getFirstAndLastName(this.picInfo['user']['first_name'], this.picInfo['user']['last_name']),
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  )
                ),
                Text(
                  PictureContents.getLocation(this.picInfo['user']['location'])
                )
              ]
            )
          ),
          Icon(
            Icons.star,
            color: Colors.red[500]
          ),
          Text(PictureContents.getLikes(this.picInfo['likes']))
        ]
      )
    );

    Widget textSection = Container(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 20.0),
      child: Text(
        PictureContents.getUserBiography(this.picInfo['user']['bio']),
        softWrap: true
      ),
    );

    Widget socialMediaButtons = UnicornDialer(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
        parentButtonBackground: Colors.blue,
        orientation: UnicornOrientation.HORIZONTAL,
        parentButton: Icon(Icons.add),
        childButtons: [
          UnicornButton(
              currentButton: FloatingActionButton(
                  heroTag: "instagram",
                  backgroundColor: Colors.white,
                  mini: true,
                  child: IconButton(
                      icon: Image.asset('graphics/instagram.png'),
                      tooltip: 'instagram',
                      onPressed: () {
                        final instagramUser = PictureContents.getSocialMediaUsername(picInfo['user']['instagram_username']);
                        final url = 'https://www.instagram.com/${instagramUser}';
                        if(!instagramUser.isEmpty) {
                          _launchURL(url);
                        }
                      }
                  )
              )
          ),
          UnicornButton(
              currentButton: FloatingActionButton(
                  heroTag: "Twitter",
                  backgroundColor: Colors.white,
                  mini: true,
                  child: IconButton(
                      icon: Image.asset('graphics/twitter.png'),
                      tooltip: 'twitter',
                      onPressed: () {
                        final twitterUser = PictureContents.getSocialMediaUsername(picInfo['user']['twitter_username']);
                        final url = 'https://www.twitter.com/${twitterUser}';
                        if(!twitterUser.isEmpty) {
                          _launchURL(url);
                        }
                      }
                  )
              )
          ),
          UnicornButton(
              currentButton: FloatingActionButton(
                heroTag: "Portfolio",
                backgroundColor: Colors.white,
                mini: true,
                child: IconButton(
                    icon: Image.asset('graphics/briefcase.png'),
                    tooltip: 'portfolio',
                    onPressed: () {
                      final url = PictureContents.getSocialMediaUsername(picInfo['user']['portfolio_url']);
                      if(!url.isEmpty) {
                        _launchURL(url);
                      }
                    }
                ),
              )
          ),
          UnicornButton(
              currentButton: FloatingActionButton(
                heroTag: "Share",
                backgroundColor: Colors.white,
                mini: true,
                child: IconButton(
                    icon: Icon(
                        Icons.share,
                        color: Colors.grey,
                    ),
                    tooltip: 'share',
                    onPressed: () {
                      print('open share sheet');
                      final RenderBox box = context.findRenderObject();
                        Share.share(
                          picInfo['urls']['full'],
                          sharePositionOrigin:
                          box.localToGlobal(Offset.zero) &
                          box.size
                        );
                    }
                ),
              )
          )
        ]
    );


    return new Theme (
      data: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        platform: Theme.of(context).platform
      ),
      child: new Scaffold(
        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: 256.0,
              pinned: true,
              floating: true,
              snap: true,
              actions: <Widget> [
                new IconButton(
                  icon: likedPhotos[picInfo['id']] != null
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                  color: likedPhotos[picInfo['id']] != null
                      ? Colors.red
                      : Colors.white,
                  tooltip: 'like',
                  onPressed: () {
                    super.setState((){
                      if(likedPhotos[picInfo['id']] == null) {
                        likedPhotos[picInfo['id']] = picInfo;
                      }else {
                        likedPhotos.remove(picInfo['id']);
                      }
                    });
                  }
                ),
                new IconButton(
                  icon: Icon(Icons.zoom_in),
                  color: Colors.white,
                  tooltip: 'View Picture',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WallpaperView(this.picInfo['urls']['regular']))
                    );
                  },
                ),
                new PopupMenuButton(
                  onSelected: (value) {
                    widget.storage.downloadImage(
                        '${this.picInfo['id']}-${value['type']}.jpg', value['data']
                    );
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuItem<Map>>[
                    new PopupMenuItem<Map> (
                      value: {'data': this.picInfo['urls']['thumb'], 'type': 'thumbnail'},
                      child: new Text('Download as Thumbnail'),
                    ),
                    new PopupMenuItem<Map> (
                      value: {'data': this.picInfo['urls']['regular'], 'type': 'regular'},
                      child: new Text('Download Regular Image'),
                    ),
                    new PopupMenuItem<Map> (
                      value: {'data': this.picInfo['urls']['full'], 'type': 'full'},
                      child: new Text('Download Full Image'),
                    ),
                    new PopupMenuItem<Map> (
                      value: {'data': this.picInfo['urls']['raw'], 'type': 'raw'},
                      child: new Text('Download Raw Image'),
                    )
                  ],
                ),
              ],
              flexibleSpace: new FlexibleSpaceBar(
                background: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Image.network(
                      this.picInfo['urls']['small'],
                      fit: BoxFit.cover,
                      height: 256.0
                    ),
                    const DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: const LinearGradient(
                          begin: const Alignment(0.0, -1.0),
                          end: const Alignment(0.0, -0.4),
                          colors: const <Color>[const Color(0x60000000), const Color(0x00000000)],
                        )
                      ),
                    ),
                  ]
                )
              ),
            ),
            new SliverList(
              delegate: new SliverChildListDelegate(<Widget> [
                titleSelection,
                textSection,
              ]),
            ),
          ],
        ),
        floatingActionButton: socialMediaButtons
      )
    );
  }
}
