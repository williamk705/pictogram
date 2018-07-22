import 'package:flutter/material.dart';
import '../helper/picture-contents.dart';
import '../routes/picture-details.dart';
import '../helper/file-storage.dart';
import '../models.dart';

class LikedPicturePage extends StatefulWidget {

  static const String routeName = '/LikedPicturePage';
  final String title;
  final Map likedPhotos;

  LikedPicturePage(this.likedPhotos, {Key key, this.title}): super(key: key);

  LikedPictureState createState() => new LikedPictureState(likedPhotos);
}

class LikedPictureState extends State<LikedPicturePage> {

  Map likedPhotos;
  List likedPhotosList;

  LikedPictureState(this.likedPhotos);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      likedPhotosList = likedPhotos.keys.toList();
    });

    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue
        ),
      ),
      body: Center(
        child: new ListView.builder(
          itemCount: likedPhotosList.length,
          itemBuilder: (BuildContext context, index) {
            final item = likedPhotosList[index];
            final picture = likedPhotos[item].urls.thumb;
            final firstName = likedPhotos[item].user.firstName;
            final lastName = likedPhotos[item].user.lastName;
            final location = likedPhotos[item].user.location;

            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              leading: new CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.blue,
                backgroundImage: NetworkImage(picture),
              ),
              title: Text(PictureContents.getFirstAndLastName(firstName, lastName)),
              subtitle: Text(PictureContents.getLocation(location)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailViewState(likedPhotos, likedPhotos[likedPhotosList[index]], storage: Storage()))
                );
              },
            );
          },
        )
      )
    );
  }
}