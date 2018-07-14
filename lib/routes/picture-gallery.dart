import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../customWidgets/custom-drawer.dart';
import './picture-details.dart';
import '../helper/file-storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PictureGallery extends StatefulWidget {

  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _googleAccount;

  PictureGallery(this._googleSignIn, this._googleAccount);

  @override
  createState() => new PictureGalleryState(_googleSignIn, _googleAccount);
}

class PictureGalleryState extends State<PictureGallery> {

  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _googleAccount;

  List<dynamic> data = [];
  var settings = {
    'Authorization': 'Client-ID 422f5a13a02dd79ea1b18cc1e8ac15efe5ea52752c98f9cfa788a7788ba69911',
  };
  Map likedPhotos = {};
  int page = 1;
  bool searchFieldActive = false;
  bool searchTypeOn = false;
  String searchQuery = '';

  PictureGalleryState(this._googleSignIn, this._googleAccount);

  @override
  void initState() {
    this.initPhotos();
  }

  /*
    URL params
    orientation: portrait, landscape, square
    query: <type your query>
  */
  Future initPhotos() async {
    var response = await http.get(
      Uri.encodeFull('https://api.unsplash.com/photos'),
      headers: this.settings,
    );

    this.setState(() {
      data = json.decode(response.body).toList();
    });
  }

  Future queryPhotos(query) async {
    var response = await http.get(
      Uri.encodeFull('https://api.unsplash.com/search/photos?page=1&query=${query}'),
      headers: this.settings,
    );

    this.setState(() {
      data = json.decode(response.body)['results'].toList();
    });
  }

  Future loadMorePhotos() async {
    page += 1;
    var search = searchTypeOn
        ? 'https://api.unsplash.com/search/photos?page=${page}&query=${searchQuery}'
        : 'https://api.unsplash.com/photos?page=${page}';
    var response = await http.get(
      Uri.encodeFull(search),
      headers: this.settings,
    );

    this.setState(() {
      List tempData = searchTypeOn
          ? json.decode(response.body)['results'].toList()
          : json.decode(response.body).toList();
      for (var i = 0; i < tempData.length; i++) {
        data.add(tempData[i]);
      }
    });
  }


  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to logout?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () {
              _googleSignIn.disconnect();
              Navigator.of(context).pop(true);
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  Widget customScaffold() {
    return new Scaffold(
        appBar: new AppBar(
            iconTheme: IconThemeData(
                color: Colors.blue
            ),
            title: searchFieldActive ? TextField(
              autofocus: true,
              decoration: InputDecoration.collapsed(
                  hintText: 'Search for photos'
              ),
              onSubmitted: (text) {
                print(text);
                page = 1;
                searchQuery = text;
                if(text == '') {
                  searchTypeOn = false;
                  initPhotos();
                }else {
                  searchTypeOn = true;
                  queryPhotos(text);
                }
              },
            ) : new Text(''),
            actions: <Widget> [
              new IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'search',
                  onPressed: () {
                    setState(() {
                      searchFieldActive = !searchFieldActive;
                    });
                  }
              )
            ]
        ),
        body: Center(
            child: new GridView.builder(
              itemCount: data.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                if (index >= data.length - 1) {
                  loadMorePhotos();
                }
                return new GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailViewState(likedPhotos, data[index], storage: Storage()))
                      );
                    },
                    child: Container(
                        decoration: new BoxDecoration(
                            color: const Color(0xff7c94b6),
                            image: new DecorationImage(
                                image: NetworkImage(data[index]['urls']['thumb']),
                                fit: BoxFit.cover
                            ),
                            border: new Border.all (
                                color: Colors.white,
                                width: 8.0
                            )
                        )
                    )
                );
              },
            )
        ),
        drawer: CustomDrawer(context, likedPhotos, _googleSignIn, _googleAccount).getDrawer()
    );
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(child: customScaffold(), onWillPop: _onWillPop);
  }
}