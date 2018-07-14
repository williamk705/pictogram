import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Storage {

  Future<String> get localFileLocation async {
    final dir = await getExternalStorageDirectory();
    return dir.path;
  }

  void downloadImage(String filename, String picUri) async {
    final location = await localFileLocation;
    var request = await http.get(picUri,);
    var bytes = await request.bodyBytes;
    File file = new File('$location/Download/unsplash-$filename');
    await file.writeAsBytes(bytes);
  }

}
