import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class PictureContents {

  static String getFirstAndLastName(firstName, lastName) {
    if(firstName == null) {
      return 'Anonymous';
    }else if(lastName == null) {
      return firstName;
    }
    return '${firstName} ${lastName}';
  }

  static String getLocation(location) {
    if(location == null) {
      return 'No Picture Location';
    }
    return location;
  }

  static String getLikes(likes) {
    return likes.toString();
  }

  static String getDescription(description) {
    if(description == null) {
      return 'No Description';
    }
    return description;
  }

  static String getUserBiography(bio) {
    if(bio == null) {
      return 'Empty User Biography';
    }
    return bio;
  }

  static String getSocialMediaUsername(uname) {
    if(uname == null) {
      return '';
    }
    return uname;
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/config.json');
  }
}